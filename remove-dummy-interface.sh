#! /bin/sh

set -e

echo "Removing existing dummy interface."
nmcli con delete dummy-dummy0 || true

echo "Deleting dummy0 interface."
ip link delete dummy0 || true
