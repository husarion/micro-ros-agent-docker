#!/bin/bash
set -e

if [[ -v FASTRTPS_DEFAULT_PROFILES_FILE ]]; then
    auxfile="/dds-config-aux.xml"
    cp --attributes-only --preserve $FASTRTPS_DEFAULT_PROFILES_FILE $auxfile
    cat $FASTRTPS_DEFAULT_PROFILES_FILE | envsubst > $auxfile
    export FASTRTPS_DEFAULT_PROFILES_FILE=$auxfile
fi

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/uros_ws/install/local_setup.bash"

exec ros2 run micro_ros_agent micro_ros_agent "$@"