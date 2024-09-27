#!/bin/bash
set -e
docker rm $(docker ps --all -q)
