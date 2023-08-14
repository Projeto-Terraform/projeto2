output "resource_group_id" {
  value = azurerm_resource_group.resource_group_vnet.id
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "security_group_id" {
  value = azurerm_network_security_group.nsg.id
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}