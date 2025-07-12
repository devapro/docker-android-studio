#!/bin/bash

echo "`whoami`" | sudo -S chmod 777 /dev/kvm > /dev/null 2>&1

sudo chown -R ubuntu $HOME/

# if [ ! -z "$NGROK" ] ; then
#         case "$NGROK" in
#             [yY]|[yY][eE][sS])
#                 su ubuntu -c "$HOME/ngrok/ngrok http 6080 --log $HOME/ngrok/ngrok.log --log-format json" &
#                 sleep 5
#                 NGROK_URL=`curl -s http://127.0.0.1:4040/status | grep -P "http://.*?ngrok.io" -oh`
#                 su ubuntu -c "echo -e 'Ngrok URL = $NGROK_URL/vnc.html' > $HOME/ngrok/Ngrok_URL.txt"
#         esac
# fi

/usr/bin/supervisord -n
