# proxmox-terraform-utils
Script utilities to help with setting up Terraform on Proxmox and creating templates.

# Usage

## Setting up PVE Terraform account

If you have nodes in a cluster, run the pve script once and it will apply the key to the cluster.
For every standalone node you have, you need to run the script individually.

## Creating templates for Terraform Infra

Modify the file accordingly and run it.


## To:do

Copy .tf files from experiment to repository.


## For PVE-Exporter:

0. Run installation script

./install-pve-exporter.sh

1. Append the following to your prometheus.yml file

  - job_name: 'pve-exporter'
    static_configs:
      - targets:
        - localhost:9221 #IP of PVE server
    metrics_path: /pve
    params:
      module: [default]

2. Restart Prometheus Metrics Server

systemctl restart prometheus

3. If needed, uninstall by running

./remove-pve-exporter.sh
