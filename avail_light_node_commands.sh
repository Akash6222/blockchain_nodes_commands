wget https://github.com/availproject/avail-light/releases/download/v1.8.0-rc2/avail-light-linux-amd64.tar.gz
tar -xvzf avail-light-linux-amd64.tar.gz

sudo tee /etc/systemd/system/availightd.service > /dev/null <<EOF
[Unit] 
Description=Avail Light Client
After=network.target
StartLimitIntervalSec=0

[Service] 
User=root 
ExecStart=/home/admin/avail-light-linux-amd64 --network goldberg
Restart=always 
RestartSec=120

[Install] 
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable availightd
sudo systemctl start availightd
sudo systemctl status availightd

journalctl -f -u availightd.service

