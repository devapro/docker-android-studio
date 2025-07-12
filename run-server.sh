#!/bin/bash

docker run -it  -p 80:6080 -v /dev/kvm:/dev/kvm f8671c39950d

docker exec -it c4f1cfa496c3 bash  

docker build --no-cache .