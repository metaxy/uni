gcc -lnsl -lresolv hashServer.c -o hashServer || exit 1

./hashServer 3000
