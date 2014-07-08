#include "GoBackNMessageStruct.h"

#ifdef __cplusplus
#define INLINE inline
#else
#define INLINE
#endif

INLINE GoBackNMessageStruct* allocateGoBackNMessageStruct(size_t dataSize) {
    size_t size = sizeof(GoBackNMessageStruct)+((dataSize+3)& ~0x3);

    GoBackNMessageStruct* msg = (GoBackNMessageStruct*)malloc(size);
    memset(msg, 0, size);
    return msg;
}

INLINE void freeGoBackNMessageStruct(GoBackNMessageStruct* msg) {
    free(msg);
}
