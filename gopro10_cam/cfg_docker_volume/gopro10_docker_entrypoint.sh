#!/bin/bash
    set -e

    # setup ros environment
    if [ -z "${SETUP}" ]; then
        # basic ros environment
        source "/opt/ros/$ROS_DISTRO/setup.bash"

    else
       #from environment variable; should be a absolute path to the appropriate workspaces's setup.bash
        #source $SETUP
        source "/opt/ros/overlay_ws/devel/setup.bash"
    fi
source "/opt/ros/overlay_ws/devel/setup.bash"
roslaunch rovio gopro10_docker_rosbagplay_node.launch
#rosbag play --delay 10 -q  /opt/ros/rosbag_testdata/MH_01_easy.bag
#    roslaunch rovio rovio_node.launch
    exec "$@"
