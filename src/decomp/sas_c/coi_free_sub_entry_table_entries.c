typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

enum {
    ENTRY_ANIM_PTR_OFFSET = 48,
    ANIM_COUNT_OFFSET = 36,
    ANIM_TABLE_PTR_OFFSET = 38,
    SUBENTRY_SIZE = 30,
    SUBENTRY_KEY_OFFSET = 0,
    SUBENTRY_STR0_OFFSET = 2,
    SUBENTRY_STR1_OFFSET = 6,
    SUBENTRY_STR2_OFFSET = 10,
    SUBENTRY_STR3_OFFSET = 14,
    SUBENTRY_STR4_OFFSET = 18,
    SUBENTRY_STR5_OFFSET = 22,
    SUBENTRY_EXTRA_PTR_OFFSET = 26,
    SUBENTRY_TABLE_PTR_SHIFT = 2,
    SUBENTRY_TABLE_DEALLOC_LINE = 876
};

extern const UBYTE Global_STR_COI_C_4[];

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

    anim = *(UBYTE **)((UBYTE *)entry + ENTRY_ANIM_PTR_OFFSET);
    if (anim == (UBYTE *)0) {
        return;
    }

    i = 0;
    while (i < *(WORD *)(anim + ANIM_COUNT_OFFSET)) {
        UBYTE **table;
        UBYTE *sub;
        LONG owned;

        table = *(UBYTE ***)(anim + ANIM_TABLE_PTR_OFFSET);
        sub = table[i];

        *(WORD *)(sub + SUBENTRY_KEY_OFFSET) = 0;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + SUBENTRY_STR0_OFFSET), (void *)0);
        *(LONG *)(sub + SUBENTRY_STR0_OFFSET) = owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + SUBENTRY_STR1_OFFSET), (void *)0);
        *(LONG *)(sub + SUBENTRY_STR1_OFFSET) = owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + SUBENTRY_STR2_OFFSET), (void *)0);
        *(LONG *)(sub + SUBENTRY_STR2_OFFSET) = owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + SUBENTRY_STR3_OFFSET), (void *)0);
        *(LONG *)(sub + SUBENTRY_STR3_OFFSET) = owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + SUBENTRY_STR4_OFFSET), (void *)0);
        *(LONG *)(sub + SUBENTRY_STR4_OFFSET) = owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(sub + SUBENTRY_STR5_OFFSET), (void *)0);
        *(LONG *)(sub + SUBENTRY_STR5_OFFSET) = owned;

        *(LONG *)(sub + SUBENTRY_EXTRA_PTR_OFFSET) = 0;
        i += 1;
    }

    if (*(WORD *)(anim + ANIM_COUNT_OFFSET) != 0) {
        LONG count;
        LONG bytes;
        UBYTE **table;

        count = (LONG)*(WORD *)(anim + ANIM_COUNT_OFFSET);
        table = *(UBYTE ***)(anim + ANIM_TABLE_PTR_OFFSET);

        GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(table, SUBENTRY_SIZE, count);

        bytes = count << SUBENTRY_TABLE_PTR_SHIFT;
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_COI_C_4,
            SUBENTRY_TABLE_DEALLOC_LINE,
            table,
            bytes);
    }

    *(WORD *)(anim + ANIM_COUNT_OFFSET) = 0;
    *(LONG *)(anim + ANIM_TABLE_PTR_OFFSET) = 0;
}
