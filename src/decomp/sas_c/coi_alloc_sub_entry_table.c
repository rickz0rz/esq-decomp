#include <exec/types.h>
enum {
    COI_ANIM_AUX_PTR_OFFSET = 48,
    COI_ANIM_COUNT_OFFSET = 36,
    COI_ANIM_TABLE_OFFSET = 38,
    COI_ENTRY_PTR_STRIDE_SHIFT = 2,
    COI_ALLOC_LINE = 1123,
    COI_SUBENTRY_ELEM_SIZE = 30
};

static const ULONG COI_MEMF_PUBLIC_CLEAR = 0x10001UL;

extern const char Global_STR_COI_C_5[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
void GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray(void *table, LONG elem_size, LONG count);

typedef struct COI_AnimObject {
    UBYTE pad0[COI_ANIM_COUNT_OFFSET];
    WORD subEntryCount;
    void *subEntryTable;
} COI_AnimObject;

typedef struct COI_Entry {
    UBYTE pad0[COI_ANIM_AUX_PTR_OFFSET];
    COI_AnimObject *anim;
} COI_Entry;

void COI_AllocSubEntryTable(void *entry)
{
    COI_AnimObject *anim;
    LONG bytes;
    LONG count;
    void **tableSlot;

    if (entry == (void *)0) {
        return;
    }

    anim = ((COI_Entry *)entry)->anim;
    if (anim == (COI_AnimObject *)0) {
        return;
    }

    count = (LONG)anim->subEntryCount;
    if ((WORD)count <= 0) {
        return;
    }

    bytes = count << COI_ENTRY_PTR_STRIDE_SHIFT;
    tableSlot = &anim->subEntryTable;
    *tableSlot = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_COI_C_5,
        COI_ALLOC_LINE,
        bytes,
        COI_MEMF_PUBLIC_CLEAR);

    GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray(*tableSlot, COI_SUBENTRY_ELEM_SIZE, count);
}
