data "azurerm_resource_group" "main_rg" {
  name = var.resource_group_name
}

# ## Create resource group
# resource "azurerm_resource_group" "main_rg" {
#   # name     = "${random_id.prefix.id}-rg"
#   name     = "${var.proj}_rg"
#   location = var.resource_location
# }

## Create virtual network
resource "azurerm_virtual_network" "main_vnet" {
  name                = "${var.proj}_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_location
  resource_group_name = var.resource_group_name
}

## Create subnets
resource "azurerm_subnet" "main_pub_sn" {
  name                 = "${var.proj}_pub_sn"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.0.0/28"]
}

resource "azurerm_subnet" "main_pvt_sn" {
  name                 = "${var.proj}_pvt_sn"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.0.64/28"]
}

## Create public IPs
resource "azurerm_public_ip" "main_pub_ip" {
  name                = "${var.proj}_pub_ip"
  ip_version          = "IPv4"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "main_pvt_ip" {
  name                = "${var.proj}_pvt_ip"
  ip_version          = "IPv4"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

## Create Network Security Group and rules
resource "azurerm_network_security_group" "main_nsg" {
  name                = "${var.proj}_nsg"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  
  ## assign security Rule: Method 1
    security_rule { 
    name                       = "SSH" 
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule { 
    name                       = "MySQL" 
    priority                   = 125
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule { 
    name                       = "RDP" ## Remote Desktop Protocol
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule { 
    name                       = "HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule { 
    name                       = "HTTPS"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

## assign security Rule: Method 2
resource "azurerm_network_security_rule" "main_allow_tcp_nsr" {
  name                        = "allow_tcp_nsr"
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main_nsg.name
}

## Associate the network sequrity group to subnets
resource "azurerm_subnet_network_security_group_association" "main_nsg_pub_sn" {
  subnet_id                 = azurerm_subnet.main_pub_sn.id
  network_security_group_id = azurerm_network_security_group.main_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "main_nsg_pvt_sn" {
  subnet_id                 = azurerm_subnet.main_pvt_sn.id
  network_security_group_id = azurerm_network_security_group.main_nsg.id
}

## Create network interface
resource "azurerm_network_interface" "main_pub_nic" {
  name                = "${var.proj}_pub_nic"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  ip_configuration { ## public dynamic ip
    name                          = "${var.proj}_pub_ip_config"
    subnet_id                     = azurerm_subnet.main_pub_sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main_pub_ip.id
    primary                       = true
  }
  ip_configuration { ## private static ip
    name                          = "${var.proj}_pvt_ip_config"
    subnet_id                     = azurerm_subnet.main_pub_sn.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "main_pvt_nic" {
  name                = "${var.proj}_pvt_nic"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  ip_configuration { ## public dynamic ip
    name                          = "${var.proj}_pub_ip_config"
    subnet_id                     = azurerm_subnet.main_pvt_sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main_pvt_ip.id
    primary                       = true
  }
  ip_configuration { ## private static ip
    name                          = "${var.proj}_pvt_ip_config"
    subnet_id                     = azurerm_subnet.main_pvt_sn.id
    private_ip_address_allocation = "Dynamic"
  }
}

## Associate the security group to the network interface
resource "azurerm_network_interface_security_group_association" "main_sg_nic" {
  network_interface_id      = azurerm_network_interface.main_pub_nic.id
  network_security_group_id = azurerm_network_security_group.main_nsg.id
}

# data "rg_config" "main_rg_config" {
#     name      = azurerm_resource_group.main_rg.name
#     location  = azurerm_resource_group.main_rg.location
# }

## Create Windows-IIS Web Server virtual machine
# module "win" {
#   source    = "./vm"
#   proj      = var.proj
#   nic_id    = azurerm_network_interface.main_nic.id
#   rg_config = {
#     name      = azurerm_resource_group.main_rg.name
#     location  = azurerm_resource_group.main_rg.location
#   }
#   ##sg_name = module.sg.aws_security_group_name
# }

## Create Ubuntu-20.04 LTS virtual machine
module "lin" {
  source    = "./vm"
  proj      = var.proj
  pub_nic_id    = azurerm_network_interface.main_pub_nic.id
  pvt_nic_id    = azurerm_network_interface.main_pvt_nic.id
    rg_config = {
    name      = var.resource_group_name
    location  = var.resource_location
  }
  # sg_name = module.sg.aws_security_group_name
}