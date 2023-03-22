#!/bin/bash
set -e

output=$(husarnet-dds singleshot) || true
if [[ "$HUSARNET_DDS_DEBUG" == "TRUE" ]]; then
  echo "$output"
fi

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
test -f "/ros2_ws/install/setup.bash" && source "/ros2_ws/install/setup.bash"

# SERIAL_PORT defined on ROSbot 2 2R PRO
if [ -e $SERIAL_PORT ]; then
  echo "$ROS_DOMAIN_ID" >> "$SERIAL_PORT"
fi

exec "$@"