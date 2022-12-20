#!/bin/bash
#Source: https://cloudalbania.com/posts/2022-01-homelab-with-proxmox-and-terraform/
#Source: https://austinsnerdythings.com/2021/09/01/how-to-deploy-vms-in-proxmox-with-terraform/

#ONLY RUN when all nodes are in a cluster

pveum role add TerraformProv -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit"
pveum user add terraform-prov@pve --password 3dMLf5CgFfcDod
pveum aclmod / -user terraform-prov@pve -role TerraformProv
pveum user token add terraform-prov@pve tf-vm-provisioner --privsep=0 >> api_token.txt
