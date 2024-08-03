## Create resource group
resource "azurerm_resource_group" "main_rg" {
  # name     = "${random_id.prefix.id}-rg"
  name     = "${var.proj}_rg"
  location = var.resource_location
}

## Create virtual network
resource "azurerm_virtual_network" "main_vnet" {
  name                = "${var.proj}_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
}

## Create subnets
resource "azurerm_subnet" "main_sn1" {
  name                 = "${var.proj}_sn1"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.0.0/28"]
}

resource "azurerm_subnet" "main_sn2" {
  name                 = "${var.proj}_sn2"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.0.64/28"]
}

## Create public IPs
resource "azurerm_public_ip" "main_pub_ip" {
  name                = "${var.proj}_pub_ip"
  ip_version          = "IPv4"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  allocation_method   = "Dynamic"
}

## Create Network Security Group and rules
resource "azurerm_network_security_group" "main_nsg" {
  name                = "${var.proj}_nsg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  security_rule { ## assign security Rule: Method 1
    name                       = "RDP" ## Remote Desktop Protocol
    priority                   = 100
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
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.main_nsg.name
}

## Associate the network sequrity group to subnets
resource "azurerm_subnet_network_security_group_association" "main_nsg_sn1" {
  subnet_id                 = azurerm_subnet.main_sn1.id
  network_security_group_id = azurerm_network_security_group.main_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "main_nsg_sn2" {
  subnet_id                 = azurerm_subnet.main_sn2.id
  network_security_group_id = azurerm_network_security_group.main_nsg.id
}

## Create network interface
resource "azurerm_network_interface" "main_nic" {
  name                = "${var.proj}_nic"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  ip_configuration { ## public dynamic ip
    name                          = "${var.proj}_pub_ip_config"
    subnet_id                     = azurerm_subnet.main_sn1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main_pub_ip.id
    primary                       = true
  }
  ip_configuration { ## private static ip
    name                          = "${var.proj}_pvt_ip_config"
    subnet_id                     = azurerm_subnet.main_sn1.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.10.0.56/27"
    #public_ip_address_id          = azurerm_public_ip.main_pub_ip.id
  }
}

## Associate the security group to the network interface
resource "azurerm_network_interface_security_group_association" "main_sg_nic" {
  network_interface_id      = azurerm_network_interface.main_nic.id
  network_security_group_id = azurerm_network_security_group.main_nsg.id
}

# data "rg_config" "main_rg_config" {
#     name      = azurerm_resource_group.main_rg.name
#     location  = azurerm_resource_group.main_rg.location
# }

## Create Windows-IIS Web Server virtual machine
module "win" {
  source    = "./vm"
  proj      = var.proj
  nic_id    = azurerm_network_interface.main_nic.id
  rg_config = {
    name      = azurerm_resource_group.main_rg.name
    location  = azurerm_resource_group.main_rg.location
  }
  ##sg_name = module.sg.aws_security_group_name
}

## ## Create Ubuntu-Apache Web Server virtual machine
# module "ec2" {
#   source = "./vm"
#   vpc_id = data.aws_vpc.default.id
#   sg_name = module.sg.aws_security_group_name
# }
