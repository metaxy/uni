#define RANGE sizeof(unint16_t)
#define TABLESIZE 256
#define LEN 0xFF
#define PACKLEN 14
#define FINGERTABLE_LEN 16
typedef uint16_t key;
typedef uint16_t value;

void printBuffer(unsigned char *buffer, int size)
{
    int i;
    for(i = 0; i< size; i++) {
        printf("buffer[%i]=%x\n",i, buffer[i]);
    }
}
void unpackData(unsigned char *buffer, char *command, key *a, value *b, uint32_t *ip, uint16_t *port) {
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
        *ip = (buffer[11]<<24) | (buffer[10]<<16) | (buffer[9]<<8) | buffer[8];
    }
    if(port != NULL) {
        *port = (buffer[12]<<8) | buffer[13];
    }
}

int packData(unsigned char *buffer, char command[], key a, value b, uint32_t ip, uint16_t port) {
    printf("packData command=%s, key=%i, data=%i, ip=%i, port=%i\n",command,a,b,ip,port);
    buffer[0] = command[0];
    buffer[1] = command[1];
    buffer[2] = command[2];
    buffer[3] = command[3];
    buffer[4] = htons(a) & 0xFF;
    buffer[5] = htons(a) >> 8;
    
    buffer[6] = htons(b) & 0xFF;
    buffer[7] = htons(b) >> 8;
    
    buffer[8] = ip & 0xFF;
    buffer[9] = (ip >> 8) & 0xFF;
    buffer[10] = (ip >> 16) & 0xFF;
    buffer[11] = ip >> 24;
    
    buffer[12] = htons(port) & 0xFF;
    buffer[13] = htons(port) >> 8;
   // printBuffer(buffer,PACKLEN);
}
//max(pos) == FINGERTABLE_LEN
key calc_fingertable_key(int pos)
{
    return 1 << pos;
}
int calc_fingertable_pos(key key)
{
   printf("[fingertable] calc_pos key = %i, pos = %i\n",key,__builtin_clz(key));
   return 32 - __builtin_clz(key);
}
