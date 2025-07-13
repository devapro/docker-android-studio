#!/bin/bash


mkdir -p ./studio-data/profile/Android
mkdir -p ./studio-data/profile/.android
mkdir -p ./studio-data/profile/.gradle
mkdir -p ./studio-data/profile/.java
mkdir -p ./studio-data/profile/.config
mkdir -p ./studio-data/profile/.cache

docker-compose up --build