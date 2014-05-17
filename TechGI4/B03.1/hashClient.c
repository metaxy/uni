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
int sockfd;
struct sockaddr_in their_addr; // connector's address information

void unpackData(unsigned char *buffer, char *command, unsigned int *a, unsigned int *b)
{
    printf("unpack %s\n", buffer);
    command[0] = buffer[0];
    command[1] = buffer[1];
    command[2] = buffer[2];
    command[3] = buffer[3];
    if(a != NULL) {
        *a = (buffer[4]<<8) | buffer[5];
    }
    if(b != NULL) {
        *b = (buffer[6]<<8) | buffer[7];
    }
}

int packData(unsigned char *buffer, char command[], unsigned int a, unsigned int b) 
{
    buffer[0] = command[0];
    buffer[1] = command[1];
    buffer[2] = command[2];
    buffer[3] = command[3];
    buffer[4] = htons(a) & 0xFF;
    buffer[5] = htons(a) >> 8;
    
    buffer[6] = htons(b) & 0xFF;
    buffer[7] = htons(b) >> 8;
}

int main(int argc, char *argv[])
{
    struct hostent *he;
    int numbytes;
    int serverPort;
    int a = 0;
    int b = 0;

    printf("Hash client\n\n");
    
    if (argc != 3) {
        fprintf(stderr,"Usage: hashClient serverName serverPort\n");
        exit(1);
    }
    
    serverPort = atoi(argv[2]);

    //Resolv hostname to IP Address
    if ((he=gethostbyname(argv[1])) == NULL) {  // get the host info
        herror("gethostbyname");
        exit(1);
    }
    
    //socket erstellen
    sockfd = socket(PF_INET, SOCK_DGRAM, 0);
	if(sockfd > 0) {
		printf("socket created\n");
	}	
    //setup transport address
    their_addr.sin_family = AF_INET;     
    their_addr.sin_port = htons(serverPort);
    their_addr.sin_addr = *((struct in_addr *)he->h_addr);
    memset(their_addr.sin_zero, '\0', sizeof their_addr.sin_zero);
    set(12,12);
    close(sockfd);

    return 0;
}

int send_data(char command[], int key, int val)
{
    printf("send_data %s %i %i\n", command, key, val);
    unsigned char buffer[8];
    packData(buffer, command, key, val);
    printf("buffer = %s\n", buffer);
    
    if(sendto(sockfd, buffer, sizeof(char)*8, 0, (struct sockaddr *)&their_addr, sizeof(struct sockaddr_in)) < 0) {
        printf("could not send\n");
    }
    perror ("The following error occurred");
}

int receive(char *command, int *key, int *val)
{
    unsigned char buffer[8];
    recvfrom(sockfd, buffer, sizeof(char)*8, 0, NULL, NULL);
    unpackData(buffer, command, key, val);
}

int set(int key, int val)
{
    send_data("SET", key, val);
    char ret[4];
    int a,b;
    receive(ret, NULL, NULL);
    if(ret[0] == 'O') {
        return 0;
    }
    return 1;
}

int get(int key)
{
    send_data("GET", key, 0);
    int val;
    char ret[4];
    receive(ret, NULL, &val);
    if(ret[0] == 'V') {
        return val;
    } else {
        printf("key not found\n");
        return 0;
    }   
}

int del(int key)
{
    send_data("DEL", key, 0);
    char ret[4];
    receive(ret, NULL, NULL);
    if(ret[0] == 'O') {
        return 0;
    }
    return 1;
}

