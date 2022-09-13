/* 
Specify any declared variables from the file of, variables.pkr.hcl, to override default values.
Example of default value of var cpu_name is 2 cores. We override that with 4 cores below.
*/

os_username = "administrator"
os_password = "temppassword"

vcenter_folder     = "Templates"
vcenter_server     = "vcsa.local.lan"
vcenter_datacenter = "HomeLab Datacenter"
vcenter_cluster    = "Intel NUC10 Cluster"
vcenter_host       = "esxinuc1.local.lan"
vcenter_datastore  = "esxinuc1:datastore1"

vm_name    = "TMP-Win2022_Packer"
vm_network = "Lab-LAN1"

vm_guest_os_type = "windows9Server64Guest" # Refer to https://code.vmware.com/apis/704/vcenter/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html for guest OS types.
vm_version       = "19"                    # Refer to https://kb.vmware.com/s/article/1003746 for specific VM versions.

os_iso_path      = "[XN_iSCSI_HDD] Repo/SERVER_EVAL_x64FRE_en-us.iso"
vmtools_iso_path = "[XN_iSCSI_HDD] Repo/windows.iso"

cpu_num   = 2
ram       = 4096
disk_size = 40960