echo "start the first service quickly...."
export chaos_sleep=0
export chaos_start=1
export chaos_service=one
export chaos_replicas=1
../chaos_service.sh
echo "swarm-listener will see \"one\", notify proxy and proxy will complete the configuration. "
sleep 1
#docker service ps one 


echo "start second service slowly..."
export chaos_sleep=30
export chaos_start=30
export chaos_service=two
export chaos_replicas=1
../chaos_service.sh
echo "swarm-listener will see \"two\" and notify proxy, proxy will fail to resolve \"two\" because it has not yet completed its health check and is not available to the swarm"
#docker service ps two 

echo "wait 5 seconds..."
sleep 5

echo "remove the first service "
docker service rm one 

echo "swarm listener is still waiting on/retrying the config for \"two\". Eventually \"two\" will come online but with \"one\" gone, proxy will not complete the config for \"two\"... swarm-listener will contine to try to configure \"two\" ?forever?.... and will not see any other services come online/go offline  "
