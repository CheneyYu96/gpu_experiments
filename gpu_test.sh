#!/usr/bin/env bash
set -euo pipefail
set -x

main() {

    cd /home/ubuntu/example

    LOG_DIR=/home/ubuntu/logs
    LOG_CLIENT=${LOG_DIR}/client
    mkdir -p ${LOG_CLIENT}
    NUM=8216
    BATCH=16

    while [ $BATCH -le 256 ]; do
        for CUR in 10 20; do 
            ./countable_client/inception_client --server=0.0.0.0:9000 --image=test.jpg --concurrency=${CUR} --batch_size=${BATCH} --num_tests=${NUM} \
            --time_out=20 &> ${LOG_DIR}/client/${CUR}-${BATCH}.log &

            PID=$!
            wait $PID
        done
        let BATCH*=2
    done

}

main
