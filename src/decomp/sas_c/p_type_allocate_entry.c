typedef signed long LONG;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

extern UBYTE Global_STR_P_TYPE_C_1;
extern UBYTE Global_STR_P_TYPE_C_2;
extern UBYTE Global_STR_P_TYPE_C_3;

extern void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(UBYTE *tagName, LONG line, LONG size, LONG flags);
extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(UBYTE *tagName, LONG line, void *ptr, LONG bytes);

void *P_TYPE_AllocateEntry(UBYTE typeByte, LONG length, UBYTE *dataPtr)
{
    UBYTE *entry;
    UBYTE *payload;
    LONG i;
    LONG srcLen;

    entry = (UBYTE *)0;
    if (length <= 0) {
        return (void *)0;
    }

    entry = (UBYTE *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(&Global_STR_P_TYPE_C_1, 47, 10, MEMF_PUBLIC + MEMF_CLEAR);
    if (entry == (UBYTE *)0) {
        return (void *)0;
    }

    entry[0] = typeByte;
    *(LONG *)(entry + 2) = length;

    srcLen = 0;
    while (dataPtr[srcLen] != 0) {
        srcLen += 1;
    }

    if (srcLen == length) {
        payload = (UBYTE *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(&Global_STR_P_TYPE_C_2, 58, length, MEMF_PUBLIC + MEMF_CLEAR);
        *(UBYTE **)(entry + 6) = payload;
    } else {
        *(UBYTE **)(entry + 6) = (UBYTE *)0;
    }

    if (*(UBYTE **)(entry + 6) == (UBYTE *)0) {
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_P_TYPE_C_3, 77, entry, 10);
        return (void *)0;
    }

    payload = *(UBYTE **)(entry + 6);
    i = 0;
    while (i < length) {
        payload[i] = dataPtr[i];
        i += 1;
    }

    return (void *)entry;
}
