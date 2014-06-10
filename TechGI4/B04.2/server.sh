gcc -lnsl -lresolv hashServer.c -o hashServer || exit 1
killall hashServer
S0="127.0.0.1 3000 0"
S1="127.0.0.1 3001 16000"
S2="127.0.0.1 3002 32000"
S3="127.0.0.1 3003 49000"

./hashServer $S0 $S3 $S1 &
./hashServer $S1 $S0 $S2 &
./hashServer $S2 $S1 $S3 &
./hashServer $S3 $S2 $S0 &
