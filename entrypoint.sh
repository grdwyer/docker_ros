#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/foxy/setup.bash"
source "/moveit_ws/install/setup.bash"
exec "$@"