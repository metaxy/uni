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

void unpackData(unsigned char *buffer, unsigned int *a, unsigned int *b)
{
    *a = (buffer[0]<<8) | buffer[1];
    *b = (buffer[2]<<8) | buffer[3];
}

int packData(unsigned char *buffer, unsigned int a, unsigned int b) 
{
    buffer[0] = htons(a) & 0xFF;
    buffer[1] = htons(a) >> 8;
    
    buffer[2] = htons(b) & 0xFF;
    buffer[3] = htons(b) >> 8;
}

int ggt (int a, int b)
{
    if (b==0)
        return a;
    else
        return ggt(b, a%b);
}
int main(int argc, char *argv[])
{
    int sockfd;
    int serverPort;
    int new_fd;
    struct sockaddr_in serv_addr, cli_addr;
    int clilen;
    printf("UDP Server\n\n");
    
    if (argc != 2) {
        fprintf(stderr,"Usage: udpServer serverPort \n");
        exit(1);
    }
        
    serverPort = atoi(argv[1]);

    printf("port = %i\n", serverPort);

    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(serverPort);

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if(bind(sockfd, (struct sockaddr*) &serv_addr, sizeof(serv_addr)) < 0)
    {
        printf("could not bind\n");
    }

    listen(sockfd, 10);

    
    while(1) {
		clilen = sizeof cli_addr;
        unsigned char buffer[4];

        int size = recvfrom(sockfd, buffer, sizeof(char)*4,0,(struct sockaddr *) &cli_addr, &clilen);
		if(size > 0) {
            unsigned int a,b;
            
			printf("received: %x %x %x %x\n", buffer[0],buffer[1],buffer[2],buffer[3]);
            //unpackData(buffer, &a, &b);
            printf("ggt of %i %i is %i\n", a ,b, ggt(a,b));
			//packData(buffer, ggt(a,b), 0);
			printf("client port %i\n", cli_addr.sin_port);
			printf("client addr %i\n", cli_addr.sin_addr.s_addr);
			int ret = sendto(sockfd, buffer, 4, 0, (struct sockaddr *) &cli_addr, sizeof(clilen));
			printf("sento = %i\n", ret);
        }
    }
    close(sockfd);
    return 0;
}

