#!/bin/bash
# installing libguestfs-tools only required once, prior to first run
apt update -y
apt install libguestfs-tools -y

# remove existing image in case last execution did not complete successfully
rm jammy-server-cloudimg-amd64.img 

# uncomment based on the image you want to pull, bear in mind you will have to modify the script accordingly
# wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img #ubuntu 20.04
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img #ubuntu 22.04
# wget https://cloud.debian.org/images/cloud/OpenStack/current-10/debian-10-openstack-amd64.qcow2 #debian10


virt-customize -a jammy-server-cloudimg-amd64.img  --install qemu-guest-agent
#virt-customize -a jammy-server-cloudimg-amd64.img  --ssh-inject root:file:/root/.ssh/id_rsa.pub
#virt-customize -a jammy-server-cloudimg-amd64.img  --run-command 'sed -i "/#PasswordAuthentication yes/s/^# //g" /etc/ssh/sshd_config'
#virt-customize -a jammy-server-cloudimg-amd64.img  --run-command 'sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config'

# Create devops user with SSH key - somehow broken?
# virt-sysprep -a focal-server-cloudimg-amd64.img --run-command 'useradd devops' 
# virt-customize -a jammy-server-cloudimg-amd64.img --firstboot-command 'useradd -m -p "" devops ; chage -d 0 devops' #uncomment and comment below line to enforce new password 
#virt-customize -a jammy-server-cloudimg-amd64.img --run-command 'useradd -m -p "" devops'

# Unlock root account - not recommended but good for testing
virt-customize -a jammy-server-cloudimg-amd64.img --root-password password:ubuntu

qm create 1000 --name "cloudinit-ubuntu-2204" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 1000 jammy-server-cloudimg-amd64.img  local-lvm
qm set 1000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-1000-disk-0
qm set 1000 --boot c --bootdisk scsi0
qm set 1000 --ide2 local-lvm:cloudinit
qm set 1000 --serial0 socket --vga serial0
qm set 1000 --agent enabled=1
qm resize 1000 scsi0 +14G 

#get custom cloud-init file
#wget https://raw.githubusercontent.com/VictorySpecificationII/proxmox-terraform-utils/main/cloudinit-custom.yaml


#mv cloudinit-custom.yaml 1000.yaml

#Move cloudinit custom file to VM dir
#mv 1000.yaml /var/lib/vz/snippets/1000.yaml

#Attach custom cloudinit file to VM
#qm set 1000 --cicustom "user=local:snippets/1000.yaml"


# Networking section
# qm set 1000 --ipconfig0 ip=10.98.1.200/8,gw=10.98.1.1
qm set 1000 --ipconfig0 ip=dhcp

# Set SSH key
#qm set 1000 --sshkey ~/.ssh/id_rsa.pub

qm template 1000
rm jammy-server-cloudimg-amd64.img 
echo "NOTE: Next up, clone VM, then expand the disk."
echo "NOTE: You also still need to copy ssh keys to the newly cloned VM."
echo "NOTE: To login: ssh devops@<MACHINE_IP>"
