#define PACKLEN 20
typedef uint32_t sec;
typedef uint32_t nsec;

void printBuffer(unsigned char *buffer, int size)
{
    int i;
    for(i = 0; i< size; i++) {
        printf("buffer[%i]=%x\n",i, buffer[i]);
    }
}
void fromBuf(uint32_t *value, unsigned char *buffer, int start)
{
    if(value != NULL) {
        *value = (buffer[start+3]<<24) | (buffer[start+2]<<16) | (buffer[start+1]<<8) | buffer[start];
    }
}

void toBuf(uint32_t value, unsigned char *buffer, int start) {
    buffer[start] = value & 0xFF;
    buffer[start+1] = (value >> 8) & 0xFF;
    buffer[start+2] = (value >> 16) & 0xFF;
    buffer[start+3] = value >> 24;
}

void unpackData(unsigned char *buffer, char *command, sec *s2, nsec *n2, sec *s3, nsec *n3) {
    command[0] = buffer[0];
    command[1] = buffer[1];
    command[2] = buffer[2];
    command[3] = buffer[3];
    fromBuf(s2,buffer,4);
    fromBuf(n2,buffer,8);
    fromBuf(s3,buffer,12);
    fromBuf(n3,buffer,16);
}

int packData(unsigned char *buffer, char command[], sec s2, nsec n2, sec s3, nsec n3) {
    buffer[0] = command[0];
    buffer[1] = command[1];
    buffer[2] = command[2];
    buffer[3] = command[3];
    
    toBuf(s2,buffer,4);
    toBuf(n2,buffer,8);
    toBuf(s3,buffer,12);
    toBuf(n3,buffer,16);
}
