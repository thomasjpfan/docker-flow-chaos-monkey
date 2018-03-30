#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  echo "** Trapped CTRL-C"
  for i in {1..10}; do
    docker service ls |grep " monkey_${i}  " && docker service rm monkey_${i}
  done
  exit 0
}

while true; do
  for i in {1..10}; do
    case $(( ( RANDOM % 10 )  + 1 )) in 
    1)
      echo "start" 
      export chaos_sleep=$(( ( RANDOM % 10 )  + 1 ))
      export chaos_start=$(( ( RANDOM % 10 )  + 1 ))
      export chaos_service=monkey_${i}
      export chaos_replicas=$(( ( RANDOM % 10 )  + 1 ))
      docker service ls |grep " monkey_${i} " || ./chaos_service.sh
      ;;
    2) 
      echo "stop"
      docker service ls |grep " monkey_${i}  " && docker service rm monkey_${i}
      ;;
    esac
  done
done
