typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE Global_STR_P_TYPE_C_4;
extern UBYTE Global_STR_P_TYPE_C_5;

extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(UBYTE *tagName, LONG line, void *ptr, LONG bytes);

void P_TYPE_FreeEntry(UBYTE *entry)
{
    if (entry == (UBYTE *)0) {
        return;
    }

    if (*(UBYTE **)(entry + 6) != (UBYTE *)0) {
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
            &Global_STR_P_TYPE_C_4,
            92,
            *(UBYTE **)(entry + 6),
            *(LONG *)(entry + 2));
    }

    SCRIPT_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_P_TYPE_C_5, 95, entry, 10);
}
