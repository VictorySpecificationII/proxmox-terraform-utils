# proxmox-terraform-utils
Script utilities to help with setting up Terraform on Proxmox and creating templates.

# Usage

## Setting up PVE Terraform account

If you have nodes in a cluster, run the pve script once and it will apply the key to the cluster.
For every standalone node you have, you need to run the script individually.

## Creating templates for Terraform Infra

Modify the create-template.sh file accordingly and run it.

## For PVE-Exporter:

0. Run installation script

./install-pve-exporter.sh

1. Modify your Prometheus file based on the file in this repository.
 
2. Restart Prometheus Metrics Server

systemctl restart prometheus

3. If needed, uninstall by running

./remove-pve-exporter.sh



## Prometheus Configuration

Rudimentary prometheus.yml that includes a job to scrape metrics from the PVE exporters.


## Custom Cloud-Init

Assuming you have used a cloud-init image to create your VM with:

 - Save the file at /var/lib/vz/snippets/<NUMERICAL_ID_OF_YOUR_VM_ID>.yaml then attach it like qm set NUMERICAL_ID_OF_YOUR_VM_ID --cicustom "user=local:snippets/NUMERICAL_ID_OF_YOUR_VM_ID.yaml"

 - Reboot that VM
