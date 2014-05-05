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
	sockfd = socket(PF_INET, SOCK_STREAM, 0);


    //setup transport address
    their_addr.sin_family = AF_INET;     
    their_addr.sin_port = htons(serverPort);
    their_addr.sin_addr = *((struct in_addr *)he->h_addr);
    memset(their_addr.sin_zero, '\0', sizeof their_addr.sin_zero);

	if(connect(sockfd, (struct sockaddr *)&their_addr, sizeof(struct sockaddr_in)) == -1) {
		printf("could not connect\n");
		exit(-1);
	}	
    unsigned char buffer[4];

    packData(&buffer, a, b);

	send(sockfd, buffer, sizeof(unsigned char)*4,0);
	close(sockfd);
    return 0;
}

int packData(unsigned char *buffer, unsigned int a, unsigned int b) {
    buffer[0] = 0;
    buffer[1] = a;
    buffer[2] = 0;
    buffer[3] = b;
}
