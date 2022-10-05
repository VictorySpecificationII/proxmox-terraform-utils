#!/bin/bash
# installing libguestfs-tools only required once, prior to first run
apt update -y
apt install libguestfs-tools -y

# remove existing image in case last execution did not complete successfully
rm focal-server-cloudimg-amd64.img

# uncomment based on the image you want to pull, bear in mind you will have to modify the script accordingly
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img #ubuntu 20.04
# wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img #ubuntu 22.04
# wget https://cloud.debian.org/images/cloud/OpenStack/current-10/debian-10-openstack-amd64.qcow2 #debian10


virt-customize -a focal-server-cloudimg-amd64.img --install qemu-guest-agent

# Create devops user with SSH key - somehow broken?
# virt-sysprep -a focal-server-cloudimg-amd64.img --run-command 'useradd devops' 
# virt-sysprep -a focal-server-cloudimg-amd64.img --ssh-inject devops:file:/root/.ssh/id_rsa.pub

# Unlock root account - not recommended but good for testing
# virt-customize -a focal-server-cloudimg-amd64.img --root-password password:ubuntu

qm create 9000 --name "cloudinit-ubuntu-2004" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 9000 focal-server-cloudimg-amd64.img local-lvm
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1

# Networking section
# qm set 9000 --ipconfig0 ip=10.98.1.200/8,gw=10.98.1.1
qm set 9000 --ipconfig0 ip=dhcp

# Set SSH key
qm set 9000 --sshkey ~/.ssh/id_rsa.pub

qm template 9000
rm focal-server-cloudimg-amd64.img
echo "NOTE: Next up, clone VM, then expand the disk."
echo "NOTE: You also still need to copy ssh keys to the newly cloned VM."
echo "NOTE: To login: ssh -i ~/.ssh/id_rsa ubuntu@<MACHINE_IP>"
