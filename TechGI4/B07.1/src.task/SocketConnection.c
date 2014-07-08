#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <string.h>

#include "SocketConnection.h"
#include "GoBackNMessageStruct.h"

int connectToServer(uint16_t localPort, const char* serverName, uint16_t serverPort) {
    int s = socket(PF_INET, SOCK_STREAM, 0);
    int x = 1;

    if (s < 0) {
        perror("socket");
        exit(1);
    }

    if (setsockopt(s, SOL_TCP, TCP_NODELAY, &x, sizeof(int)) < 0) {
        perror("setsockopt(TCP_NODELAY)");
        exit(1);
    }
    if (setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &x, sizeof(int)) < 0) {
        perror("setsockopt(SO_REUSEADDR)");
        exit(1);
    }

    x = sizeof(GoBackNMessageStruct);

    if (setsockopt(s, SOL_SOCKET, SO_SNDBUF, &x, sizeof(int)) < 0) {
        perror("setsockopt(SO_SNDBUF)");
        exit(1);
    }

    struct sockaddr_in localAddr;
    localAddr.sin_family = AF_INET;
    localAddr.sin_port = htons(localPort);
    localAddr.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(s, (struct sockaddr *)&localAddr, sizeof(localAddr)) < 0) {
        perror("bind");
        exit(1);
    }
    
    struct hostent* remoteEntity = gethostbyname(serverName);
    if (remoteEntity == NULL) {
        fprintf(stderr,"gethostbyname: Could not resolve server name\n");
        exit(1);
    }
    
    struct sockaddr_in remoteAddr;
    remoteAddr.sin_family = AF_INET;
    remoteAddr.sin_port = htons(serverPort);
    memcpy(&remoteAddr.sin_addr, remoteEntity->h_addr_list[0], sizeof(remoteAddr.sin_addr));
    if (connect(s, (struct sockaddr *)&remoteAddr, sizeof(remoteAddr)) < 0) {
        perror("connect");
        exit(1);
    }

    return s;
}
