#!/bin/bash
# ~/show-disks
# Tampilan rapi + per partisi + SERIAL + UUID

FMT="%-8s %-9s %-6s %-24s %-20s %-20s %-37s %-15s %s\n"

printf "$FMT" "DEVICE" "SIZE" "TRAN" "ID_MODEL" "ID_USB_MODEL" "SERIAL" "UUID" "PARTITION" "MOUNTPOINT"
printf "$FMT" "--------" "---------" "------" "------------------------" "--------------------" "--------------------" "-------------------------------------" "---------------" "----------"

for dev in /dev/sd?; do
  # Informasi level device utama (disk)
  name=$(basename "$dev")
  size=$(lsblk -dn -o SIZE "$dev")
  tran=$(udevadm info --query=property --name="$dev" 2>/dev/null | awk -F= '/^ID_BUS=/{print $2}')
  [ -z "$tran" ] && tran=$(lsblk -dn -o TRAN "$dev" 2>/dev/null)

  id_model=$(udevadm info --query=property --name="$dev" 2>/dev/null | awk -F= '/^ID_MODEL=/{print $2}')
  id_usb_model=$(udevadm info --query=property --name="$dev" 2>/dev/null | awk -F= '/^ID_USB_MODEL=/{print $2}')
  serial=$(udevadm info --query=property --name="$dev" 2>/dev/null | awk -F= '/^ID_SERIAL_SHORT=/{print $2}')
  [ -z "$serial" ] && serial=$(udevadm info --query=property --name="$dev" | awk -F= '/^ID_SERIAL=/{print $2}')

  # Daftar partisi dari device ini
  parts=($(lsblk -nr -o NAME "$dev" | grep -v "^$(basename "$dev")$"))

  if [ ${#parts[@]} -eq 0 ]; then
    # Kalau tidak ada partisi (disk kosong)
    uuid=$(blkid -s UUID -o value "$dev" 2>/dev/null)
    mount=$(lsblk -nr -o MOUNTPOINT "$dev" 2>/dev/null | grep -v '^$' | head -n1)
    [ -z "$uuid" ] && uuid="-"
    [ -z "$mount" ] && mount="-"
    printf "$FMT" "$name" "$size" "$tran" "$id_model" "$id_usb_model" "$serial" "$uuid" "-" "$mount"
  else
    # Loop setiap partisi
    for part in "${parts[@]}"; do
      uuid=$(blkid -s UUID -o value "/dev/$part" 2>/dev/null)
      mount=$(lsblk -nr -o MOUNTPOINT "/dev/$part" 2>/dev/null | grep -v '^$' | head -n1)
      part_size=$(lsblk -dn -o SIZE "/dev/$part")

      [ -z "$uuid" ] && uuid="-"
      [ -z "$mount" ] && mount="-"
      [ -z "$tran" ] && tran="-"
      [ -z "$id_model" ] && id_model="-"
      [ -z "$id_usb_model" ] && id_usb_model="-"
      [ -z "$serial" ] && serial="-"

      printf "$FMT" "$name" "$size" "$tran" "$id_model" "$id_usb_model" "$serial" "$uuid" "/dev/$part" "$mount"
    done
  fi
done