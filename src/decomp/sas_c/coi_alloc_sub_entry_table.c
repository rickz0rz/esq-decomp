typedef unsigned char UBYTE;
typedef unsigned long ULONG;
typedef short WORD;
typedef long LONG;

extern UBYTE Global_STR_COI_C_5[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
void GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray(void *table, LONG elem_size, LONG count);

void COI_AllocSubEntryTable(void *entry)
{
    UBYTE *anim;
    LONG bytes;
    LONG count;
    void *table;

    if (entry == (void *)0) {
        return;
    }

    anim = *(UBYTE **)((UBYTE *)entry + 48);
    if (anim == (UBYTE *)0) {
        return;
    }

    count = (LONG)*(WORD *)(anim + 36);
    if ((WORD)count <= 0) {
        return;
    }

    bytes = count << 2;
    table = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_COI_C_5, 1123, bytes, 0x10001UL);
    *(void **)(anim + 38) = table;

    GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray(table, 30, count);
}
