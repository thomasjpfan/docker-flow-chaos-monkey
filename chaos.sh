#!/bin/bash
export chaos_sleep=10
export chaos_start=10
export chaos_stack=random
docker stack deploy --compose-file chaos.yml ${chaos_stack} 

