#ifndef SOCKET_CONNECTION_H_
#define SOCKET_CONNECTION_H_

#include <stdint.h>
#include <netinet/tcp.h>

#ifndef SOL_TCP
#define SOL_TCP 6
#endif

int connectToServer(uint16_t localPort, const char* serverName, uint16_t serverPort);

#endif /* SOCKET_CONNECTION_H_ */
    
