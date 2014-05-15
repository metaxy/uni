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

void unpackData(unsigned char *buffer, char command[], unsigned int *a, unsigned int *b)
{
    printf("%s", buffer);
    *command = *buffer;
    *a = (buffer[4]<<8) | buffer[5];
    *b = (buffer[6]<<8) | buffer[7];
}

int packData(unsigned char *buffer, char *command, unsigned int a, unsigned int b) 
{
    *buffer = *command;
    buffer[4] = htons(a) & 0xFF;
    buffer[5] = htons(a) >> 8;
    
    buffer[6] = htons(b) & 0xFF;
    buffer[7] = htons(b) >> 8;
}

int main(int argc, char *argv[])
{
    int sockfd;
    int serverPort;
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
        unsigned char buffer[8];

        int size = recvfrom(sockfd, buffer, sizeof(char)*8, 0,(struct sockaddr *) &cli_addr, &clilen);
        perror ("The following error occurred");
		if(size > 0) {
            printf("received len  %i", size);
            unsigned int key,value;
            char command[4];
            unpackData(buffer, command, &key, &value);
            
            /*
			sendto(sockfd, buffer, packSize,0, (struct sockaddr *) &cli_addr, clilen);*/
        }
    }
    close(sockfd);
    return 0;
}

