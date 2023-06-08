# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "RG" {
  name     = "new-rg-roee"
  location = "West Europe"
  tags = {
    Terraform = "True"
    env       = "Dev"
  }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "new-Vnet-roee"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  address_space       = ["100.0.0.0/16"]
  tags = {
    Terraform = "True"
    env       = "Dev"
  }
}


resource "azurerm_subnet" "subnet" {
  name                 = "azure-tf-subnet"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["100.0.1.0/24"]
  #  tags = {
  #    Terraform = "True"
  #    env       = "Dev"
  #  }
}


resource "azurerm_network_security_group" "sc-group" {
  name                = "tf-sc-group"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  tags = {
    Terraform = "True"
    env       = "Dev"
  }
}
resource "azurerm_network_security_rule" "nsr-tf" {
  name                        = "dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "87.71.197.26" #enter your ip public
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG.name
  network_security_group_name = azurerm_network_security_group.sc-group.name
}


resource "azurerm_subnet_network_security_group_association" "sga" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.sc-group.id
}


resource "azurerm_public_ip" "tf-ip" {
  name                = "ip-01"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  allocation_method   = "Dynamic"

  tags = {
    env       = "Dev"
    Terraform = "True"
  }
}


resource "azurerm_network_interface" "nic" {
  name                = "tf-nic"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tf-ip.id
  }


  tags = {
    env       = "Dev"
    Terraform = "True"
  }
}

resource "azurerm_linux_virtual_machine" "tf-vm" {
  name                  = "linuxvm-01"
  resource_group_name   = azurerm_resource_group.RG.name
  location              = azurerm_resource_group.RG.location
  size                  = "Standard_B1s"
  admin_username        = "roee"
  network_interface_ids = [azurerm_network_interface.nic.id]


  custom_data = filebase64("customdata.tpl")

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-script.tpl", {
      hostname     = self.public_ip_address,
      user         = "roee",
      identityfile = "~/.ssh/id_rsa"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
}


  admin_ssh_key {
    username   = "roee"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Query data azurerm_resource_group

data "azurerm_resource_group" "RG" {
  name = "new-rg-roee"
}


# Retrieves attributes from the azurerm_resource_group data source and stores them in a local variable named rg.info.
# It then defines an output variable named resource_group_data, which contains a map of all the attributes and their corresponding values. 
# This allows you to easily retrieve the complete set of attributes from the azurerm_resource_group data source when running terraform apply

locals {
  rg_info = {
    id       = data.azurerm_resource_group.RG.id
    name     = data.azurerm_resource_group.RG.name
    location = data.azurerm_resource_group.RG.location
    tags     = data.azurerm_resource_group.RG.tags
    # Add more attributes as needed
  }
}

output "resource_group_data" {
  value = {
    for key, value in local.rg_info :
    key => value
  }
}


data "azurerm_virtual_machine" "vm" {
  name                = "linuxvm-01"
  resource_group_name = "new-rg-roee"
}

locals {
  vm_info = {
    id                   = data.azurerm_virtual_machine.vm.id
    identity             = data.azurerm_virtual_machine.vm.identity
    private_ip_address   = data.azurerm_virtual_machine.vm.private_ip_address
    private_ip_addresses = data.azurerm_virtual_machine.vm.private_ip_addresses
    public_ip_address    = data.azurerm_virtual_machine.vm.public_ip_address
    public_ip_addresses  = data.azurerm_virtual_machine.vm.public_ip_addresses
    #power_state         = data.azurerm_virtual_machine.vm.power_state #Error: Unsupported attribute
  }
}

output "virtual_machine_data" {
  value = {
    for key, value in local.vm_info :
    key => value
  }
}