#!/usr/bin/env bash
set -euo pipefail
set -x

ROOT=/home/ubuntu
cd $ROOT

PID_FILE=${ROOT}/pid
STATE_FILE=${ROOT}/state
LOG_DIR=${ROOT}/logs
mkdir -p ${LOG_DIR}

export_model(){
    if [ ! -r "/tmp/inception-export" ]; then
        echo "exporting inception model"

        cd ${ROOT}/serving
        ${ROOT}/example/inception_saved_model/inception_saved_model --checkpoint_dir=inception-v3 --output_dir=/tmp/inception-export
    fi
}


start() {
    if [ ! -f ${STATE_FILE} ]; then
      touch ${STATE_FILE}
    fi

    if [[ `cat ${STATE_FILE}` == "1" ]]; then
        echo "tf model server has started! "
        exit 1
    fi


    clean_logs
    mkdir ${LOG_DIR}

    export_model

    /usr/local/bin/tensorflow_model_server --port=9000 --model_name=inception --model_base_path=/tmp/inception-export/ > ~/logs/server.log 2>&1 &

    PID=$!
    echo $PID > ${PID_FILE}

    echo "1" > ${STATE_FILE}
}

stop() {
    if [[ ! -f ${STATE_FILE} ]]; then
        touch ${STATE_FILE}
    fi

    if [[ `cat ${STATE_FILE}` != "0" ]]; then
        for PID in `cat ${PID_FILE}`; do
            kill ${PID} || echo "${PID} does not exist."  # avoid non-zero return code
        done
        rm ${PID_FILE}
        echo "0" > ${STATE_FILE}
    else
        echo "tf model server not running!"
    fi
}

clean_logs() {
    if [ -d ${LOG_DIR} ]; then
        rm -rf ${LOG_DIR}
    fi
}


if [[ "$#" == 0 ]]; then
    echo "Usage: $0 start|stop|restart|clean"
    exit 1
else
    case $1 in
        start)                  start
                                ;;
        stop)                   stop
                                ;;
        restart)                stop
                                start
                                ;;
        clean )                 clean_logs
                                ;;
        * )                     echo "Usage: $0 start|stop|restart|clean"
    esac
fi

