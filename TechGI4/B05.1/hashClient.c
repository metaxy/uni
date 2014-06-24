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
#include <stdint.h>
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
    struct hostent *he;
    int sockfd;
    struct sockaddr_in their_addr;
    int numbytes;
    int serverPort;
    struct timespec requestStart, requestEnd, offset, delay;
    sec s2,s3;
    nsec n2,n3;
    printf("Hash client\n\n");
    
    if (argc != 3) {
        fprintf(stderr,"Usage: hashClient serverName serverPort\n");
        exit(1);
    }
    
    serverPort = atoi(argv[2]);
    
    if ((he=gethostbyname(argv[1])) == NULL) { // get the host info
        herror("gethostbyname");
        exit(1);
    }
    
    sockfd = socket(PF_INET, SOCK_DGRAM, 0);
    their_addr.sin_family = AF_INET;
    their_addr.sin_port = htons(serverPort);
    their_addr.sin_addr = *((struct in_addr *)he->h_addr);
    memset(their_addr.sin_zero, '\0', sizeof their_addr.sin_zero);
    char buffer[PACKLEN];
    char command[4];
    packData(buffer, "REQ", 0,0,0,0);
    clock_gettime(CLOCK_REALTIME, &requestStart);//t1
    sendto(sockfd, buffer, PACKLEN, 0, (struct sockaddr *)&their_addr, sizeof(struct sockaddr_in));
    recvfrom(sockfd, buffer, PACKLEN, 0, NULL, NULL);
    clock_gettime(CLOCK_REALTIME, &requestEnd);//t4
    unpackData(buffer, command, &s2,&n2,&s3,&n3);
    
    //offset = 0,5 *((T2-T1)+(T3-T4));
    offset.tv_sec = 0.5*((s2-requestStart.tv_sec)+(s3-requestEnd.tv_sec));
    offset.tv_nsec = 0.5*((n2-requestStart.tv_nsec)+(n3-requestEnd.tv_nsec));
    //delay = (T4-T1)-(T3-T2)
    delay.tv_sec = (requestEnd.tv_sec-requestStart.tv_sec)-(s3-s2);
    delay.tv_nsec = (requestEnd.tv_nsec-requestStart.tv_nsec)-(n3-n2);
    
    printf("Der Offset betraegt %ld sec", offset.tv_sec);	
    printf("und %lu ns\n", offset.tv_nsec);
    
    printf("Der Delay betraegt %ld sec", delay.tv_sec);
    printf("und %lu ns\n", delay.tv_nsec);
    
    return 0;
}
