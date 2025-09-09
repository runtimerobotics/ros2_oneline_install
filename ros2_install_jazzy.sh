#!/bin/bash -eu

# The BSD License
# Copyright (c) 2024 RUNTIME Robotics
# Copyright (c) 2014 OROCA and ROS Korea Users Group

#set -x

# Add check for required dependencies
if ! command -v lsb_release &> /dev/null; then
    apt update && apt install -y lsb-release
fi

if ! command -v sudo &> /dev/null; then
    apt update && apt install -y sudo
fi

name_ros_distro=jazzy 
user_name=$(whoami)
echo "#######################################################################################################################"
echo ""
echo ">>> {Starting ROS 2 Jazzy Installation}"
echo ""
echo ">>> {Checking your Ubuntu version} "
echo ""

# Getting version and release number of Ubuntu
version=`lsb_release -sc`
relesenum=`grep DISTRIB_DESCRIPTION /etc/*-release | awk -F 'Ubuntu ' '{print $2}' | awk -F ' LTS' '{print $1}'`
echo ">>> {Your Ubuntu version is: [Ubuntu $version $relesenum]}"

# Checking version is noble, if yes proceed otherwise quit
case $version in
  "noble" )
  ;;
  *)
    echo ">>> {ERROR: This script will only work on Ubuntu Noble (24.04).}"
    exit 0
esac

echo ""
echo ">>> {ROS 2 Jazzy is fully compatible with Ubuntu Noble 24.04}"
echo ""
echo "#######################################################################################################################"
echo ">>> {Step 1: Configure your Ubuntu repositories}"
echo ""

locale  # check for UTF-8

# Thoroughly clean up any existing ROS 2 repository configurations
sudo rm -f /etc/apt/sources.list.d/ros2*.list
sudo rm -f /etc/apt/sources.list.d/ros-*.list
sudo rm -f /usr/share/keyrings/ros-archive-keyring.gpg
sudo rm -f /usr/share/ros/apt/gpg

sudo apt update 
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

##############################################################

sudo apt install -y software-properties-common
sudo add-apt-repository -y universe

echo ""
echo ">>> {Done: Added Ubuntu repositories}"
echo ""
echo "#######################################################################################################################"
echo ">>> {Step 2: Add ROS 2 repository and keys}"
echo ""

# Also check and remove any repository configurations in the main sources.list
if grep -q "packages.ros.org" /etc/apt/sources.list; then
    sudo sed -i '/packages.ros.org/d' /etc/apt/sources.list
fi

echo ">>> {Installing ROS 2 APT Source package}"
sudo apt update && sudo apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb

echo ">>> {Done: Added ROS 2 repository}"
echo ""
echo "#######################################################################################################################"
echo ">>> {Step 3: Updating Ubuntu package index, this will take few minutes depend on your network connection}"
echo ""
sudo apt update || {
    echo "Error updating package list. Attempting to fix..."
    sudo apt-get clean
    sudo apt update
}

sudo apt -y upgrade 

echo ""
echo "#######################################################################################################################"
echo ">>> {Step 4: Install ROS, you pick how much of ROS you would like to install.}"
echo "     [1. Desktop Full Install: (Recommended) : Everything in Desktop plus 2D/3D simulators and 2D/3D perception packages ]"
echo ""
echo "     [2. Desktop Install: Everything in Desktop ]"
echo ""
echo "     [3. ROS-Base: (Bare Bones) ROS packaging, build, and communication libraries. No GUI tools.]"
echo ""

# --- Configurable default ---
DEFAULT_CHOICE=1     # 1=desktop-full, 2=desktop, 3=ros-base

if [ "${NONINTERACTIVE:-}" = "1" ]; then
  # Non-interactive: take env var or fallback to default
  answer="${ROS_INSTALL_CHOICE:-$DEFAULT_CHOICE}"
  echo "NONINTERACTIVE mode: Using choice ${answer}"
else
  # Interactive mode: ask user, fallback to default on empty input
  read -r -p "Enter your install (Default is ${DEFAULT_CHOICE}) [1/2/3]: " answer
  answer="${answer:-$DEFAULT_CHOICE}"
fi

# Normalize/validate
case "$answer" in
  1)
    package_type="desktop-full"
    ;;
  2)
    package_type="desktop"
    ;;
  3)
    package_type="ros-base"
    ;; 
  *)
    echo "Unrecognized choice '$answer'. Falling back to default (${DEFAULT_CHOICE})."
    if [ "$DEFAULT_CHOICE" = "1" ]; then
      package_type="desktop-full"
    else
      package_type="ros-base"
    fi
    ;;
esac

echo "#######################################################################################################################"
echo ""
echo ">>>  {Starting ROS installation, this will take about 20 min. It will depend on your internet connection}"
echo ""
sudo apt install -y ros-${name_ros_distro}-${package_type} || {
  echo "Error: Failed to install ros-${name_ros_distro}-${package_type}. Exiting."
  exit 1
}

sudo apt install -y ros-dev-tools || {
  echo "Warning: Failed to install ros-dev-tools."
  echo "Trying alternative package name..."
  sudo apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
}

echo ""
echo ""
echo "#######################################################################################################################"
echo ">>> {Step 5: Setting ROS Environment, This will add ROS environment to .bashrc.}" 
echo ">>> { After adding this, you can able to access ROS commands in terminal}"
echo ""

# Check if ROS setup is already in .bashrc to avoid duplicates
if ! grep -q "source /opt/ros/${name_ros_distro}/setup.bash" /home/$user_name/.bashrc; then
  echo "source /opt/ros/${name_ros_distro}/setup.bash" >> /home/$user_name/.bashrc
fi

# Source for current session - temporarily disable error on unbound variable
# This prevents the AMENT_TRACE_SETUP_FILES unbound variable error
echo ""
echo "#######################################################################################################################"
echo ">>> {Step 6: Testing ROS installation, checking ROS version.}"
echo ""

if [ -f "/opt/ros/${name_ros_distro}/setup.bash" ]; then
  echo ">>> {Sourcing ROS environment...}"
  
  # Temporarily disable -u to source the file
  set +u
  source /opt/ros/${name_ros_distro}/setup.bash
  # Re-enable -u after sourcing
  set -u
  
  echo ">>> {Type [printenv ROS_DISTRO] to get the current ROS installed version}"
  echo ""
  printenv ROS_DISTRO
else
  echo "Warning: ROS setup.bash not found. Installation may have failed."
fi
echo "#######################################################################################################################"
