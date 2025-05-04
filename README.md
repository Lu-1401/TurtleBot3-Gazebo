# TurtleBot3-Gazebo
Simulación de un robot que implementa la tecnología SLAM y LIDAR con Docker, implementando un TurtleBot3 donde se creará un mapa en tiempo real. 

# 1.El paso 1 es la creación del siguiente dockerfile: 

# Imagen base con ROS Noetic, Gazebo y herramientas de desarrollo
FROM osrf/ros:noetic-desktop-full

# Instalar dependencias gráficas y herramientas
RUN apt-get update && apt-get install -y \
    ros-noetic-turtlebot3 \
    ros-noetic-turtlebot3-simulations \
    ros-noetic-slam-gmapping \
    x11-apps \
    mesa-utils \
    libgl1-mesa-glx \
    libgl1-mesa-dri

# Definir variables de entorno para X11 y modelo TurtleBot3
ENV TURTLEBOT3_MODEL=burger
ENV DISPLAY=${DISPLAY}
ENV NVIDIA_DRIVER_CAPABILITIES=all  # Solo si usas GPU NVIDIA

# Configurar X11 forwarding
RUN echo "export QT_X11_NO_MITSHM=1" >> /root/.bashrc

# Comando de inicio
CMD ["bash"]

# 2. El paso 2 es la ejecución del sistema:

#Terminal 1: Simulacion (Gazebo)
docker run -it \
>   --env="DISPLAY=${DISPLAY}" \
>   --env="QT_X11_NO_MITSHM=1" \
>   --env LIBGL_ALWAYS_SOFTWARE=1 \
>   --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
>   --volume="/dev/dri:/dev/dri" \
>   --device=/dev/dri \
>   --network=host \
>   --name=slam-bot-2 \
>   turtlebot3-slam

# Terminal 2: SLAM (dentro del mismo contenedor)

docker exec -it slam-bot bash -c "source /opt/ros/noetic/setup.bash && rosrun rviz rviz -d /opt/ros/noetic/share/turtlebot3_slam/rviz/turtlebot3_gmapping.rviz"

# Terminal 3: Teleoperacion  (para mover el robot)

docker exec -it slam-bot bash -c "source /opt/ros/noetic/setup.bash && roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch"

