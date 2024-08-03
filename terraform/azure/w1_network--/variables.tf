variable "resource_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "prefix" {
  type        = string
  default     = "win-vm-iis"
  description = "Prefix of the resource name"
}

variable "proj" {
  type        = string
  default     = "core"
  description = "Name of the project"
}