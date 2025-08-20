# ros2_oneline_install
Single command to install 
* ROS 2 Jazzy in Ubuntu 24.04 LTS
* ROS 2 Humble and Iron Ubuntu 22.04 LTS

## ROS 2 Jazzy

Copy & Paste the following command to install/uninstall ROS 2 Jazzy in Ubuntu 24.04 LTS

To make the setup completely non-interactive you can use the following environment variables:

| Variable          | Values                   | Default | Description                                                                 |
|-------------------|--------------------------|---------|-----------------------------------------------------------------------------|
| `NONINTERACTIVE`  | `0` (interactive), `1` non interactive   | `0`     | If set to `1`, skips prompts and uses environment variables for configuration. |
| `ROS_INSTALL_CHOICE` | `1` (Desktop Full), `2` (ROS Desktop), `3` (ROS Base) | Not set     | Chooses which ROS variant to install. **Only used when `NONINTERACTIVE=1`**.      |

**Install ROS 2 Jazzy**

```
wget -c https://raw.githubusercontent.com/runtimerobotics/ros2_oneline_install/main/ros2_install_jazzy.sh && chmod +x ./ros2_install_jazzy.sh && ./ros2_install_jazzy.sh
```

**Uninstall ROS 2 Jazzy**

```
wget -c https://raw.githubusercontent.com/runtimerobotics/ros2_oneline_install/main/ros2_uninstall_humble.sh && chmod +x ./ros2_uninstall_humble.sh && ./ros2_uninstall_humble.sh
```



## ROS 2 Humble

Copy & Paste the following command to install/uninstall ROS 2 Humble in Ubuntu 22.04 LTS

**Install ROS 2 Humble**

```
wget -c https://raw.githubusercontent.com/runtimerobotics/ros2_oneline_install/main/ros2_install_humble.sh && chmod +x ./ros2_install_humble.sh && ./ros2_install_humble.sh
```

**Uninstall ROS 2 Humble**

```
wget -c https://raw.githubusercontent.com/runtimerobotics/ros2_oneline_install/main/ros2_uninstall_humble.sh && chmod +x ./ros2_uninstall_humble.sh && ./ros2_uninstall_humble.sh
```


## ROS 2 Iron

Copy & Paste the following command to install ROS 2 Iron in Ubuntu 22.04 LTS

**Install ROS 2 Iron**

```
wget -c https://raw.githubusercontent.com/runtimerobotics/ros2_oneline_install/main/ros2_install_iron.sh && chmod +x ./ros2_install_iron.sh && ./ros2_install_iron.sh
```

**Uninstall ROS 2 Iron**

```
wget -c https://raw.githubusercontent.com/runtimerobotics/ros2_oneline_install/main/ros2_uninstall_iron.sh && chmod +x ./ros2_uninstall_iron.sh && ./ros2_uninstall_iron.sh
```
