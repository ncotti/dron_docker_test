#Clono el repositorio de PX4 y lo pongo en la última version estable al momento de armar el container
git clone https://github.com/PX4/PX4-Autopilot.git
cd PX4-Autopilot
git checkout v1.12.3

#Buildeo la imagen de Docker
docker build --build-arg UID=$(id -u) \
 --build-arg GID=$(id -g)  \
 -f ../Docker/Dockerfile \
 -t test-image .

