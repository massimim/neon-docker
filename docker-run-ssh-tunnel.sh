#!/bin/bash
set -e
set -x

#!/bin/bash

help()
{
    echo "Usage: weather [ -i | --image docker-image-name]
               [ -t | --tunnel hostPort:dockerPort]
               [ -h | --help  ]"
    echo "Example"
    echo "./dockerRunSshTunnel.sh -image cuda:11.8.0.ubuntu.22.04 --tunnel 2222:22"
    exit 2
}

SHORT=i:,d:,h
LONG=image:,tunnel:,help
OPTS=$(getopt -a -n dockerRunSshTunnel --options $SHORT --longoptions $LONG -- "$@")

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

if [ "$VALID_ARGUMENTS" -eq 0 ]; then
  help
fi

eval set -- "$OPTS"

image="none"
tunnel="none"

while :
do
  case "$1" in
    -i | --image )
      image="$2"
      shift 2
      ;;
    -t | --tunnel )
      tunnel="$2"
      shift 2
      ;;
    -h | --help)
      help
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      help
      ;;
  esac
done


if [ "$image" = "none" ]; then
    echo "Missing image name"
    help
else
    echo "[] Selected image: $image"
fi


export USER_UID=$(id -u)
export USER_GID=$(id -g)


if [ "$tunnel" = "none" ]; then
    echo "[] No tunnel configured"
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
	   --volume="/raid/home/$USER:/home/$USER/raid:rw" \
	   -e "TARGET_DOCKER_USER=$USER" \
	   ${image}
else
    echo "[] Selected tunnel ${tunnel}"
    docker run -it \
	   --gpus all \
	   --net=bridge \
	   -p ${tunnel}\
	   --rm \
	   --workdir="/home/$USER" \
	   --volume="/home/max:/home/max:rw" \
	   --volume="/home/$USER:/home/$USER:rw" \
	   --volume="/etc/group:/etc/group2:ro" \
	   --volume="/etc/passwd:/etc/passwd:ro" \
	   --volume="/etc/shadow:/etc/shadow:ro" \
	   --volume="/etc/sudoers:/etc/sudoers2:ro" \
	   --volume="/raid/home/$USER:/home/$USER/raid:rw" \
	   -e "TARGET_DOCKER_USER=$USER" \
	   ${image}
fi

