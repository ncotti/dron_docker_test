#!/bin/bash

#Estos comandos se ejecutarán cada vez que se ejecute el container

set -e

source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/home/user/catkin_my_mavros/devel/setup.bash"

exec "$@"