#!/usr/bin/bash

dirlist=`ls results/`
OUTFILE=$1
echo $dirlist

for i in $dirlist
do
    THREAD=`grep "GRPC_SERVER_CPUS" results/$i/bench.params | cut -d "=" -f 2`
#    RPS=`grep 'Requests/sec' results/$i/cpp_grpc_mt_bench.report | cut -f 2`
#    AVG=`grep 'Average' results/$i/cpp_grpc_mt_bench.report | cut -f 2 | cut -d " " -f 1`
    
    RPS=`./analyze-lite.sh results/$i | grep cpp_grpc_mt | cut -d "|" -f 3 | tr -s " " | cut -d " " -f 2`
    AVG=`./analyze-lite.sh results/$i | grep cpp_grpc_mt | cut -d "|" -f 4 | tr -s " " | cut -d " " -f 2`
    echo "$THREAD,$RPS,$AVG"
    echo "$THREAD,$RPS,$AVG" >> $OUTFILE
done
