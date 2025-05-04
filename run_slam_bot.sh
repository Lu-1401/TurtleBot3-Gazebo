#!/bin/bash

xhost +local:root
docker rm -f slam-bot > /dev/null 2>&1

docker run -it \
  --env="DISPLAY=${DISPLAY}" \
  --env="QT_X11_NO_MITSHM=1" \
  --env LIBGL_ALWAYS_SOFTWARE=1 \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="/dev/dri:/dev/dri" \
  --device=/dev/dri \
  --network=host \
  --name=slam-bot \
  turtlebot3-slam
