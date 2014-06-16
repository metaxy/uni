gcc -lnsl -lresolv hashServer.c -lrt -o hashServer || exit 1
./hashServer 3000
