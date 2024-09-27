# Neon docker container

This repo contains scripts and docker files to create a docker container with all the requirements to compile and run neon (https://github.com/Autodesk/Neon)
The docker container has been set with the following features:

- the docker user is the same as the host user
- the docker user has `sudo` previleges
- the user's host home is mapped to the user's docker home

## Building the docker

To build the docker container, you need to have docker installed in your machine. Then, you can run the following command:

```bash
./build-neon-cuda.12.2.0-ubuntu.22.04.sh
```

## Running the docker

To run the docker container, you can use the following command:

```bash
./docker-run.sh neon:cuda.12.2.0.ubuntu.22.04
```
