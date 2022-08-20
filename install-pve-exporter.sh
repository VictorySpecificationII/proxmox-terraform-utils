#!/bin/bash

#Source: https://community.hetzner.com/tutorials/proxmox-prometheus-metrics

echo "Creating users for exporter..."
pveum user add pve-exporter@pve -comment "PVE-Exporter" -password sz7T9hxT4RYyXc
pveum aclmod / -user pve-exporter@pve -role PVEAuditor
useradd -c "pve exporter" -m -s /bin/false pve-exporter

echo "Installing dependencies..."
# apt-get update --allow-unauthenticated
apt-get install python3-venv python3-setuptools python3-dev python3-pip libffi-dev libssl-dev build-essential -y

echo "Creating Python virtual environment..."
python3 -m venv /opt/prometheus-pve-exporter
source /opt/prometheus-pve-exporter/bin/activate
pip install prometheus-pve-exporter
deactivate

echo "Creating exporter configuration file..."

mkdir -p /etc/prometheus

cat <<EOF > /etc/prometheus/pve.yml
default:
    user: pve-exporter@pve
    password: sz7T9hxT4RYyXc
    # only needed when you not configured Lets Encrypt
    verify_ssl: false
EOF

echo "Fumbling with permissions..."

chown root.pve-exporter /etc/prometheus/pve.yml
chmod 640 /etc/prometheus/pve.yml

echo "Creating exporter service launch file..."

cat <<EOF> /etc/systemd/system/prometheus-pve-exporter.service
[Unit]
Description=Prometheus exporter for Proxmox VE
Documentation=https://github.com/znerol/prometheus-pve-exporter

[Service]
Restart=always
User=pve-exporter
ExecStart=/opt/prometheus-pve-exporter/bin/pve_exporter /etc/prometheus/pve.yml

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading and enabling exporter service..."

systemctl daemon-reload
systemctl start prometheus-pve-exporter.service
systemctl enable prometheus-pve-exporter.service

echo "Verifying port 9221 is open"

ss -lntp | grep 9221

echo "Test functionality using cURL..."

curl -s localhost:9221/pve
