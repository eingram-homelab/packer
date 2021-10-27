# Delcared variables. 

variable "vsphere_template_name" {
  type    = string
}

variable "vm_folder" {
  type    = string
  default = "${env("vm_folder")}"
}

variable "cpu_num" {
  type    = number
}

variable "disk_size" {
  type    = number
}

variable "mem_size" {
  type    = number
}

variable "vsphere_user" {
  type    = string
  default = "${env("vsphere_user")}"
}

variable "vsphere_password" {
  type    = string
  default = "${env("VSPHERE_PASS")}"
}

variable "ssh_username" {
  type    = string
  default = "${env("ssh_username")}"
}

variable "ssh_password" {
  type    = string
  default = "${env("SSH_PASS")}"
}

variable "vcenter_server" {
  type    = string
  default = "${env("vcenter_server")}"
}

variable "vcenter_dc_name" {
  type    = string
  default = "${env("vcenter_dc_name")}"
}

variable "vcenter_cluster" {
  type    = string
  default = "${env("vcenter_cluster")}"
}

variable "vsphere_host" {
  type    = string
  default = "${env("vsphere_host")}"
}

variable "vcenter_datastore" {
  type    = string
  default = "${env("vcenter_datastore")}"
}

variable "vm_network" {
  type    = string
  default = "${env("vm_network")}"
}

variable "os_iso_path" {
  type    = string
}

#variable "ks_iso" {
#  type    = string
#}

#variable "builder_ipv4"{
#  type = string
#  description = "This variable is used to manually assign the IPv4 address to serve the HTTP directory. Use this to override Packer if it utilising the wrong interface."
#}

# Provisioner configuration runs after the main source builder.

build {
  sources = ["source.vsphere-iso.centos"]

  # Upload and execute scripts using Shell
  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'" # This runs the scripts with sudo
    scripts = [
        "scripts/cockpit.sh",
        "scripts/yum_update.sh",
        "scripts/sysprep-op-bash-history.sh",
        "scripts/sysprep-op-crash-data.sh",
        "scripts/sysprep-op-dhcp-client-state.sh",
        "scripts/sysprep-op-logfiles.sh",
        "scripts/sysprep-op-machine-id.sh",
        "scripts/sysprep-op-package-manager-cache.sh",
        "scripts/sysprep-op-rpm-db.sh",
        "scripts/sysprep-op-ssh-hostkeys.sh",
        "scripts/sysprep-op-tmp-files.sh",
        "scripts/sysprep-op-yum-uuid.sh"
    ]
  }
}

# Builder configuration, responsible for VM provisioning.

source "vsphere-iso" "centos" {

  # vCenter parameters
  insecure_connection   = "true"
  username              = "${var.vsphere_user}"
  password              = "${var.vsphere_password}"
  vcenter_server        = "${var.vcenter_server}"
  cluster               = "${var.vcenter_cluster}"
  datacenter            = "${var.vcenter_dc_name}"
  host                  = "${var.vsphere_host}"
  datastore             = "${var.vcenter_datastore}"
  folder                = "${var.vm_folder}"
  vm_name               = "${var.vsphere_template_name}_${formatdate ("YYYY_MM", timestamp())}"
  convert_to_template   = true

  # VM resource parameters 
  guest_os_type         = "centos8_64Guest"
  CPUs                  = "${var.cpu_num}"
  CPU_hot_plug          = true
  RAM                   = "${var.mem_size}"
  RAM_hot_plug          = true
  RAM_reserve_all       = false
  notes                 = "Packer built. Access Cockpit on port 9090."

  network_adapters {
      network           = "${var.vm_network}"
      network_card      = "vmxnet3"
  }

  disk_controller_type  = ["pvscsi"]
  storage {
      disk_thin_provisioned = "true"
      disk_size             = var.disk_size
  }

  iso_paths = [
    "${var.os_iso_path}"
    # "${var.ks_iso}" 
  ]

  # CentOS OS parameters
  boot_order            = "disk,cdrom,floppy"
  boot_wait             = "10s"
  ssh_password          = "${var.ssh_password}"
  ssh_username          = "${var.ssh_username}"

  #http_ip = "${var.builder_ipv4}"
  http_directory    = "scripts"
  boot_command      = [
    "<up><wait><tab><wait> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
  ]

  # Uncomment the below to kickstar via an ISO (the ISO you will need to make manually by simply saving the ks.cfg file into an iso file). 
  # I used this in the interim as the box I was running from had issues as Packer kept using a private non-routed network.
  # boot_command = [ 
  #   "<wait15>",
  #   "<tab>",
  #   "linux inst.ks=hd:/dev/sr1:ks.cfg", # Run kickstart off optical drive 2
  #   "<enter>"
  # ]

}