#! /bin/sh
export LC_NUMERIC="en_US.UTF-8"
MYHOME="/home/paul/uni/cluster/aufgabe1"
TESTHOME="/home/paul/Cloud/studium/Cluster/programs/material"

names=(t3)
cd $MYHOME
cabal build
cd $TESTHOME

for NAME in ${names[@]}; do
    now=$(date +"%m_%d_%Y %H:%M:%S")
    LOG_FILE="$MYHOME/results/$now - $NAME.results"
    BIN_FILE="$MYHOME/dist/build/$NAME/$NAME"
    echo "Testing $NAME\n" > $LOG_FILE
    ./ce-solver-test "$BIN_FILE" >> $LOG_FILE
done
