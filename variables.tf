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
  default = ["1.2.3.4", "5.6.7.8"]
}
