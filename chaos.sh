#!/bin/bash
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

monkeys=10

function ctrl_c() {
	echo "** Trapped CTRL-C"
	for i in $(seq ${monkeys}); do
		docker service ls | grep " monkey_${i}  " && docker service rm monkey_${i}
	done
	exit 0
}

while true; do
	for i in $(seq ${monkeys}); do
		case $(((RANDOM % 2) + 1)) in
			1)
				echo "*** start monkey_${i}"
				export chaos_sleep=$(((RANDOM % 10) + 1))
				export chaos_start=$(((RANDOM % 10) + 1))
				export chaos_service=monkey_${i}
				export chaos_replicas=1
				docker service ls | grep " monkey_${i} " || ./chaos_service.sh
				;;
			2)
				echo "*** stop monkey_${i}"
				docker service ls | grep " monkey_${i}  " && docker service rm monkey_${i}
				;;
			*)
				echo "*** skip monkey_${i}"
				;;
		esac
	done
	sleep_for=$(((RANDOM % 10) + 1))
	echo "waiting for: ${sleep_for} seconds "
	sleep ${sleep_for}
done
