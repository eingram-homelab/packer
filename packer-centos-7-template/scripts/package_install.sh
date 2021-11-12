yum install cockpit -y
systemctl enable --now cockpit.socket
systemctl start cockpit
yum install wget curl vim nano net-tools -y