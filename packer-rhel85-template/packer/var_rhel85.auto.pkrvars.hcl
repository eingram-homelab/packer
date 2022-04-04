# Assign values to override their default values (default values are found in the vsphere_centos8.pkr.hcl file).
# All values are automatically used and persist through the entire Packer process.

vsphere_template_name = "TMP-RHEL85_Packer"
vm_folder        = "Templates"

cpu_num     = 2
mem_size    = 2048
disk_size   = 61450

vcenter_server          = "vcsa.local.lan"
vcenter_dc_name         = "HomeLab Datacenter"
vcenter_cluster         = "Intel NUC10 Cluster"
vsphere_host           = "esxinuc1.local.lan"
vcenter_datastore       = "esxinuc1:datastore1"
vm_network  = "Lab-LAN1"

os_iso_path = "[XN_iSCSI_HDD] Repo/rhel-8.5-x86_64-dvd.iso"

