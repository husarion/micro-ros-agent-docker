# micro-ros-agent

[micro-ROS-Agent](https://github.com/micro-ROS/micro-ROS-Agent) ROS 2 Package with Husarion's extras

## Quick Start

### ROSbot 2R / 2 PRO

```yaml
services:

  rosbot:
    image: husarion/rosbot:humble
    environment:
      - ROS_DOMAIN_ID=2
    command: ros2 launch rosbot_bringup bringup.launch.py

  microros:
    image: husarion/micro-ros-agent:humble
    devices:
      - ${SERIAL_PORT:?err}
    environment:
      - ROS_DOMAIN_ID=2
    command: ros2 run micro_ros_agent micro_ros_agent serial -D $SERIAL_PORT serial -b 576000 # -v6
```

### ROSbot XL

```yaml
services:

  rosbot-xl:
    image: husarion/rosbot-xl:humble
    environment:
      - ROS_DOMAIN_ID=2
    command: ros2 launch rosbot_xl_bringup bringup.launch.py mecanum:=True

  microros:
    image: husarion/micro-ros-agent:humble
    ports:
        - 8888:8888/udp
    environment:
      - ROS_DOMAIN_ID=2
    command: ros2 run micro_ros_agent micro_ros_agent udp4 --port 8888
```