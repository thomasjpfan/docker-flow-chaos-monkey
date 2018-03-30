#!/bin/bash
docker network ls |grep " proxy " || docker network create --driver overlay proxy
docker stack deploy --compose-file ./stack/docker-flow.yml proxy
