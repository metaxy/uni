#ifndef GOBACKN_MESSAGE_STRUCT_H
#define GOBACKN_MESSAGE_STRUCT_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct GoBackNMessageStruct {
    uint32_t size; // including these header fields
    int32_t  srcNode;
    int32_t  srcAppl;
    int32_t  destNode;
    int32_t  destAppl;
    int32_t  seqNo;
    int32_t  seqNoExpected;
    bool     hasErrors __attribute__ ((__aligned__ (4)));
    char     data[0] __attribute__ ((__aligned__ (4)));
} GoBackNMessageStruct;
// TODO: Get aligment stuff right __attribute__ ((__packed__)) or (__aligned__) or whatever

#ifdef __cplusplus
#include "GoBackNMessageStruct.c"
#else
GoBackNMessageStruct* allocateGoBackNMessageStruct(size_t dataSize);
void freeGoBackNMessageStruct(GoBackNMessageStruct* msg);
#endif

#ifdef __cplusplus
}
#endif

#endif /* GOBACKN_MESSAGE_STRUCT_H */
