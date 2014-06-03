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
struct entry table[TABLESIZE];
/*****************/
struct node {
    int ip;
    uint16_t port;
    struct sockaddr_in addr;
    int id, prev;
};
struct node nodes[3];
/******************/

void print_nodes()
{
    printf("%i <- %i -> %i\n", nodes[1].id, nodes[0].id, nodes[2].id);
}
int getPos(uint16_t key)
{
    int pos = key & LEN;
    while(1) {
        if(table[pos].valid == 1 && table[pos].key == key) {
            printf("getPos return \n",pos);
            return pos;
        }
        pos = (pos + 1) % TABLESIZE;
        if(pos == (key & LEN)) break;
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
    int pos = key & LEN;
    while(1) {
        if(table[pos].valid == 0) {
            break;
        }
        pos = (pos + 1) % TABLESIZE;
        if(pos == (key & LEN)) return;

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
    if(nodes[0].id < nodes[1].id) { //i am the last
        if(key > nodes[1].id || key <= nodes[0].id) return 0;
        if(key <= nodes[2].id) return 2;
        if(key <= nodes[1].id) return 1;
    } else {
        if(key <= nodes[1].id) return 1;
        if(key >= nodes[0].id) return 2;
        return 0;
    }
}
int createAddr(int node, char *ip, int port)
{
    nodes[node].addr.sin_family = AF_INET;     
    nodes[node].addr.sin_port = htons(port);
    inet_aton(ip, &nodes[node].addr.sin_addr);
}
int main(int argc, char *argv[])
{
    int sockfd;
    int serverPort;
    struct sockaddr_in serv_addr, cli_addr;
    int clilen;
    time_t start;
    time_t now;
    printf("UDP Server\n\n");
    int i;
    for(i = 0; i< TABLESIZE; i++) {
        table[i].key = 0;
        table[i].val = 0;
        table[i].valid = 0;
    }
    if (argc != 9) {
        fprintf(stderr,"Usage: hashServer serverPort serverID prevIP prevPort prevID nextIP nextPort nextID \n");
        exit(1);
    }
    nodes[0].port = atoi(argv[1]);
    serverPort = atoi(argv[1]);
    nodes[0].id = atoi(argv[2]);
    
    createAddr(1, argv[3], atoi(argv[4]));
    nodes[1].id = atoi(argv[5]);
   
    createAddr(2, argv[6], atoi(argv[7]));
    nodes[2].id = atoi(argv[8]);
    print_nodes();
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
    time(&start);
    while(1) {
        time(&now);
        double seconds;
        seconds = difftime(start, now);
        if(seconds > 15) {
            printf("builing fingertable\n");
            continue;
        }
        unsigned char buffer[PACKLEN];

        int size = recvfrom(sockfd, buffer, PACKLEN, 0,(struct sockaddr *) &cli_addr, &clilen);
        if(size > 0) {
            uint16_t key,value;
            uint32_t ip;
            uint16_t port;
            char command[4];
            unpackData(buffer, command, &key, &value, &ip, &port);
            int n = getNode(key);
            if(n != 0) {
                printf("[%i] send key=%i to node=%i\n",nodes[0].id, key, n);
                sendto(sockfd, buffer, PACKLEN, 0, (struct sockaddr *)&(nodes[n].addr), sizeof(struct sockaddr_in));
                continue;
            }
            printf("[%i] key=%i--- its mine!!\n",nodes[0].id, key);
            
            if(command[0] == 'S') {
                set(key, value);
                packData(buffer, "OK!", 0, 0,0,0);
            } else if(command[0] == 'G') {
                struct entry *ret = get(key);
                if(ret == 0) {
                    packData(buffer, "NOF", 0, 0,0,0);
                } else {
                    packData(buffer, "VAL", ret->key, ret->val,0,0);
                }
            } else if(command[0] == 'D') {
                del(key);
                packData(buffer, "OK!", 0, 0,0,0);
            }
            struct sockaddr_in cli;

            cli.sin_family = AF_INET;     
            cli.sin_port = htons(port);
            cli.sin_addr.s_addr = ip;
            //printf("port = %i, addr = %i\n", port, ip);
			sendto(sockfd, buffer, PACKLEN, 0, (struct sockaddr *) &cli, sizeof(struct sockaddr_in));
        }
    }
    close(sockfd);
    return 0;
}





