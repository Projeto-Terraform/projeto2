variable "location" {
  description = "Indicates the region where the VNet will be created"
  type        = string
  # Confirmar se essa será a região em que criaremos os recursos na Azure!
  default     = "Brazil South"
}

variable "allowed_ip_addresses" {
  description = "List of allowed IP addresses"
  type        = list(string)
  # Colocar nossos IPs
  default = ["177.134.254.208", "177.55.195.248", "179.175.248.2", "131.0.37.5", "170.238.131.197"]
}

variable "ARM_CLIENT_ID" {
  description = "Azure Client ID"
}

variable "ARM_CLIENT_SECRET" {
  description = "Azure Client Secret"
}

variable "ARM_SUBSCRIPTION_ID" {
  description = "Azure Subscription ID"
}

variable "ARM_TENANT_ID" {
  description = "Azure Tenant ID"
}