typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

extern UBYTE Global_STR_COI_C_4[];

LONG GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(void *old_ptr, const void *new_ptr);
void GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(void *table, LONG elem_size, LONG count);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);

void COI_FreeSubEntryTableEntries(void *entry)
{
    UBYTE *anim;
    WORD i;

    if (entry == (void *)0) {
        return;
    }

    anim = *(UBYTE **)((UBYTE *)entry + 48);
    if (anim == (UBYTE *)0) {
        return;
    }

    i = 0;
    while (i < *(WORD *)(anim + 36)) {
        UBYTE **table;
        UBYTE *sub;
        LONG owned;

        table = *(UBYTE ***)(anim + 38);
        sub = table[i];

        *(WORD *)(sub + 0) = 0;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + 2), (void *)0);
        *(LONG *)(sub + 2) = owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + 6), (void *)0);
        *(LONG *)(sub + 6) = owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + 10), (void *)0);
        *(LONG *)(sub + 10) = owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + 14), (void *)0);
        *(LONG *)(sub + 14) = owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + 18), (void *)0);
        *(LONG *)(sub + 18) = owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + 22), (void *)0);
        *(LONG *)(sub + 22) = owned;

        *(LONG *)(sub + 26) = 0;
        i += 1;
    }

    if (*(WORD *)(anim + 36) != 0) {
        LONG count;
        LONG bytes;
        UBYTE **table;

        count = (LONG)*(WORD *)(anim + 36);
        table = *(UBYTE ***)(anim + 38);

        GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(table, 30, count);

        bytes = count << 2;
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_COI_C_4, 876, table, bytes);
    }

    *(WORD *)(anim + 36) = 0;
    *(LONG *)(anim + 38) = 0;
}
