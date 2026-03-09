typedef signed long LONG;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

extern UBYTE Global_STR_P_TYPE_C_1;
extern UBYTE Global_STR_P_TYPE_C_2;
extern UBYTE Global_STR_P_TYPE_C_3;

extern void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(UBYTE *tagName, LONG line, LONG size, LONG flags);
extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(UBYTE *tagName, LONG line, void *ptr, LONG bytes);

typedef struct P_TYPE_Entry {
    UBYTE typeByte;
    UBYTE pad1;
    LONG payloadLength;
    UBYTE *payloadPtr;
} P_TYPE_Entry;

void *P_TYPE_AllocateEntry(UBYTE typeByte, LONG length, UBYTE *dataPtr)
{
    const LONG ENTRY_SIZE = 10;
    const LONG ALLOC_ENTRY_LINE = 47;
    const LONG ALLOC_PAYLOAD_LINE = 58;
    const LONG FREE_ENTRY_LINE = 77;
    const LONG PTR_NULL = 0;
    P_TYPE_Entry *entry;
    UBYTE *payload;
    LONG i;
    LONG srcLen;

    entry = (P_TYPE_Entry *)PTR_NULL;
    if (length <= 0) {
        return (void *)PTR_NULL;
    }

    entry = (P_TYPE_Entry *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(
        &Global_STR_P_TYPE_C_1, ALLOC_ENTRY_LINE, ENTRY_SIZE, MEMF_PUBLIC + MEMF_CLEAR);
    if (entry == (P_TYPE_Entry *)PTR_NULL) {
        return (void *)PTR_NULL;
    }

    entry->typeByte = typeByte;
    entry->payloadLength = length;

    srcLen = 0;
    while (dataPtr[srcLen] != 0) {
        srcLen += 1;
    }

    if (srcLen == length) {
        payload = (UBYTE *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(
            &Global_STR_P_TYPE_C_2, ALLOC_PAYLOAD_LINE, length, MEMF_PUBLIC + MEMF_CLEAR);
        entry->payloadPtr = payload;
    } else {
        entry->payloadPtr = (UBYTE *)PTR_NULL;
    }

    if (entry->payloadPtr == (UBYTE *)PTR_NULL) {
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_P_TYPE_C_3, FREE_ENTRY_LINE, entry, ENTRY_SIZE);
        return (void *)PTR_NULL;
    }

    payload = entry->payloadPtr;
    i = 0;
    while (i < length) {
        payload[i] = dataPtr[i];
        i += 1;
    }

    return (void *)entry;
}
