variable "location" {
  description = "Azure region to deploy resources."
  default     = "East US"
}

variable "resource_group_name" {
  description = "Enter resource group name"
  type        = string
}

variable "storage_account_name" {
  description = "Enter storage account name"
  type        = string
}

variable "queue_name" {
  description = "enter queue name"
  default     = "myqueue"
}

variable "container_name" {
  description = "enter container name"
  default     = "mycontainer"
}
