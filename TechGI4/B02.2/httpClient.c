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
#define MAX_RESP_LENGTH 1024*8
int main(int argc, char *argv[])
{
    int sockfd;
    struct sockaddr_in their_addr; // connector's address information
    struct hostent *he;
    int numbytes;
    int serverPort;
    unsigned int a = 0;
    unsigned int b = 0;
    
    printf("HTTP Client\n\n");
    
    serverPort = atoi(argv[2]);
    
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
    //send the data in buffer over sockfd
    char req[1024];
    int size = snprintf(req, 1024, "GET / HTTP/1.1\nHOST: %s\n\n", argv[1]);
    send(sockfd, req, size, 0);
    
    char buffer[MAX_RESP_LENGTH];
    
    while(recv(sockfd, buffer, MAX_RESP_LENGTH, 0) > 0)
    {
        printf("%s", buffer);
        memset(buffer,'\0',MAX_RESP_LENGTH);
    }
    
    close(sockfd);
    return 0;
}
