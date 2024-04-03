#! /bin/bash

#root user only

sudo apt update && sudo apt upgrade -y

wget https://github.com/availproject/avail-light/releases/download/v1.7.10/avail-light-linux-amd64.tar.gz
tar -xvzf avail-light-linux-amd64.tar.gz

sudo tee /etc/systemd/system/availightd.service > /dev/null <<EOF
[Unit] 
Description=Avail Light Client
After=network.target
StartLimitIntervalSec=0

[Service] 
User=root 
ExecStart=/root/avail-light-linux-amd64 --network goldberg
Restart=always 
RestartSec=120

[Install] 
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable availightd
sudo systemctl start availightd
# sudo systemctl status availightd

timeout 5s  journalctl -f -u availightd.service --no-hostname -o cat | sed 's/\x1b\[[0-9;]*m//g' > avail_light.log
grep "Avail ss58 address" avail_light.log | grep -oP '(?<=address: )[^,]+' > avail_addr.txt
grep "Avail ss58 address" avail_light.log | grep -oP '(?<=public key: ).*' > public_key.txt
grep "avail_secret_seed_phrase" /identity.toml | awk -F "'" '{print $2}' > seed.txt

cat avail_addr.txt
cat public_key.txt
cat seed.txt
#curl -sL1 http://avail.sh | bash




