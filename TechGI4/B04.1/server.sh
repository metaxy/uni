gcc -lnsl -lresolv hashServer.c -o hashServer

### toplogy (port,id)
# (3000, 25) -> (3001, 50) -> (3002, 150) -> (3003,250)
killall hashServer
./hashServer 3000 25 127.0.0.1 3003 250 127.0.0.1 3001 50 &
./hashServer 3001 50 127.0.0.1 3000 25 127.0.0.1 3002 150 &
./hashServer 3002 150 127.0.0.1 3001 50 127.0.0.1 3003 250 &
./hashServer 3003 250 127.0.0.1 3002 150 127.0.0.1 3000 25 &
