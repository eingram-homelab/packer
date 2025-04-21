# Assign values to override their default values (default values are found in the vsphere_centos8.pkr.hcl file).
# All values are automatically used and persist through the entire Packer process.

proxmox_template_name = "Rocky9-TMP"
os                    = "l26" # Linux 2.6+
cores                 = 4
memory                = 4096
disk_size             = 60
node                  = "pve1"

os_iso_path = "local:iso/Rocky-9.1-x86_64-dvd.iso"

# Network
bridge = "vmbr0"
