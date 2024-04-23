using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using Azure.Storage.Blobs;

public static class QueueToBlobFunction
{
    [FunctionName("QueueToBlobFunction")]
    public static async Task Run(
        [QueueTrigger("%QUEUE_NAME%", Connection = "AzureWebJobsStorage")] string queueItem,
        ILogger log)
    {
        log.LogInformation($"Received queue item: {queueItem}");

        try
        {
            var connectionString = Environment.GetEnvironmentVariable("AzureWebJobsStorage");
            var containerName = Environment.GetEnvironmentVariable("STORAGE_CONTAINER");

            if (string.IsNullOrEmpty(connectionString) || string.IsNullOrEmpty(containerName))
            {
                log.LogError("Storage connection string or container name is not set in the environment variables.");
                return;
            }

            var blobServiceClient = new BlobServiceClient(connectionString);
            var blobContainerClient = blobServiceClient.GetBlobContainerClient(containerName);
            
            // Ensure container exists
            await blobContainerClient.CreateIfNotExistsAsync();

            var blobClient = blobContainerClient.GetBlobClient($"message-{Guid.NewGuid()}.json");

            using (var ms = new MemoryStream())
            {
                var writer = new StreamWriter(ms);
                writer.Write(queueItem);
                writer.Flush();
                ms.Position = 0;
                await blobClient.UploadAsync(ms, true);
            }

            log.LogInformation("Queue item successfully written to blob.");
        }
        catch (Exception ex)
        {
            log.LogError($"Error processing queue item: {ex.Message}");
            throw; // Re-throwing the exception to ensure it gets logged in the Azure monitoring tools
        }
    }
}
