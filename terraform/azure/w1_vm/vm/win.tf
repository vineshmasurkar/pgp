variable "proj" {
  type    = string
  default = "<proj_name>"
}

## Resource Group Config - Object
variable "rg_config" {
  type = object({
    name      = string
    location  = string
  })
}

## Resource Group Config - Object
variable "nic_id" {
  type    = string
  default = "<nic_id>"
}

## Create Windows-IIS Web Server virtual machine
resource "azurerm_windows_virtual_machine" "win_iis_vm" {
  name                  = "${var.proj}-vm" ## Windows VM names may not contain '_' or '.'. (may only contain alphanumeric characters and dashes.)
  admin_username        = "azureuser"
  admin_password        = "CorePassword123"
  location              = var.rg_config.location
  resource_group_name   = var.rg_config.name
  network_interface_ids = [var.nic_id]
  size                  = "Standard_B1s" ## 1 vcpu, 1 GiB memory
  ## The free account includes access to three types of VMs for free
  ##  — the B1S, B2pts v2 (ARM-based), and B2ats v2 (AMD-based) 
  ##  burstable VMs that are usable for up to 750 hours per month.

  # custom_data           = file("custom-data.ps1") ## NOT POSSIBLE FOR WIN SERVER
  os_disk {
    name                 = "${var.proj}_os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  # boot_diagnostics {
  #   storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  # }
}

## Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "win_iis_web_server_install_ext" {
  name                       = "${var.proj}_iis_web_server_install_ext"
  virtual_machine_id         = azurerm_windows_virtual_machine.win_iis_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true
  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
  SETTINGS
}

## Attach azure-manged data disk to virtual machine
resource "azurerm_managed_disk" "win-data-disk" {
  name                  = "${var.proj}_data_disk"
  location              = var.rg_config.location
  resource_group_name   = var.rg_config.name
  storage_account_type  = "Standard_LRS"
  create_option         = "Empty"
  disk_size_gb          = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "win_data_disk_attach" {
  managed_disk_id    = azurerm_managed_disk.win-data-disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.win_iis_vm.id
  lun                ="10"
  caching            = "ReadWrite"
}

# # Create storage account for boot diagnostics
# resource "azurerm_storage_account" "my_storage_account" {
#   name                     = "diag${random_id.random_id.hex}"
#   location                 = azurerm_resource_group.rg.location
#   resource_group_name      = azurerm_resource_group.rg.name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

##--------------------------------------------------------------------------------
# # Create public IPs
# resource "azurerm_public_ip" "my_terraform_public_ip" {
#   name                = "${random_pet.prefix.id}-public-ip"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Dynamic"
# }

# # Create Network Security Group and rules
# resource "azurerm_network_security_group" "my_terraform_nsg" {
#   name                = "${random_pet.prefix.id}-nsg"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   security_rule {
#     name                       = "RDP"
#     priority                   = 1000
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     name                       = "web"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# # Create network interface
# resource "azurerm_network_interface" "my_terraform_nic" {
#   name                = "${random_pet.prefix.id}-nic"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "my_nic_configuration"
#     subnet_id                     = azurerm_subnet.my_terraform_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
#   }
# }

# # Connect the security group to the network interface
# resource "azurerm_network_interface_security_group_association" "example" {
#   network_interface_id      = azurerm_network_interface.my_terraform_nic.id
#   network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
# }

# # Create storage account for boot diagnostics
# resource "azurerm_storage_account" "my_storage_account" {
#   name                     = "diag${random_id.random_id.hex}"
#   location                 = azurerm_resource_group.rg.location
#   resource_group_name      = azurerm_resource_group.rg.name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }


# # Create virtual machine
# resource "azurerm_windows_virtual_machine" "main" {
#   name                  = "${var.prefix}-vm"
#   admin_username        = "azureuser"
#   admin_password        = random_password.password.result
#   location              = azurerm_resource_group.rg.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
#   size                  = "Standard_DS1_v2"

#   os_disk {
#     name                 = "myOsDisk"
#     caching              = "ReadWrite"
#     storage_account_type = "Premium_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2022-datacenter-azure-edition"
#     version   = "latest"
#   }


#   boot_diagnostics {
#     storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
#   }
# }

# # Install IIS web server to the virtual machine
# resource "azurerm_virtual_machine_extension" "web_server_install" {
#   name                       = "${random_pet.prefix.id}-wsi"
#   virtual_machine_id         = azurerm_windows_virtual_machine.main.id
#   publisher                  = "Microsoft.Compute"
#   type                       = "CustomScriptExtension"
#   type_handler_version       = "1.8"
#   auto_upgrade_minor_version = true

#   settings = <<SETTINGS
#     {
#       "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
#     }
#   SETTINGS
# }

# # Generate random text for a unique storage account name
# resource "random_id" "random_id" {
#   keepers = {
#     # Generate a new ID only when a new resource group is defined
#     resource_group = azurerm_resource_group.rg.name
#   }

#   byte_length = 8
# }

# resource "random_password" "password" {
#   length      = 20
#   min_lower   = 1
#   min_upper   = 1
#   min_numeric = 1
#   min_special = 1
#   special     = true
# }

# resource "random_pet" "prefix" {
#   prefix = var.prefix
#   length = 1
# }