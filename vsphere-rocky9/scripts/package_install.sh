dnf update -y
firewall-cmd --permanent --zone=public --add-port=9090/tcp
dnf install cloud-init perl wget curl vim nano net-tools -y
