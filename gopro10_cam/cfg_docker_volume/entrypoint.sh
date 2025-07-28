#!/bin/bash
set -e

# Setup ROS environment
if [ -z "${SETUP}" ]; then
    # Basic ROS environment
    source "/opt/ros/$ROS_DISTRO/setup.bash"
else
    # Custom setup (if SETUP variable is provided)
    source "/opt/ros/overlay_ws/devel/setup.bash"
fi

# Additional environment setup
source "/opt/ros/overlay_ws/devel/setup.bash"
export ROS_HOSTNAME=localhost
export ROS_MASTER_URI=http://localhost:11311

# Функция для интерактивного выбора launch-файла
choose_launch_file() {
    # Проверяем доступность интерактивного терминала
    if [ ! -t 0 ]; then
        echo "Error: No terminal detected. Running in non-interactive mode." >&2
        roslaunch rovio rosbagplay_node.launch
        return
    fi

    # Список доступных launch-файлов
    LAUNCH_FILES=(
        "rosbagplay_node.launch"
        "/opt/ros/overlay_ws/src/rovio/cfg/gopro10_bno055/bno055_rosbag_record.launch"
        "/opt/ros/overlay_ws/src/rovio/cfg/gopro10_docker/bno055_rosbag_record.launch"
    )

    while true; do
        echo "Available launch files:"
        for i in "${!LAUNCH_FILES[@]}"; do
            echo "$((i+1)). ${LAUNCH_FILES[$i]}"
        done
        
        read -p "Select a launch file by number (or 0 to exit): " choice
        
        if [[ $choice -eq 0 ]]; then
            echo "Exiting..."
            exit 0
        elif [[ $choice -gt 0 && $choice -le ${#LAUNCH_FILES[@]} ]]; then
            SELECTED_FILE="${LAUNCH_FILES[$((choice-1))]}"
            echo "Launching: $SELECTED_FILE"
            roslaunch rovio "$SELECTED_FILE"
            break
        else
            echo "Invalid choice! Please try again."
        fi
    done
}

# Основной код
case "$1" in
    --interactive)
        choose_launch_file
        ;;
    *)
        choose_launch_file
        # roslaunch rovio rosbagplay_node.launch
        ;;
esac


exec "$@"