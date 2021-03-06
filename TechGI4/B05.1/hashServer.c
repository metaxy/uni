/*
 * ############################################################################
 * # #
 * # Copyright TU-Berlin, 2011-2014 #
 * # Die Weitergabe, Veröffentlichung etc. auch in Teilen ist nicht gestattet #
 * # #
 * ############################################################################
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
#include <time.h>
#include "common.h"

int main(int argc, char *argv[]){
    int sockfd;
    int serverPort;
    struct sockaddr_in serv_addr, cli_addr;
    int clilen;
    printf("UDP Server\n\n");
    if (argc != 2) {
        fprintf(stderr,"Usage: hashServer serverPort \n");
        exit(1);
    }
    
    serverPort = atoi(argv[1]);
    
    printf("port = %i\n", serverPort);
    
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(serverPort);
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if(bind(sockfd, (struct sockaddr*) &serv_addr, sizeof(serv_addr)) < 0) {
        printf("could not bind\n");
    }
    
    listen(sockfd, 1);
    sec s2,s3;
    nsec n2,n3;
    struct timespec begin, end;
    while(1) {
        clilen = sizeof cli_addr;
        unsigned char buffer[8];
        
        int size = recvfrom(sockfd, buffer, PACKLEN, 0,(struct sockaddr *) &cli_addr, &clilen);
        if(size > 0) {
            clock_gettime(CLOCK_REALTIME, &begin);
            s2 = begin.tv_sec;
            n2 = begin.tv_nsec;
            char command[4];
            unpackData(buffer, command, NULL, NULL, NULL, NULL);
            //todo: command == "REQ"
            if(command[0] == 'R'){
                clock_gettime(CLOCK_REALTIME, &end);
                s3 = end.tv_sec;
                n3 = end.tv_nsec;
                packData(buffer, "RES", s2, n2, s3, n3);
            }
            
            sendto(sockfd, buffer, PACKLEN, 0, (struct sockaddr *) &cli_addr, clilen);
        }
    }
    close(sockfd);
    return 0;
}

