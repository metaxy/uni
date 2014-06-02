
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

int packData(unsigned char *buffer, char command[], uint16_t a, uint16_t b, int ip, short port) {
    buffer[0] = command[0];
    buffer[1] = command[1];
    buffer[2] = command[2];
    buffer[3] = command[3];
    buffer[4] = htons(a) & 0xFF;
    buffer[5] = htons(a) >> 8;
    
    buffer[6] = htons(b) & 0xFF;
    buffer[7] = htons(b) >> 8;
    
    buffer[8] = htonl(ip) & 0xFF;
    buffer[9] = (htonl(ip) >> 8) & 0xFF;
    buffer[10] = (htonl(ip) >> 16) & 0xFF;
    buffer[11] = htonl(ip) >> 24;
    
    buffer[12] = htons(port) & 0xFF;
    buffer[13] = htons(port) >> 8;
    //printf("port = %i\n",port);
    printBuffer(buffer,14);
}
