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

## Create Ubuntu-20.04 LTS virtual machine
resource "azurerm_linux_virtual_machine" "app_server_vm" {
  name                  = "${var.proj}-app-server-vm"
  computer_name         = "${var.proj}"
  admin_username        = "azureuser"
#   admin_password        = "CorePassword123"
  admin_ssh_key {
    username            = "azureuser"
    public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDecfi7H0x3UOMCMo1RR3n7Bk6MCYS/EMbb80nquf4xGFmXSSDqfo0KUA2s1Ip1ScTYFFitxM/U7J9JFCYkatQuzNT2F4f1gvBRlew1fBoA/isg7KcQW5CNP2l1oCWrWbD37TU+7SvsphfS4wWVPALJ8Xe6RxnyWMwB0SUO8Vbq4ZcJ4EJLad2ffRTqELWxm44Vo30juJZ5bUpfcrf6Jl9NAeDuGvgawtnTxOT2Kpxvcm+DZ/itzzhRqq1Z9zaJvsH0ZzhG/WpT7T1tqd3yzZqUzNQ2e73Z6goKy2HhuHNaXryjcW1CmuLUu8gYFRTTCjqsAup0WDqcg6Z8VPPCN6TeondXR/QgHs5jP7KWjqtjaF184NqoCCAROS8THFLJZi/xNEqVpzZJDGgkAsfIuez37uDFWGruigScKKx8adJRV+gx/n/+3m7xlURPuAGDEvbtM4TlV0Q20HBE1J5TbMhy4dqXIv/LY4X/1sH8TUfSAQ21jRc9Yo41OzNhDbIlNfE= generated-by-azure"
  }
#   admin_ssh_key {
#     username            = var.username
#     public_key          = azapi_resource_action.ssh_public_key_gen.output.publicKey
#   }

  location              = var.rg_config.location
  resource_group_name   = var.rg_config.name
  network_interface_ids = [var.nic_id]
  size                  = "Standard_B1s" ## 1 vcpu, 1 GiB memory
  ## The free account includes access to three types of VMs for free
  ##  — the B1S, B2pts v2 (ARM-based), and B2ats v2 (AMD-based) 
  ##  burstable VMs that are usable for up to 750 hours per month.

  # custom_data           = file("custom-data.ps1") ## TO BE TESTED
  os_disk {
    name                 = "${var.proj}_app_server_os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-focal"
    sku       = "minimal-20_04-lts-gen2"
    version   = "20.04.202004230"
  }
#   {
#     "architecture": "x64",
#     "offer": "0001-com-ubuntu-minimal-focal",
#     "publisher": "Canonical",
#     "sku": "minimal-20_04-lts-gen2",
#     "urn": "Canonical:0001-com-ubuntu-minimal-focal:minimal-20_04-lts-gen2:20.04.202004230",
#     "version": "20.04.202004230"
#   }


  # boot_diagnostics {
  #   storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  # }
}

## Attach azure-manged data disk to virtual machine
resource "azurerm_managed_disk" "app_server_data_disk" {
  name                  = "${var.proj}_app_server_data_disk"
  location              = var.rg_config.location
  resource_group_name   = var.rg_config.name
  storage_account_type  = "Standard_LRS"
  create_option         = "Empty"
  disk_size_gb          = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "app_server_data_disk_attach" {
  managed_disk_id    = azurerm_managed_disk.app_server_data_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.app_server_vm.id
  lun                ="10"
  caching            = "ReadWrite"
}

# variable "pgp_ami" {
#   type = string
#   default = "ami-06d5e0de6baf595ca"
# }

# variable "pgp_instance_type" {
#   type = string
#   default = "t2.micro"
# }

# variable "instance_set" {
#   type = set(string)
#   #default = ["httpserver1", "httpserver2"]
#   default = ["lin-server"]
# }

# variable "vpc_id" {
#   type = string
#   default = "<vpc_id>"
# }

# variable "sg_name" {
#   type = string
#   default = "<sg_name>"
# }

# # VM instances
# resource "aws_instance" "vms" {
#   for_each = var.instance_set
#     ami = var.pgp_ami
#     instance_type     = var.pgp_instance_type
#     user_data         = file("server-script.sh")
#     security_groups = [var.sg_name]
#     tags = {
#       Name = each.value
#     }
# }

# output "vm_instances" {
#   value = aws_instance.vms
# }
