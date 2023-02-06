dnf update -y
firewall-cmd --permanent --zone=public --add-port=9090/tcp
dnf install perl wget curl vim nano net-tools -y
