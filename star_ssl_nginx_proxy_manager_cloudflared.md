# star ssl nginx proxy manager cloudflared dns challenge

```
*.odoo.somedomain.example

cloudflare

website > dns > records
A   *.odoo  ip address

website > overview > get your api token > create token > create custom token > get started
permissions
zone    dns edit

nginx proxy manager

ssl certificates > add ssl certificate > let's encrypt
domain names : *.odoo.somedomain.example
use a dns challenge
dns provider : cloudflare
credentials file content : tokene ambil dari cloudflare

host > proxy host > add proxy host
domain names : *.odoo.somedomain.example
ssl certificate : *.odoo.somedomain.example
force ssl
http/2 support

catatan
- use a dns challenge ini juga bisa digunakan untuk ssl ip lokal

```