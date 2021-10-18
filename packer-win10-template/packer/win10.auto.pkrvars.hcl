/* 
Specify any declared variables from the file of, variables.pkr.hcl, to override default values.
Example of default value of var cpu_name is 2 cores. We override that with 4 cores below.
*/

vcenter_username        = "packer@local"
vcenter_password        = "Is_This_My_Password?"

os_username             = "Packer"
os_password_workstation = "Is_This_My_Password?"

vcenter_server          = "vcenter.local"
vcenter_cluster         = "cluster-lab"
vcenter_datacenter      = "dc-lab01"
vcenter_host            = "esxilab01.local"
vcenter_datastore       = "templates"
vcenter_folder          = "templates"

vm_name                 = "win10_pro_x64_packer_template"
vm_network              = "lab"
vm_guest_os_type        = "windows9_64Guest" # Refer to https://code.vmware.com/apis/704/vsphere/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html for guest OS types.
vm_version              = "13" # Refer to https://kb.vmware.com/s/article/1003746 for specific VM versions.

os_iso_path             = "[iso_datastore] iso/windows_10_x64_21H1.iso"
vmtools_iso_path        = "[iso_datastore] iso/windows_vmware_tools_v10.3.10-12406962.iso"

cpu_num                 = 4
ram                     = 8192
disk_size               = 81920