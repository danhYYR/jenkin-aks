# Resoure group
variable "rg_name" {
  description = "The name of the Resource Group"
  type        = string
}
variable "rg_location" {
  description = "The Resource Group location"
  type        = string
}
variable "sh_rg" {
  description = "The resource group of self host VM"
  type = string
}
variable "sh_location" {
  description = "The self host VM's location"
  type = string
}
# Private Endpoint
## DNS zone
# variable "dns_aml_id" {
#   description = "The ID DNS private zone of the Azure Machine learning"
#   type        = string
# }
# variable "dns_notbook_id" {
#   description = "The ID DNS private zone of the Azure Machine learning Notebook"
#   type        = string
# }
# variable "mlw_id" {
#   description = "The Machine Learning workspace resource ID"
#   type        = string
# }
## Self host subnet
variable "subnet_sh" {
  description = "The subnet ID of self host agent"
  type        = string
}
# Control VM Data
## Jumphost VM
variable "jumphost_data" {
  description = "The output of jumphost VM"
  type = object({
    vmname   = string
    hostname = string
    username = string
    ssh_key  = string
  })
}
# Data Science VM
variable "dsvm_data" {
  description = "The output of jumphost VM"
  type = object({
    vmname   = string
    hostname = string
    username = string
    ssh_key  = string
  })
}
# AKS 
variable "aks_name" {
  description = "The name of AKS"
  type        = string
}
# Ansible
variable "inventory_path" {
  description = "The path of iventory for Ansible"
  type        = string
}
