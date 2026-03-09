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
    SUBENTRY_TABLE_DEALLOC_LINE = 876
};

static const LONG SUBENTRY_TABLE_PTR_SHIFT = 2;

extern const UBYTE Global_STR_COI_C_4[];

LONG GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(void *old_ptr, const void *new_ptr);
void GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(void *table, LONG elem_size, LONG count);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);

typedef struct COI_SubEntry {
    WORD key0;
    void *str0;
    void *str1;
    void *str2;
    void *str3;
    void *str4;
    void *str5;
    void *extraPtr;
} COI_SubEntry;

typedef struct COI_AnimObject {
    UBYTE pad0[ANIM_COUNT_OFFSET];
    WORD subEntryCount;
    COI_SubEntry **subEntryTable;
} COI_AnimObject;

typedef struct COI_Entry {
    UBYTE pad0[ENTRY_ANIM_PTR_OFFSET];
    COI_AnimObject *anim;
} COI_Entry;

void COI_FreeSubEntryTableEntries(void *entry)
{
    COI_AnimObject *anim;
    WORD i;

    if (entry == (void *)0) {
        return;
    }

    anim = ((COI_Entry *)entry)->anim;
    if (anim == (COI_AnimObject *)0) {
        return;
    }

    i = 0;
    while (i < anim->subEntryCount) {
        COI_SubEntry **table;
        COI_SubEntry *sub;
        LONG owned;

        table = anim->subEntryTable;
        sub = table[i];

        sub->key0 = 0;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(sub->str0, (void *)0);
        sub->str0 = (void *)owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(sub->str1, (void *)0);
        sub->str1 = (void *)owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(sub->str2, (void *)0);
        sub->str2 = (void *)owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(sub->str3, (void *)0);
        sub->str3 = (void *)owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(sub->str4, (void *)0);
        sub->str4 = (void *)owned;

        owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(sub->str5, (void *)0);
        sub->str5 = (void *)owned;

        sub->extraPtr = 0;
        i += 1;
    }

    if (anim->subEntryCount != 0) {
        LONG count;
        LONG bytes;
        COI_SubEntry **table;

        count = (LONG)anim->subEntryCount;
        table = anim->subEntryTable;

        GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(table, SUBENTRY_SIZE, count);

        bytes = count << SUBENTRY_TABLE_PTR_SHIFT;
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_COI_C_4,
            SUBENTRY_TABLE_DEALLOC_LINE,
            table,
            bytes);
    }

    anim->subEntryCount = 0;
    anim->subEntryTable = 0;
}
