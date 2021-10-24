#!/bin/bash
source catkin_my_mavros/devel/setup.bash
DIR="$(rospack find my_mavros)/scripts/rviz_config.rviz"
rosrun rviz rviz -d $DIR