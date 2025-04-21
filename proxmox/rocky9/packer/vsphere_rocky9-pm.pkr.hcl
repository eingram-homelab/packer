# Provisioner configuration runs after the main source builder.
local "proxmox_password" {
  expression = vault("/secret/ssh/eingram", "ssh_password")
  sensitive  = true
}

build {
  sources = ["source.proxmox-iso.rocky"]

  # Upload and execute scripts using Shell
  provisioner "shell" {
    # execute_command = "echo 'temppassword' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'" # This runs the scripts with sudo
    scripts = [
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

source "proxmox-iso" "rocky" {

  # Proxmox parameters
  insecure_skip_tls_verify = "true"
  username                 = "${var.proxmox_user}"
  password                 = "${local.proxmox_password}"
  proxmox_url              = "${var.proxmox_url}"
  node                     = var.node
  template_name            = var.proxmox_template_name

  # VM resource parameters 
  os                   = var.os
  cores                = "${var.cores}"
  cpu_type             = var.cpu_type
  memory               = "${var.memory}"
  template_description = "Packer build ${formatdate("YYYY_MM_DD", timestamp())}."

  network_adapters {
    bridge = var.bridge
    model  = "virtio"
  }

  disks {
    storage_pool      = var.storage_pool
    storage_pool_type = "zfs"
    type              = "scsi"
    format            = "raw"
    disk_size         = var.disk_size
  }

  scsi_controller = "virtio-scsi-single"
  iso_file        = var.os_iso_path
  unmount_iso     = "true"

  # Create cloud-init cdrom 
  cloud_init = "true"
  cloud_init_storage_pool = "zpool0"

  # Rocky OS parameters
  boot_wait    = "10s"
  ssh_password = "temppassword"
  ssh_username = "root"

  ssh_timeout = "10m"

  #http_ip = "${var.builder_ipv4}"
  http_directory = "scripts"
  boot_command = [
    "<up><tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
  ]
}