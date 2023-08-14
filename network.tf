resource "azurerm_resource_group" "resource_group_vnet" {
  name     = "vnet"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_vnet.name
  address_space       = ["10.0.0.0/16"]

  tags = local.common_tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-terraform"
  resource_group_name  = azurerm_resource_group.resource_group_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-terraform"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_vnet.name

  dynamic "security_rule" {
    for_each = var.allowed_ip_addresses

    content {
      name                       = "SSH_${security_rule.key}"
      priority                   = 100 + security_rule.key
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "22"
      destination_port_range     = "22"
      source_address_prefix      = cidrsubnet(security_rule.value)  # Converter IP para formato CIDR
      destination_address_prefix = "*"
    }
  }

  tags = local.common_tags
}


resource "azurerm_subnet_network_security_group_association" "snsga" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}