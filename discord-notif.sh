#masukkan ini ke dalam file .ssh/rc
~/notif-discord.sh "user $(whoami) login ke server $(hostname) pada ${date}"

#buat file notif-discord.sh dengan isi
discord_token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
discord_channel=11111111111111111111
discord_pesan=$1
curl \
  -i \
  -H "Accept: application/json" \
  -H "Content-Type:application/json" \
  -X POST \
  --data "{\"content\": \"$discord_pesan\"}" https://discord.com/api/webhooks/$discord_channel/$discord_token \
> /dev/null 2>&1