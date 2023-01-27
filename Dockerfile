
FROM ros:humble AS micro-ros-builder

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

FROM husarnet/ros:humble-ros-core

SHELL ["/bin/bash", "-c"]

COPY --from=micro-ros-builder /ros2_ws /ros2_ws
COPY --from=micro-ros-builder /version.txt /version.txt 

RUN echo ". /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
RUN echo ". /ros2_ws/install/setup.bash" >> ~/.bashrc

CMD ros2 run micro_ros_agent micro_ros_agent --help