#!/bin/bash
set -e

output=$(husarnet-dds singleshot) || true
if [[ "$HUSARNET_DDS_DEBUG" == "TRUE" ]]; then
  echo "$output"
fi

# Check if XRCE_DOMAIN_ID_OVERRIDE is unset or empty
if [ -z "$XRCE_DOMAIN_ID_OVERRIDE" ]; then
    # If ROS_DOMAIN_ID is set and not empty, set XRCE_DOMAIN_ID_OVERRIDE to its value
    if [ -n "$ROS_DOMAIN_ID" ]; then
        export XRCE_DOMAIN_ID_OVERRIDE="$ROS_DOMAIN_ID"
    fi
fi

if [[ "$ROS_LOCALHOST_ONLY" == "1" ]]; then
    # microros agent doesn't work with ROS_LOCALHOST_ONLY and RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
    export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
    if [[ -z "$FASTRTPS_DEFAULT_PROFILES_FILE" ]]; then
        echo "running ROS_LOCALHOST_ONLY setup"
        # Set the FASTRTPS_DEFAULT_PROFILES_FILE environment variable
        export FASTRTPS_DEFAULT_PROFILES_FILE=/microros_locahost_only.xml
    fi
fi

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
test -f "/ros2_ws/install/setup.bash" && source "/ros2_ws/install/setup.bash"

exec "$@"
