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

resource "aws_vpc" "virtual_private_network" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-projeto-terraform"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.virtualprivatenetwork.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet-projeto-terraform"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.virtualprivatenetwork.id

  tags = {
    Name = "gw-projeto-terraform"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.virtualprivatenetwork.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route-table-projeto-terraform"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "security_group" {
  name        = "security-group-terraform"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.virtualprivatenetwork.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}