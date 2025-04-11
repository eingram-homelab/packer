# Update this line to trigger build

local "vsphere_username" {
  expression = vault("/secret/vsphere/vcsa", "vsphere_username")
  sensitive  = true
}

local "vsphere_password" {
  expression = vault("/secret/vsphere/vcsa", "vsphere_password")
  sensitive  = true
}

local "ssh_password" {
  expression = vault("/secret/ssh/eingram", "ssh_password")
  sensitive  = true
}

packer {
  required_version = ">= 1.7.4"

  required_plugins {
    windows-update = {
      version = "0.15.0"
      source  = "github.com/rgl/windows-update"
      # Github Plugin Repo https://github.com/rgl/packer-plugin-windows-update
    }
    vsphere = {
      source  = "github.com/hashicorp/vsphere"
      version = "~> 1"
    }
  }
}

source "vsphere-iso" "win2022" {
  insecure_connection = true

  vcenter_server = var.vcenter_server
  username       = local.vsphere_username
  password       = local.vsphere_password

  cluster    = var.vcenter_cluster
  datacenter = var.vcenter_datacenter
  host       = var.vcenter_host
  datastore  = var.vcenter_datastore
  folder     = var.vcenter_folder

  convert_to_template = true
  notes               = "Windows Server 2022 Datacenter x64 VM template built using Packer."

  ip_wait_timeout         = "60m"
  ip_settle_timeout       = "1m"
  communicator            = "winrm"
  winrm_port              = "5985"
  winrm_timeout           = "10m"
  pause_before_connecting = "2m"
  winrm_username          = var.os_username
  winrm_password          = local.ssh_password
  vm_name                 = "${var.vm_name}__${formatdate("YYYYMMDDHHmmss", timestamp())}"
  vm_version              = var.vm_version
  firmware                = var.vm_firmware
  guest_os_type           = var.vm_guest_os_type
  CPUs                    = var.cpu_num
  CPU_hot_plug            = true
  RAM                     = var.ram
  RAM_reserve_all         = false
  RAM_hot_plug            = true
  video_ram               = "8192"
  cdrom_type              = "sata"

  disk_controller_type = ["pvscsi"]
  remove_cdrom         = true

  network_adapters {
    network      = var.vm_network
    network_card = var.network_card
  }

  storage {
    disk_thin_provisioned = true
    disk_size             = var.disk_size
  }

  iso_paths = [
    var.os_iso_path,
    var.vmtools_iso_path
  ]
  cd_content = {
    "autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
      password = local.ssh_password
    })
  }

  floppy_dirs = ["${abspath(path.root)}/scripts", ]
  # floppy_files = ["unattended/autounattend.xml"]
  # floppy_files = ["unattended/autounattend.xml", "drivers/PVSCSI.CAT", "drivers/PVSCSI.INF", "drivers/PVSCSI.SYS", "drivers/TXTSETUP.OEM"]
  floppy_img_path = var.floppy_img_path

  boot_wait = "3s"
  boot_command = [
    "<spacebar><spacebar>"
  ]
}

build {
  /* 
  Note that provisioner "Windows-Update" performs Windows updates and reboots where necessary.
  Run the update provisioner as many times as you need. I found that 3-to-4 runs tended,
  to be enough to install all available Windows updates. Do check yourself though!
  */

  sources = ["source.vsphere-iso.win2022"]

  provisioner "windows-restart" { # A restart to settle Windows prior to updates
    pause_before    = "1m"
    restart_timeout = "15m"
  }

  provisioner "windows-update" {
    pause_before    = "2m"
    timeout         = "1h"
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*VMware*'", # Can break winRM connectivity to Packer since driver installs interrupt network connectivity
      #"exclude:$_.Title -like '*Preview*'",
      "include:$true"
    ]
  }

  provisioner "windows-update" {
    pause_before    = "1m"
    timeout         = "1h"
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*VMware*'", # Can break winRM connectivity to Packer since driver installs interrupt network connectivity
      #"exclude:$_.Title -like '*Preview*'",
      "include:$true"
    ]
  }

  provisioner "windows-update" {
    pause_before    = "1m"
    timeout         = "1h"
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*VMware*'", # Can break winRM connectivity to Packer since driver installs interrupt network connectivity
      # "exclude:$_.Title -like '*Preview*'",
      # "exclude:$_.Title -like '*Feature*'",
      "include:$true"
    ]
  }

  provisioner "powershell" {
    pause_before      = "1m"
    elevated_user     = var.os_username
    elevated_password = local.ssh_password
    script            = "${abspath(path.root)}/scripts/customize_win.ps1"
    timeout           = "15m"
  }

  provisioner "windows-restart" { # A restart before sysprep to settle the VM once more.
    pause_before    = "1m"
    restart_timeout = "1h"
  }

  # Output build details including artifact ID
  post-processor "manifest" {
    output     = "${abspath(path.root)}/build-manifest.json"
    strip_path = true
    custom_data = {
      build_timestamp = "${formatdate("YYYY-MM-DD hh:mm:ss", timestamp())}"
      vm_name         = "${var.vm_name}__${formatdate("YYYYMMDDHHmmss", timestamp())}"
      os_version      = "Windows 2022 Datacenter"
    }
  }
}