FROM ros:noetic-ros-base
#FROM arm64v8/ros:noetic-ros-base

SHELL ["/bin/bash", "-c"]
ARG OVERLAY_WS=/opt/ros/overlay_ws

WORKDIR $OVERLAY_WS/src
WORKDIR $OVERLAY_WS/

RUN <<EOT bash
      apt-get update && apt-get install -y \
      git \
      pip \
      wget \
      freeglut3-dev \
      libglew-dev \
      vim \
      libyaml-cpp-dev \
      ros-$ROS_DISTRO-image-transport
      sudo pip3 install -U catkin_tools
      rosdep init
      catkin init
      git clone https://github.com/ANYbotics/kindr.git ./src/kindr
      git clone --recurse-submodules https://github.com/katafoxi/rovio2.git ./src/rovio
      rosdep install --from-paths src --ignore-src -r -y

EOT

RUN <<EOT

  catkin config --extend /opt/ros/$ROS_DISTRO
  catkin build rovio --cmake-args -DCMAKE_BUILD_TYPE=Release -DMAKE_SCENE=ON

EOT

# Arguments picked from the command line!
ARG user
ARG uid
ARG gid

#Add new user with our credentials
ENV USERNAME ${user}
RUN useradd -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod  --uid ${uid} $USERNAME && \
        groupmod --gid ${gid} $USERNAME


# WORKDIR /home/${user}
USER ${user}
# launch ros package
COPY ./ros_entrypoint.sh /opt/ros/
COPY ./rovio_rosbag_testnode.launch  $OVERLAY_WS/src/rovio/launch/
#ENTRYPOINT ["/bin/bash", "source", "/devel/setup.bash", "roslaunch", "rovio", "rovio_node.launch"]
ENTRYPOINT ["/opt/ros/ros_entrypoint.sh"]
# CMD ["bash"]
# CMD tail -f /dev/null
