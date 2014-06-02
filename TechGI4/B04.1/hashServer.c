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
#include "common.h"
struct entry {
    uint16_t key;
    uint16_t val;
    uint16_t valid;
};
struct entry table[256];
/*****************/
struct node {
    int ip;
    short port;
    struct sockaddr_in serv_addr;
    int id;
}
struct node nodes[3];
/******************/

int getPos(uint16_t key)
{
    int pos = key & 0xFF;
    while(1) {
        if(table[pos].valid == 1 && table[pos].key == key) {
            printf("getPos return \n",pos);
            return pos;
        }
        pos = (pos + 1) % 256;
        if(pos == (key & 0xFF)) break;
    }
    printf("getPos not found\n");
    return -1;
}
struct entry* get(uint16_t key)
{
    printf("get %i\n", key);
    int pos = getPos(key);
    if(pos >= 0)  {
        return &table[pos];
    }
    return NULL;
}

void set(uint16_t key, uint16_t val)
{
    printf("set %i %i\n", key, val);
    int pos = key & 0xFF;
    while(1) {
        if(table[pos].valid == 0) {
            break;
        }
        pos = (pos + 1) % 256;
        if(pos == (key & 0xFF)) return;

    }
    table[pos].valid = 1;
    table[pos].key = key;
    table[pos].val = val;
}

void del(uint16_t key)
{
    printf("del %i\n", key);
    int pos = getPos(key);
    if(pos >= 0)  {
        table[pos].valid = 0;
    }
}

int getNode(uint16_t key)
{
    if(key <= nodes[0].id) return 0;
    if(key <= nodes[1].id) return 1;
    return 2;
}

int main(int argc, char *argv[])
{
    int sockfd;
    int serverPort;
    struct sockaddr_in serv_addr, cli_addr;
    int clilen;
    printf("UDP Server\n\n");
    int i;
    for(i = 0; i< 256; i++) {
        table[i].key = 0;
        table[i].val = 0;
        table[i].valid = 0;
    }
    if (argc != 9) {
        fprintf(stderr,"Usage: hashServer serverPort serverID prevIP prevPort prevID nextIP nextPort nextID \n");
        exit(1);
    }
    nodes[1].id = atoi(argv[2]);
    nodes[1].port = atoi(argv[1]);
    serverPort = atoi(argv[1]);
    
    nodes[0].ip = atoi(argv[3]);
    nodes[0].port = atoi(argv[4]);
    nodes[0].id = atoi(argv[5]);
    
    nodes[2].ip = atoi(argv[6]);
    nodes[2].port = atoi(argv[7]);
    nodes[2].id = atoi(argv[8]);
    
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

    listen(sockfd, 1);
    
    while(1) {
		clilen = sizeof cli_addr;
        unsigned char buffer[8];

        int size = recvfrom(sockfd, buffer, 8, 0,(struct sockaddr *) &cli_addr, &clilen);
		if(size > 0) {
            printf("received len  %i\n", size);
            uint16_t key,value;
            int ip;
            short port;
            char command[4];
            unpackData(buffer, command, &key, &value, &ip, &port);
            int n = getNode(key);
            if(n != 1) {
                //send to right node
                break;
            }
    
            if(command[0] == 'S') {
                set(key, value);
                packData(buffer, "OK!", 0, 0);
            } else if(command[0] == 'G') {
                struct entry *ret = get(key);
                if(ret == 0) {
                    packData(buffer, "NOF", 0, 0);
                } else {
                    packData(buffer, "VAL", ret->key, ret->val);
                }
            } else if(command[0] == 'D') {
                del(key);
                packData(buffer, "OK!", 0, 0);
            }
			sendto(sockfd, buffer, 8, 0, (struct sockaddr *) &cli_addr, clilen);
        }
    }
    close(sockfd);
    return 0;
}





