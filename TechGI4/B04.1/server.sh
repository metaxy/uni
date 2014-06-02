gcc -lnsl -lresolv hashServer.c -o hashServer
### toplogy (port,id)
# (3000, 100) -> (3001, 5000) -> (3002, 10000) -> (3003,15000)
killall hashServer
./hashServer 3000 100 127.0.0.1 3003 15000 127.0.0.1 3001 5000 &
./hashServer 3001 5000 127.0.0.1 3000 100 127.0.0.1 3002 10000 &
./hashServer 3002 10000 127.0.0.1 3001 5000 127.0.0.1 3003 15000 &
./hashServer 3003 15000 127.0.0.1 3002 10000 127.0.0.1 3000 100 &
