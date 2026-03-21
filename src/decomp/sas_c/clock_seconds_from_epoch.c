#include <exec/types.h>

extern void *Global_REF_UTILITY_LIBRARY;
#pragma libcall Global_REF_UTILITY_LIBRARY Date2Amiga 7e 801
extern LONG Date2Amiga(void *clockData);

LONG CLOCK_SecondsFromEpoch(void *clockData)
{
    return Date2Amiga(clockData);
}
