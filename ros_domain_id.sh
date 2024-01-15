# Check if XRCE_DOMAIN_ID_OVERRIDE is unset or empty
if [ -z "$XRCE_DOMAIN_ID_OVERRIDE" ]; then
    # If ROS_DOMAIN_ID is set and not empty, set XRCE_DOMAIN_ID_OVERRIDE to its value
    if [ -n "$ROS_DOMAIN_ID" ]; then
        export XRCE_DOMAIN_ID_OVERRIDE="$ROS_DOMAIN_ID"
    fi
fi

