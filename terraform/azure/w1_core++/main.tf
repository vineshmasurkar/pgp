## Create resource group
resource "azurerm_resource_group" "core_rg" {
  # name     = "${random_id.prefix.id}-rg"
  name     = "core_rg"
  location = var.resource_location
}

## Create virtual network
resource "azurerm_virtual_network" "core_vnet" {
  name                = "core_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.core_rg.location
  resource_group_name = azurerm_resource_group.core_rg.name
}

## Create subnets
resource "azurerm_subnet" "core_sn1" {
  name                 = "core_sn1"
  resource_group_name  = azurerm_resource_group.core_rg.name
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = ["10.0.0.0/28"]
}

resource "azurerm_subnet" "core_sn2" {
  name                 = "core_sn2"
  resource_group_name  = azurerm_resource_group.core_rg.name
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = ["10.0.0.64/28"]
}

## Create public IPs
resource "azurerm_public_ip" "core_pub_ip" {
  name                = "core_pub_ip"
  ip_version          = "IPv4"
  location            = azurerm_resource_group.core_rg.location
  resource_group_name = azurerm_resource_group.core_rg.name
  allocation_method   = "Dynamic"
}

## Create Network Security Group and rules
resource "azurerm_network_security_group" "core_nsg" {
  name                = "core_nsg"
  location            = azurerm_resource_group.core_rg.location
  resource_group_name = azurerm_resource_group.core_rg.name
  security_rule { ## assign security Rule: Method 1
    name                       = "RDP" ## Remote Desktop Protocol
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

## assign security Rule: Method 2
resource "azurerm_network_security_rule" "allow_tcp_nsr" {
  name                        = "allow_tcp_nsr"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.core_rg.name
  network_security_group_name = azurerm_network_security_group.core_nsg.name
}

## Associate the network sequrity group to subnets
resource "azurerm_subnet_network_security_group_association" "core_nsg_sn1" {
  subnet_id                 = azurerm_subnet.core_sn1.id
  network_security_group_id = azurerm_network_security_group.core_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "core_nsg_sn2" {
  subnet_id                 = azurerm_subnet.core_sn2.id
  network_security_group_id = azurerm_network_security_group.core_nsg.id
}

## Create network interface
resource "azurerm_network_interface" "core_nic" {
  name                = "core_nic"
  location            = azurerm_resource_group.core_rg.location
  resource_group_name = azurerm_resource_group.core_rg.name
  ip_configuration { ## public dynamic ip
    name                          = "core_pub_ip_config"
    subnet_id                     = azurerm_subnet.core_sn1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.core_pub_ip.id
    primary                       = true
  }
  ip_configuration { ## private static ip
    name                          = "core_pvt_ip_config"
    subnet_id                     = azurerm_subnet.core_sn1.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.10.0.56/27"
    #public_ip_address_id          = azurerm_public_ip.core_pub_ip.id
  }
}

## Associate the security group to the network interface
resource "azurerm_network_interface_security_group_association" "core_sg_nic" {
  network_interface_id      = azurerm_network_interface.core_nic.id
  network_security_group_id = azurerm_network_security_group.core_nsg.id
}

## Create virtual machine
resource "azurerm_windows_virtual_machine" "core_vm" {
  name                  = "core-vm" ## "computer_name" may only contain alphanumeric characters and dashes. 
  admin_username        = "azureuser"
  admin_password        = "CorePassword123"
  location              = azurerm_resource_group.core_rg.location
  resource_group_name   = azurerm_resource_group.core_rg.name
  network_interface_ids = [azurerm_network_interface.core_nic.id]
  size                  = "Standard_B1s" ## 1 vcpu, 1 GiB memory
  os_disk {
    name                 = "coreOsDisk"
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

## Attach azure-manged data disk to virtual machine
resource "azurerm_managed_disk" "core-data-disk" {
  name                  = "core-data-disk"
  location              = azurerm_resource_group.core_rg.location
  resource_group_name   = azurerm_resource_group.core_rg.name
  storage_account_type  = "Standard_LRS"
  create_option         = "Empty"
  disk_size_gb          = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "core_data_disk_attach" {
  managed_disk_id    = azurerm_managed_disk.core-data-disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.core_vm.id
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