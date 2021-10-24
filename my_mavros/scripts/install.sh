#Pido la contraseña de sudo ahora, así no la tengo que pedir en el medio de la instalación
sudo echo "Hola"

#Armamos el directorio
cd catkin_my_mavros
catkin_make

#Instalamos Mavros y Mavlink, en caso de no tenerlos
sudo apt-get install ros-noetic-mavros ros-noetic-mavros-extras ros-noetic-mavlink
wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
chmod +x install_geographiclib_datasets.sh
sudo ./install_geographiclib_datasets.sh
rm ./install_geographiclib_datasets.sh

#Instalo miscelaneos
sudo apt install xmlstarlet

#Instalo las dependencias de mi paquete
source /opt/ros/noetic/setup.bash
source devel/setup.bash
rosdep install my_mavros
catkin_make

#Instalo PX4
cd src
git clone https://github.com/PX4/PX4-Autopilot.git --recursive
cd PX4-Autopilot
DONT_RUN=1 make px4_sitl_default gazebo
cd ../../..


