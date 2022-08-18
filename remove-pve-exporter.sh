#!/bin/bash

echo "Deleting Python Virtual Environment..."
rm -rf /opt/prometheus-pve-exporter

echo "Deleting PVE-exporter configuration file..."
rm -rf /etc/prometheus/pve.yml 

echo "Deleting PVE-exporter service file..."
rm -rf /etc/systemd/system/prometheus-pve-exporter.service

echo "Checking service status - should show Not Found"
systemctl disable prometheus-pve-exporter
systemctl stop prometheus-pve-exporter
systemctl status prometheus-pve-exporter -l
