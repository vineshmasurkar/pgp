variable "resource_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  default = "pgp_rg"
  description = "Name of the resource group manually created in Azure"
}

variable "prefix" {
  type        = string
  default     = "win-vm-iis"
  description = "Prefix of the resource name"
}

variable "proj" {
  type        = string
  default     = "matmos"
  description = "Name of the project"
}

## Resource Group Config - Object
variable "rg_config" {
  type = object({
    name      = string
    location  = string
  })
  default = {
    name      = "<name>"
    location  = "<location>"
  }
}