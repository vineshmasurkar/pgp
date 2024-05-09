#!/bin/bash
sudo apt update
sudo apt install -y nginx

cat << EOF >> /etc/systemd/system/tio.service
[Unit]
Description=Apache server deployment
After=network.target

[Service]
ExecStart=/etc/systemd/system/tio.sh
Restart=always
User=root
Group=root
Type=simple

[Install]
WantedBy=multi-user.target
EOF

cat << EOF >> /etc/systemd/system/tio.sh
service httpd start
instance_num=$(expr 1000 + $RANDOM % 35000)
echo "Manual instance numbered RANDOM_NUM" > /var/www/html/index.html
#Directly using $RANDOM seems to embed a reference to the function in the index.html
#As a result the random number was changing on each refresh in the browser
#This reference was broken by using sed and using the instance_num as a literal
sed -i "s=RANDOM_NUM=$instance_num=g" /var/www/html/index.html
echo "ok" > /var/www/html/health.html
EOF

sudo chmod +x /etc/systemd/system/tio.sh

sudo systemctl daemon-reload
sudo systemctl enable tio.service
sudo systemctl start tio.service