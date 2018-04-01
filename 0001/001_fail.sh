#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  echo "** Trapped CTRL-C"
  export chaos_sleep=0
  export chaos_start=1
  export chaos_service=one
  export chaos_replicas=1
  echo "bring \"one\" back online... "
  ../chaos_service.sh
  waitForService "one"
  waitForService "two"
  echo "remove \"one\" and \"two\" "
  docker service rm one two
}

function isOnline {
  curl -s localhost/${1}/ | grep Welcome >/dev/null 2>/dev/null
}

function waitForService {
  i=1
  timeout=${2:-0}
  echo -n "waiting for \"${1}\" to come online"
  until isOnline ${1}; do
    echo -n "."
    sleep 1
    if [ ${i} -eq ${timeout} ]; then
      echo ". timed out. (${2})"
      return 1
    fi
    i=$((i + 1))
  done
  echo "."
  return 0
}

echo "start the first service quickly...."
export chaos_sleep=0
export chaos_start=1
export chaos_service=one
export chaos_replicas=1
../chaos_service.sh
echo "swarm-listener will see \"one\", notify proxy and proxy will complete the configuration. "
waitForService ${chaos_service}


echo "start second service slowly..."
export chaos_sleep=30
export chaos_start=30
export chaos_service=two
export chaos_replicas=1
../chaos_service.sh
echo "swarm-listener will see \"two\" and notify proxy, proxy will fail to resolve \"two\" because it has not yet completed its health check and is not available to the swarm"


waitForService ${chaos_service} 5

echo "remove the first service "
docker service rm one 

echo "swarm listener is still waiting on/retrying the config for \"two\". Eventually \"two\" will come online but with \"one\" gone, proxy will fail to verify the congig... swarm-listener will contine to try to configure \"two\" ?forever?.... and will not see any other services come online/go offline  "

echo ""

echo "the script will now wait forever for service \"two\" to come online. ctrl-c will cause the script to clean everything up... "

waitForService "two"
