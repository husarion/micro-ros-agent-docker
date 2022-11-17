FROM ros:humble-ros-core

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
        ros-$ROS_DISTRO-rmw-fastrtps-cpp \
        ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
		gettext-base && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=microros/micro-ros-agent:humble /uros_ws /uros_ws

WORKDIR /uros_ws

ENV RMW_IMPLEMENTATION=rmw_fastrtps_cpp

RUN echo ". /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
RUN echo ". /uros_ws/install/setup.bash" >> ~/.bashrc

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/bin/sh", "/ros_entrypoint.sh"]
CMD ["--help"]