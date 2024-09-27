#!/bin/bash
set -e
if [ "$#" -eq 0 ]; then

    echo "Usage: dockerRun.sh [docker run options]... <Imagename>:<ImageTag>"
    echo " "
    echo "Run a docker image as standard user"
    echo "Example:"
    echo "   dockerRun.sh cuda11.4.1-ubuntu20.04:latest"
    exit 2
fi


export USER_UID=$(id -u)
export USER_GID=$(id -g)
docker run -it \
       --gpus all \
       --net=bridge \
       --rm \
       --workdir="/home/$USER" \
       --volume="/home/max:/home/max:rw" \
       --volume="/home/$USER:/home/$USER:rw" \
       --volume="/etc/group:/etc/group2:ro" \
       --volume="/etc/passwd:/etc/passwd:ro" \
       --volume="/etc/shadow:/etc/shadow:ro" \
       --volume="/etc/sudoers:/etc/sudoers2:ro" \
       -e "TARGET_DOCKER_USER=$USER" \
       ${@: -1}


#--user $USER_UID:$USER_GID \
