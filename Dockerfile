ARG ROS_DISTRO=humble
ARG PREFIX=

FROM ros:${ROS_DISTRO} AS micro-ros-builder

WORKDIR /ros2_ws

RUN git clone --depth 1 -b humble https://github.com/micro-ROS/micro_ros_setup.git src/micro_ros_setup && \
    . /opt/ros/$ROS_DISTRO/setup.sh && \
    apt update && \
    apt install -y ed python3-pip && \
    apt install -y ros-$ROS_DISTRO-rmw-fastrtps-cpp && \
    apt remove -y ros-$ROS_DISTRO-rmw-cyclonedds-cpp && \
    apt autoremove -y && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    colcon build && \
    echo $(cat /ros2_ws/src/micro_ros_setup/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') > /version.txt && \
    rm -rf log/ build/ src/* && \
    rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    . install/local_setup.sh && \
    apt update && \
    ros2 run micro_ros_setup create_agent_ws.sh && \
    ros2 run micro_ros_setup build_agent.sh && \
    rm -rf log/ build/ src/

FROM husarnet/ros:${PREFIX}${ROS_DISTRO}-ros-core

SHELL ["/bin/bash", "-c"]

COPY --from=micro-ros-builder /ros2_ws /ros2_ws
COPY --from=micro-ros-builder /version.txt /version.txt 
COPY microros_locahost_only.xml /
COPY ./entrypoint_additions.sh /

RUN sed -i "/# <additional-user-commands>/r /entrypoint_additions.sh" /*_entrypoint.sh && \
    sed -i "/# <additional-user-commands>/d" /*_entrypoint.sh

CMD ros2 run micro_ros_agent micro_ros_agent --help