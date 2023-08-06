#!/bin/bash

wget https://github.com/MatchbookLab/local-persist/releases/download/v1.3.0/local-persist-linux-amd64

echo "Rename local-persist-linux-amd64 to docker-volume-local-persist..."
mv local-persist-linux-amd64 docker-volume-local-persist

cp docker-volume-local-persist /usr/bin
chmod +x /usr/bin/docker-volume-local-persist

echo "Create docker-volume-local-persist.service file..."
tee -a docker-volume-local-persist.service << EOF
[Unit]
Description=docker-volume-local-persist
Before=docker.service
Wants=docker.service

[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/docker-volume-local-persist

[Install]
WantedBy=multi-user.target
EOF

echo "Move .service file to /etc/systemd/system/"
mv docker-volume-local-persist.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable docker-volume-local-persist
systemctl start docker-volume-local-persist
systemctl status docker-volume-local-persist
