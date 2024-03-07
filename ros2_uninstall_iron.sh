#!/bin/bash -eu

# The BSD License
# Copyright (c) 2024 RUNTIME Robotics

#set -x

echo "################################################################"
echo ""
echo ">>> {Uninstalling ROS Iron Installation from your computer}"
echo ""
echo ">>> {It will take around few minutes to complete}"
echo ""
sudo apt-get purge ros-iron-*
echo ""
echo "#################################################################"
echo ""
echo ">>> {Auto removing dependent packages}"
sudo apt-get autoremove
echo ""
echo ">>> {Done: ROS Iron Uninstall}"
echo "#################################################################"

