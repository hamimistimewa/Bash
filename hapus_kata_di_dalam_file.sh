#!/bin/bash

# Daftar file yang akan diproses
file_list=(
    "/etc/nginx/conf.d/domain1.com.conf"
    "/etc/nginx/conf.d/domain2.com.conf"
)

# Loop melalui setiap file dan hapus baris yang mengandung 'proxy_protocol'
for file in "${file_list[@]}"; do
    if [ -f "$file" ]; then
        sed -i '/proxy_protocol/d' "$file" # input kata yang mau di hapus contoh disini akan menghapus "proxy_protocol" di config Nginx. 
        echo "Kata 'proxy_protocol' telah dihapus dari $file"
    else
        echo "File $file tidak ditemukan."
    fi
done

echo "Proses selesai."
