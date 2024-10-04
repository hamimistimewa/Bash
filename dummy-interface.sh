#!/bin/bash

set -e

# Cek jika antarmuka dummy sudah ada, lalu hapus
echo "Removing existing dummy interface if it exists."
if ip link show dummy0 &> /dev/null; then
  sudo ip link delete dummy0 type dummy
  echo "Dummy interface 'dummy0' removed."
else
  echo "No existing dummy interface found."
fi

# Tambahkan antarmuka dummy baru
echo "Adding dummy0."
sudo ip link add dummy0 type dummy
sudo ip addr add 169.254.0.1/16 dev dummy0  # IP link-local
sudo ip link set dummy0 up
echo "Dummy interface 'dummy0' added and configured."

# Verifikasi antarmuka dummy
echo "Current network interfaces:"
ip a show dummy0
