#!/bin/bash

docker run -it  -p 80:6080 -v /dev/kvm:/dev/kvm f8671c39950d

docker exec -it c4f1cfa496c3 bash  

docker build --no-cache .

sudo  apt-get install -y         build-essential git neovim wget unzip sudo         libc6 libncurses5 libstdc++6 lib32z1 libbz2-1.0         libxrender1 libxtst6 libxi6 libfreetype6 libxft2 xz-utils vim        qemu qemu-kvm  bridge-utils libnotify4 libglu1 libqt5widgets5  xvfb


--device /dev/dri:/dev/dri

--gpus '"device=0"'