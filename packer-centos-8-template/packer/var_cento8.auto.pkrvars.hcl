# Assign values to override their default values (default values are found in the vsphere_centos8.pkr.hcl file).
# All values are automatically used and persist through the entire Packer process.

vsphere_user     = "administrator@vsphere.local"
#vsphere_password = ""

ssh_username = "eingram"
#ssh_password = ""

vsphere_template_name = "TMP-Centos8_Packer"
vsphere_folder        = "Templates"

cpu_num     = 2
mem_size    = 4096
disk_size   = 61450

vsphere_server          = "vcsa.local.lan"
vsphere_dc_name         = "HomeLab Datacenter"
vsphere_compute_cluster = "Intel NUC10 Cluster"
vsphere_host            = "esxinuc1.local.lan"
vsphere_datastore       = "XN_iSCSI_SSD"
vsphere_portgroup_name  = "Lab-LAN1"

os_iso_path = "[XN_iSCSI_HDD] Repo/CentOS-Stream-8-x86_64-latest-dvd1.iso"
#ks_iso      = "[lab_datastore] iso/centos_ks.iso"

#builder_ipv4 = "10.20.30.40"
