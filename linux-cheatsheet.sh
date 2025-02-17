#tmux gawe sesi anyar jenenge gundam
tmux new -s gundam

#tmux mbalik neng sesi gundam
tmux a -t gundam

#urutkan file berdasarkan size
ls -lSh

#restore mysql db dengan lihat progres dan eta
pv namafile.sql | mysql -u tetanus -p vendermord