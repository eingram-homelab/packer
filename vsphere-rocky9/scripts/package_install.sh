dnf update -y
firewall-cmd --permanent --zone=public --add-port=9090/tcp
dnf install perl wget curl vim nc net-tools -y
vmware-toolbox-cmd config set deployPkg enable-customization true
vmware-toolbox-cmd config set deployPkg enable-custom-scripts true
