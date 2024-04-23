variable "location" {
  description = "Azure region to deploy resources."
  default     = "East US"
}

variable "resource_group_name" {
  description = "greeresourcegrp"
  type        = string
}

variable "storage_account_name" {
  description = "greestorageacc"
  type        = string
}

variable "queue_name" {
  description = "greequeue"
  default     = "myqueue"
}

variable "container_name" {
  description = "greeblobcont"
  default     = "mycontainer"
}
