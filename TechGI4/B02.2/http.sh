gcc -lnsl -lresolv httpClient.c -o httpClient
./httpClient localhost 1024
./httpClient www.tu-berlin.de 80
./httpClient www.tu-berlin.de 80

