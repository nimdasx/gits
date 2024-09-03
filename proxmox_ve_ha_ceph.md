setup proxmox ve ha, 3 node
1. size 50gb untuk proxmox
2. buat partisi kosong untuk ceph, maksimalkan dari node dengan disk terkecil
3. cleate cluster
4. install ceph
5. create osd
6. create pool (hanya di salah satu node)
7. create monitor
8. create vm/ct
9. datacenter > ha > resouces > add vm/ct tersebut

hapus osd
1. tandai osd menjadi out, tunggu hingga healthy normal
2. stop osd
3. destroy osd

catatan
- aman merubah password root setelah jadi cluster
- osd harus menggunakan drive atau sisa space yang belum dipartisi