### Android Studio in browser (in docker)

The goal of this project is to create a simple solution to run Android Studion and emulator in browser on any devices.

Simple deploy:

`docker-compose up --build`

Folders mapping:

- data/profile - folders with configs and cache
- data/Project - folder for AS projects

Included:
- Android studio
- Firefox
- noVnc

Run (creates required folders):

`/bin/bash run.sh`

Known issues:
- emulator doesn't work in Devices tool window
