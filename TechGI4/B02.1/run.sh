gcc -lnsl -lresolv tcpClient.c -o tcpClient
./tcpClient 127.0.0.1 3000 522 34

gcc -lnsl -lresolv udpClient.c -o udpClient
./udpClient 127.0.0.1 3001 522 34
