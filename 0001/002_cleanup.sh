export chaos_sleep=0
export chaos_start=1
export chaos_service=one
export chaos_replicas=1
echo "bring \"one\" online so that proxy/swarm-listener can complete the config of \"two\""
../chaos_service.sh
echo "wait a while... "
sleep 20

echo "take \"one\" and \"two\" offline... "

docker service rm one 
docker service rm two
