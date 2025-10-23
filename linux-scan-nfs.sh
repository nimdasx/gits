#!/bin/bash
# ~/scan-nfs.sh
# Scan subnet dan tampilkan NFS share yang aktif

SUBNET="192.168.0"   # ganti sesuai jaringanmu
TIMEOUT=1

echo -e "Scanning subnet: ${SUBNET}.0/24\n"

printf "%-15s %-40s %s\n" "IP_ADDRESS" "EXPORT_PATH" "PERMISSION"
printf "%-15s %-40s %s\n" "-----------" "----------------------------------------" "-----------"

for i in {1..254}; do
  host="${SUBNET}.${i}"
  exports=$(timeout $TIMEOUT showmount -e "$host" 2>/dev/null)

  if echo "$exports" | grep -q "Export list for"; then
    echo "$exports" | tail -n +2 | while read -r line; do
      path=$(echo "$line" | awk '{print $1}')
      perm=$(echo "$line" | awk '{print $2}')
      printf "%-15s %-40s %s\n" "$host" "$path" "$perm"
    done
  fi
done