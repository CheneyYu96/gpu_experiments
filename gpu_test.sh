#!/usr/bin/env bash
set -euo pipefail
set -x

main() {

    cd /home/ubuntu/example

    mkdir -p log
    NUM=8216
    BATCH=1

    while [ $BATCH -le 256 ]; do
        for CUR in 10 20; do 
            ./countable_client/inception_client --server=0.0.0.0:9000 --image=test.jpg --concurrency=${CUR} --batch_size=${BATCH} --num_tests=${NUM} \
            --time_out=5 &> log/${CUR}-${BATCH}.log &

            PID=$!
            wait $PID
        done
        let BATCH*=2
    done

}

main
