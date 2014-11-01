#!/bin/bash

# forked by http://goo.gl/3AEtfX

EXTERNAL="/ghost-external"
GHOST="/ghost"

DB=${GHOST_DB:-ghost}

ID=${DB_ID:-admin}
PASS=$DB_PASS

HOST=${DB_HOST:-172.17.42.1}
PORT=${DB_PORT:-3306}

cd "$GHOST"

if [[ -f "$GHOST/config.example.js" ]]
then
    echo 'start the setup...'

    RET=1
    if [ -n $HOST ]
    then
        echo "trying to create database..."
        mysql -u$ID -p$PASS -e "CREATE DATABASE IF NOT EXISTS $DB CHARACTER SET utf8" -h$HOST -P$PORT;
        RET=$?
        if [ $RET -ne 0 ]
        then
            echo 'database create fail...'
            exit
        else
            echo 'database create success...'
        fi
    fi

    if [[ -d "$EXTERNAL" ]]
    then
        echo "/ghost-external is exist..."
        cd "$GHOST"

        rm -rf "config.example.js"
        if [[ -d "$EXTERNAL/content" ]]
        then
            rm -rf "content"
        else
            mv "content" "$EXTERNAL/content"
        fi

        ln -s "$EXTERNAL/content" "content"
        ln -s "$EXTERNAL/config.js" "config.js"
    else
        echo '/ghost-external is not exist...'
    fi
fi

RET=1
while [[ RET -ne 0 ]]
do
    echo "Waiting for confirmation of database... now is $(date)"
    sleep 5
    mysql -u$ID -p$PASS -h$HOST -P$PORT -e "status" > /dev/null
    echo $RET
done

npm start --production
