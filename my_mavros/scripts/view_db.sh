#!/bin/bash
source catkin_my_mavros/devel/setup.bash
DIR="$(rospack find my_mavros)/recordings/cylinders/merged.db"

rtabmap $DIR