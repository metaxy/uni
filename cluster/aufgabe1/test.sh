#! /bin/sh
export LC_NUMERIC="en_US.UTF-8"
MYHOME="/home/paul/uni/cluster/aufgabe1"
TESTHOME="/home/paul/Cloud/studium/Cluster/programs/material"
NAME="simple"
BIN_FILE="$MYHOME/dist/build/$NAME/$NAME"

now=$(date +"%m_%d_%Y %H:%M:%S")
LOG_FILE="$MYHOME/results/$now.results"
exec 3>&1 1>>${LOG_FILE} 2>&1

cd $MYHOME
cabal build
cd $TESTHOME
./ce-solver-test "$BIN_FILE" | tee /dev/fd/3
