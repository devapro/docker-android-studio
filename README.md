### Android Studio in browser (in docker)

The goal of this project is to create a simple solution to run Android Studion and emulator in browser on any devices.

#### Quick start:

1. In docker-compose.yml replace in line `/home/auser/Projects/Android` with folder to your Android projects

2. Run script that create required folders

`/bin/bash run.sh`

3. Open http://127.0.0.1
4. Enter password `123456`
5. Open terminal and type `android-studio` 

#### Folders mapping:

- data/profile - folders with configs and cache
- data/Project - folder for AS projects

#### Included:
- Android studio
- Firefox
- noVnc

#### Known issues:
- emulator doesn't work in Devices tool window
