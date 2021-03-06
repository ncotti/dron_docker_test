FROM ubuntu:focal

ARG UID
ARG GID


##########################################################################
#   Setup timezone
##########################################################################
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*


##########################################################################
#   Instalación de paquetes esenciales, en orden:
#   dirmngr:        necesario para instalar
#   gnupg2:         necesario para instalar
#   lsb-release:    necesario para instalar
#   xmlstarlet:     modifica archivos xml (los modelos de gazebo sdf).
##########################################################################
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    lsb-release \
    xmlstarlet \
    && rm -rf /var/lib/apt/lists/*


##########################################################################
#   Setup keys, en orden:
#   ROS
##########################################################################
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys \
    C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654


##########################################################################
#   Setup sources.list
##########################################################################
RUN . /etc/os-release \
    && echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros1-latest.list


##########################################################################
#   Setup environment
##########################################################################
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO noetic


##########################################################################
#   Instalación de paquetes de ROS (sacados del package.xlm).
##########################################################################
#El paquete base más completo, con rviz, rqt y gazebo
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-desktop-full=1.5.0-1* \
    && rm -rf /var/lib/apt/lists/*

#Los paquetes que aparecen en el package.xml de mi paquete (más mavlink y mavros-extras)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-geometry-msgs \
    ros-noetic-mavros-msgs \
    ros-noetic-geographic-msgs \
    ros-noetic-nav-msgs \
    ros-noetic-mavros \
    ros-noetic-roscpp \
    ros-noetic-rospy \
    ros-noetic-tf2 \
    ros-noetic-tf2-ros \
    ros-noetic-tf2-tools \
    ros-noetic-gazebo-ros \
    ros-noetic-rtabmap-ros \
    ros-noetic-geodesy \
    ros-noetic-mavlink \
    ros-noetic-mavros-extras \
    && rm -rf /var/lib/apt/lists/*


##########################################################################
#   Instalación de GeographicLib
##########################################################################
RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh \
    && chmod +x install_geographiclib_datasets.sh \
    && ./install_geographiclib_datasets.sh \
    && rm ./install_geographiclib_datasets.sh

##########################################################################
#   Instalación de rosdep (manejador de dependencias de ROS)
##########################################################################
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python3-rosdep \
    python3-rosinstall \
    python3-vcstools \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

##########################################################################
#   Creo sudo usuario (permite ver GUIs y necesario para que los programas funcionen bien)
##########################################################################
RUN groupadd --gid $GID user
RUN adduser --disabled-password --gecos '' --uid $UID --gid $GID user
USER user

##########################################################################
#   Instalación de los paquetes propios
##########################################################################
WORKDIR /home/user

#Copio los paquetes en las direcciones (crea las carpetas también)
COPY "../my_mavros /home/user/catkin_my_mavros/src/my_mavros"
COPY "../PX4-Autopilot /home/user/catkin_my_mavros/src/PX4-Autopilot"

WORKDIR /home/user/catkin_my_mavros

RUN catkin_make

##########################################################################
#   Instalación de PX4
##########################################################################

WORKDIR /home/user/catkin_my_mavros/PX4-Autopilot
RUN DONT_RUN=1 make px4_sitl_default gazebo

##########################################################################
#   Salida del container
##########################################################################
WORKDIR /home/user
COPY ./my_entrypoint.sh /
ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]
