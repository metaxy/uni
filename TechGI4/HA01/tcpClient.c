/*
############################################################################
#                                                                          #
# Copyright TU-Berlin, 2011-2014                                           #
# Die Weitergabe, Veröffentlichung etc. auch in Teilen ist nicht gestattet #
#                                                                          #
############################################################################
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#define MAX_BUFFER_LENGTH 100

int main(int argc, char *argv[])
{
    int sockfd;
    struct sockaddr_in their_addr; // connector's address information
    struct hostent *he;
    int numbytes;
    int serverPort;
    int a = 0;
    int b = 0;

    printf("TCP client example\n\n");
    
    if (argc != 5) {
        fprintf(stderr,"Usage: tcpClient serverName serverPort int1 int2\n");
        exit(1);
    }
    
    serverPort = atoi(argv[2]);
    a = atoi(argv[3]);
    b = atoi(argv[4]);    

    //Resolv hostname to IP Address
    if ((he=gethostbyname(argv[1])) == NULL) {  // get the host info
        herror("gethostbyname");
        exit(1);
    }
    //create tcp socket
	sockfd = socket(PF_INET, SOCK_STREAM, 0);


    //setup transport address
    their_addr.sin_family = AF_INET;     
    their_addr.sin_port = htons(serverPort);
    their_addr.sin_addr = *((struct in_addr *)he->h_addr);
    memset(their_addr.sin_zero, '\0', sizeof their_addr.sin_zero);

    //coneckt to server, using sockfd
	if(connect(sockfd, (struct sockaddr *)&their_addr, sizeof(struct sockaddr_in)) == -1) {
		printf("could not connect\n");
		exit(-1);
	}	
    unsigned char buffer[4];

    //convert a and b to network byte order
    packData(&buffer, htons(a), htons(b));

    //send the data in buffer over sockfd
	send(sockfd, buffer, sizeof(unsigned char)*4, 0);
    
	close(sockfd);
    return 0;
}

int packData(unsigned char *buffer, unsigned int a, unsigned int b) 
{
    buffer[0] = a & 0xFF;
    buffer[1] = a >> 8;
    buffer[2] = b & 0xFF;
    buffer[3] = b >> 8;
}
