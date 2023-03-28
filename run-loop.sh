#!/usr/bin/bash

#Maybe, need to change the setting.
export GRPC_IMAGE_NAME=grpc_bench_base
export GRPC_REQUEST_SCENARIO=representative1
#export GRPC_SERVER_CPUS=10

export GRPC_BENCHMARK_DURATION=120s
export GRPC_BENCHMARK_WARMUP=30s
export GRPC_SERVER_RAM=512m
export GRPC_CLIENT_CONNECTIONS=50
export GRPC_CLIENT_CONCURRENCY=1000
export GRPC_CLIENT_CPUS=10



for i in {0..200..5}
do
    if [ $i -eq 0 ]
    then
	i=1
	echo Hey that\'s a large number.
    fi    
    echo "Running $i benchmark......."
    export GRPC_SERVER_CPUS=$i
    env | grep GRPC

    ./bench.sh $1
    sleep 3
done
