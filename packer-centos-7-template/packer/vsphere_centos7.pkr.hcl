# Provisioner configuration runs after the main source builder.
local "vsphere_username" {
  expression     = vault("/secret/data/vsphere/vcsa", "vsphere_username")
  sensitive      = true
}

local "vsphere_password" {
  expression     = vault("/secret/data/vsphere/vcsa", "vsphere_password")
  sensitive      = true
}

local "ssh_username" {
  expression      = vault("/secret/data/ssh/eingram", "ssh_username")
  sensitive       = true
}

local "ssh_password" {
  expression      = vault("/secret/data/ssh/eingram", "ssh_password")
  sensitive       = true
}

build {
  sources = ["source.vsphere-iso.centos"]

  # Upload and execute scripts using Shell
  provisioner "shell" {
    execute_command = "echo '${local.ssh_password}' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'" # This runs the scripts with sudo
    scripts = [
      "scripts/yum_update.sh",
      "scripts/package_install.sh",
      "scripts/sysprep-op-bash-history.sh",
      "scripts/sysprep-op-crash-data.sh",
      "scripts/sysprep-op-dhcp-client-state.sh",
#      "scripts/sysprep-op-logfiles.sh",
      "scripts/sysprep-op-machine-id.sh",
      "scripts/sysprep-op-package-manager-cache.sh",
      "scripts/sysprep-op-rpm-db.sh",
      "scripts/sysprep-op-ssh-hostkeys.sh",
#      "scripts/sysprep-op-tmp-files.sh",
      "scripts/sysprep-op-yum-uuid.sh"
    ]
  }
}

# Builder configuration, responsible for VM provisioning.

source "vsphere-iso" "centos" {

  # vCenter parameters
  insecure_connection   = "true"
  username              = "${local.vsphere_username}"
  password              = "${local.vsphere_password}"
  vcenter_server        = "${var.vcenter_server}"
  cluster               = "${var.vcenter_cluster}"
  datacenter            = "${var.vcenter_dc_name}"
  host                  = "${var.vsphere_host}"
  datastore             = "${var.vcenter_datastore}"
  folder                = "${var.vm_folder}"
  vm_name               = "${var.vsphere_template_name}_${formatdate ("YYYY_MM", timestamp())}"
  convert_to_template   = true

  # VM resource parameters 
  guest_os_type         = "centos7_64Guest"
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
  ssh_password          = "${local.ssh_password}"
  ssh_username          = "${local.ssh_username}"

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