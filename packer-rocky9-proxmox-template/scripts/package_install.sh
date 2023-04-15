dnf update -y
dnf install cloud-init qemu-guest-agent perl wget curl vim nano net-tools -y
systemctl enable qemu-guest-agent
