## Resource Group Config - Object
variable "rg_config" {
  type = object({
    name      = string
    location  = string
  })
}

variable "pub_ip" {
  type    = string
  default = "<pub_ip>"
}

variable "sb_id" {
  type    = string
  default = "<sb_id>"
}

resource "azurerm_lb" "vmss_lb" {
  name                = "${var.proj}_lb"
  location              = var.rg_config.location
  resource_group_name   = var.rg_config.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = var.pub_ip
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  name            = "BackEndAddressPool"
  loadbalancer_id = azurerm_lb.vmss_lb.id
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  name                           = "${var.proj}_ssh"
  resource_group_name            = var.rg_config.name
  loadbalancer_id                = azurerm_lb.vmss_lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "vmss_lb_probe" {
  name            = "${var.proj}_http-probe"
  loadbalancer_id = azurerm_lb.vmss_lb.id
  protocol        = "Http"
  request_path    = "/health"
  port            = 8080
}

## Create virtual machine scale-set
resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "${var.proj}-1"
  location              = var.rg_config.location
  resource_group_name   = var.rg_config.name
  zones                 = [1, 2, 3]

  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

#   rolling_upgrade_policy {
#     max_batch_instance_percent              = 20
#     max_unhealthy_instance_percent          = 20
#     max_unhealthy_upgraded_instance_percent = 5
#     pause_time_between_batches              = "PT0S"
#   }

  # required when using rolling upgrade policy
  health_probe_id = azurerm_lb_probe.vmss_lb_probe.id

  sku {
    name     = "Standard_F2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "testvmss"
    admin_username       = "myadmin"
  }

  os_profile_windows_config {
    provision_vm_agent = true
    # disable_password_authentication = true

    # ssh_keys {
    #   path     = "/home/myadmin/.ssh/authorized_keys"
    #   key_data = file("~/.ssh/demo_key.pub")
    # }
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary                                = true
      subnet_id                              = var.sb_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }
}