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
#include <stdint.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

int sockfd;
struct sockaddr_in their_addr;
uint32_t m_ip;
uint16_t m_port;

void printBuffer(unsigned char *buffer, int size)
{
    int i;
    for(i = 0; i< size; i++) {
        printf("buffer[%i]=%x\n",i, buffer[i]);
    }
}
void unpackData(unsigned char *buffer, char *command, uint16_t *a, uint16_t *b, uint32_t *ip, uint16_t *port) {
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
    if(ip != NULL) {
        *ip = (buffer[9]<<24) | (buffer[9]<<16) | (buffer[9]<<8) | buffer[11];
    }
    if(port != NULL) {
        *port = (buffer[12]<<8) | buffer[13];
    }
}

int packData(unsigned char *buffer, char command[], uint16_t a, uint16_t b) {
    buffer[0] = command[0];
    buffer[1] = command[1];
    buffer[2] = command[2];
    buffer[3] = command[3];
    buffer[4] = htons(a) & 0xFF;
    buffer[5] = htons(a) >> 8;
    
    buffer[6] = htons(b) & 0xFF;
    buffer[7] = htons(b) >> 8;
    
    buffer[8] = htonl(m_ip) & 0xFF;
    buffer[9] = (htonl(m_ip) >> 8) & 0xFF;
    buffer[10] = (htonl(m_ip) >> 16) & 0xFF;
    buffer[11] = htonl(m_ip) >> 24;
    
    buffer[12] = htons(m_port) & 0xFF;
    buffer[13] = htons(m_port) >> 8;
    //printf("port = %i\n",port);
    printBuffer(buffer,14);
}

int send_data(char command[], uint16_t key, uint16_t val)
{
    printf("send_data %s %i %i\n", command, key, val);
    unsigned char buffer[14];
    packData(buffer, command, key, val);
    if(sendto(sockfd, buffer, sizeof(char)*8, 0, (struct sockaddr *)&their_addr, sizeof(struct sockaddr_in)) < 0) {
        printf("could not send\n");
    }
}

int receive(char *command, uint16_t *key, uint16_t *val)
{
    unsigned char buffer[14];
    recvfrom(sockfd, buffer, sizeof(char)*8, 0, NULL, NULL);
    unpackData(buffer, command, key, val, NULL, NULL);
}

int set(uint16_t key, uint16_t val)
{
    send_data("SET", key, val);
    char ret[4];
    receive(ret, NULL, NULL);
    if(ret[0] == 'O') {
        return 0;
    }
    return -2;
}

int get(uint16_t key)
{
    send_data("GET", key, 0);
    uint16_t val;
    char ret[4];
    receive(ret, NULL, &val);
    if(ret[0] == 'V') {
        return val;
    } else {
        printf("key not found\n");
        return -1;
    }   
}

int del(uint16_t key)
{
    send_data("DEL", key, 0);
    char ret[4];
    receive(ret, NULL, NULL);
    if(ret[0] == 'O') {
        return 0;
    }
    return 1;
}

int main(int argc, char *argv[])
{
    struct hostent *he;
    int numbytes;
    printf("Hash client\n\n");
    
    if (argc != 4) {
        fprintf(stderr,"Usage: hashClient serverName serverPort myIP\n");
        exit(1);
    }
    
    m_port = atoi(argv[2]);

   
    //Resolv my hostname to IP Address
    if ((he=gethostbyname(argv[3])) == NULL) {  // get the host info
        herror("gethostbyname");
        exit(1);
    }
    //m_ip = *((struct in_addr *)he->h_addr);
    
    //Resolv hostname to IP Address
    if ((he=gethostbyname(argv[1])) == NULL) {  // get the host info
        herror("gethostbyname");
        exit(1);
    }
    
    //socket erstellen
    sockfd = socket(PF_INET, SOCK_DGRAM, 0);
    //setup transport address
    their_addr.sin_family = AF_INET;     
    their_addr.sin_port = htons(m_port);
    their_addr.sin_addr = *((struct in_addr *)he->h_addr);
    
    memset(their_addr.sin_zero, '\0', sizeof their_addr.sin_zero);
    
    srand(time(NULL));
    int i;
    printf("\n");
    int a[25];
    for(i = 0; i< 2; i++) {
        uint16_t key = (uint16_t)rand() ;
        a[i] = key;
        printf("set data[%i] = %i\n", key, key+1);
        set(key, key+1);
    }
    /*for(i = 0; i< 25; i++) {
        printf("\n");
        printf("data for %i is %i\n\n", a[i], get(a[i]));
    }
    for(i = 0; i< 25; i++) {
        del(a[i]);
    }
    for(i = 0; i< 25; i++) {
        printf("data for %i is %i (should be -1)\n", a[i], get(a[i]));
    }*/
    close(sockfd);

    return 0;
}

