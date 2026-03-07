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
    const LONG ENTRY_SIZE = 10;
    const LONG ENTRY_TYPE_OFFSET = 0;
    const LONG ENTRY_LENGTH_OFFSET = 2;
    const LONG ENTRY_PAYLOADPTR_OFFSET = 6;
    const LONG ALLOC_ENTRY_LINE = 47;
    const LONG ALLOC_PAYLOAD_LINE = 58;
    const LONG FREE_ENTRY_LINE = 77;
    const LONG PTR_NULL = 0;
    UBYTE *entry;
    UBYTE *payload;
    LONG i;
    LONG srcLen;

    entry = (UBYTE *)PTR_NULL;
    if (length <= 0) {
        return (void *)PTR_NULL;
    }

    entry = (UBYTE *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(
        &Global_STR_P_TYPE_C_1, ALLOC_ENTRY_LINE, ENTRY_SIZE, MEMF_PUBLIC + MEMF_CLEAR);
    if (entry == (UBYTE *)PTR_NULL) {
        return (void *)PTR_NULL;
    }

    entry[ENTRY_TYPE_OFFSET] = typeByte;
    *(LONG *)(entry + ENTRY_LENGTH_OFFSET) = length;

    srcLen = 0;
    while (dataPtr[srcLen] != 0) {
        srcLen += 1;
    }

    if (srcLen == length) {
        payload = (UBYTE *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(
            &Global_STR_P_TYPE_C_2, ALLOC_PAYLOAD_LINE, length, MEMF_PUBLIC + MEMF_CLEAR);
        *(UBYTE **)(entry + ENTRY_PAYLOADPTR_OFFSET) = payload;
    } else {
        *(UBYTE **)(entry + ENTRY_PAYLOADPTR_OFFSET) = (UBYTE *)PTR_NULL;
    }

    if (*(UBYTE **)(entry + ENTRY_PAYLOADPTR_OFFSET) == (UBYTE *)PTR_NULL) {
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_P_TYPE_C_3, FREE_ENTRY_LINE, entry, ENTRY_SIZE);
        return (void *)PTR_NULL;
    }

    payload = *(UBYTE **)(entry + ENTRY_PAYLOADPTR_OFFSET);
    i = 0;
    while (i < length) {
        payload[i] = dataPtr[i];
        i += 1;
    }

    return (void *)entry;
}
