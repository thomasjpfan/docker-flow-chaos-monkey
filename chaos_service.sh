#!/bin/bash
#set -x
export chaos_sleep=${chaos_sleep:-10}
export chaos_start=${chaos_start:-10}
export chaos_service=${chaos_service:-random}
export chaos_replicas=${chaos_replicas:-1}
echo "Starting ${chaos_service}"
docker service create \
  --name ${chaos_service} \
  -e chaos_sleep=${chaos_sleep} \
  --network proxy \
  --label com.df.notify=true \
  --label com.df.servicePath=/${chaos_service} \
  --label com.df.port=80 \
  --label com.df.reqPathSearchReplace='/'${chaos_service}'/,//' \
  --replicas ${chaos_replicas} \
  --health-cmd "curl localhost || exit 1" \
  --health-interval 3s \
  --health-retries 3 \
  --health-start-period ${chaos_start}s \
  --health-timeout 2s \
  --detach \
  lelandsindt/docker-flow-chaos-monkey
