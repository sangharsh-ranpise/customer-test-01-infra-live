# main.tf
variable "my_number" {
  type = number
}

output "my_number" {
  value = var.my_number
}
