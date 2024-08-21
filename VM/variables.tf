variable "azure_location" {
  description = "Azure location"
  type        = string
  default     = "East US"
}

variable "azure_resource_group" {
  description = "Azure resource group name"
  type        = string
  default     = "1-a729807f-playground-sandbox"
}

variable "azure_vm_admin_password" {
  description = "Password for admin"
  type        = string
  default     = "Pr0v1dePasswordInCommandLine!"
}