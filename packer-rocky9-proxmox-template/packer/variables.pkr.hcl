# Declared variables. 
variable "proxmox_user" {
  type    = string
  default = "root@pam"
}

variable "proxmox_template_name" {
  type = string
}

variable "os" {
  type = string
}

variable "cores" {
  type = number
}

variable "cpu_type" {
  type    = string
  default = "host"
}

variable "disk_size" {
  type = number
}

variable "memory" {
  type = number
}

variable "node" {
  type = string
}

variable "proxmox_url" {
  type    = string
  default = "https://pve1.local.lan:8006/api2/json"
}

variable "storage_pool" {
  type    = string
  default = "zpool0"
}

variable "bridge" {
  type = string
}

variable "os_iso_path" {
  type = string
}
