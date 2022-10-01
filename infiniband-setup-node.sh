#!/bin/bash

apt-get install opensm
apt-get install net-tools
echo -e "mlx4_core\nmlx4_ib\nib_umad\nib_uverbs\nib_ipoib\nxprtrdma" >> /etc/modules
