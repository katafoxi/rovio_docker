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
roslaunch rovio rosbagplay_node.launch

exec "$@"
