#!/usr/bin/env bash
set -euo pipefail
set -x

main() {

    cd /home/ubuntu/example

    LOG_DIR=/home/ubuntu/logs
    LOG_CLIENT=${LOG_DIR}/client
    mkdir -p ${LOG_CLIENT}
    NUM=8216
    BATCH=1

    for CUR in 10 20 30 40 50 60; do 
        TIME_OUT=20
        if [ ${CUR} -le 30 ]; then
            TIME_OUT=10
        fi

        ./countable_client/inception_client --server=0.0.0.0:9000 --image=test.jpg --concurrency=${CUR} --batch_size=${BATCH} --num_tests=${NUM} \
        --time_out=${TIME_OUT} &> ${LOG_DIR}/client/${CUR}-${BATCH}.log &

        PID=$!
        wait $PID
    done

}

main
