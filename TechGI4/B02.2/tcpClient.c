/*
 * ############################################################################
 * #                                                                          #
 * # Copyright TU-Berlin, 2011-2014                                           #
 * # Die Weitergabe, Veröffentlichung etc. auch in Teilen ist nicht gestattet #
 * #                                                                          #
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

#define MAX_BUFFER_LENGTH 100
int main(int argc, char *argv[])
{
    tcp(argv[1],atoi(argv[2]));
    udp(argv[1],atoi(argv[3]));
    return 0;
}

int tcp(char *hostname, int serverPort)
{
    int sockfd;
    struct sockaddr_in their_addr; // connector's address information
    struct hostent *he;
    //Resolv hostname to IP Address
    if ((he=gethostbyname(hostname)) == NULL) {  // get the host info
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
    struct timespec requestStart, requestEnd;
    clock_gettime(CLOCK_MONOTONIC, &requestStart);
    
    //send the data in buffer over sockfd
    send(sockfd, buffer, sizeof(unsigned char)*4, 0);
    clock_gettime(CLOCK_MONOTONIC, &requestEnd);
    
    long nsecs =requestEnd.tv_nsec - requestStart.tv_nsec;
    
    printf("it took for tcp %lu ns\n",nsecs);
    close(sockfd);
}
int udp(char *hostname, int serverPort)
{
    int sockfd;
    struct sockaddr_in their_addr; // connector's address information
    struct hostent *he;
    //Resolv hostname to IP Address
    if ((he=gethostbyname(hostname)) == NULL) {  // get the host info
        herror("gethostbyname");
        exit(1);
    }
    //create tcp socket
    sockfd = socket(PF_INET, SOCK_DGRAM, 0);
    
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
    struct timespec requestStart, requestEnd;
    clock_gettime(CLOCK_MONOTONIC, &requestStart);
    
    //send the data in buffer over sockfd
    send(sockfd, buffer, sizeof(unsigned char)*4, 0);
    clock_gettime(CLOCK_MONOTONIC, &requestEnd);
    
    long nsecs =requestEnd.tv_nsec - requestStart.tv_nsec;
    
    printf("it took for udp %lu ns\n",nsecs);
    close(sockfd);
}