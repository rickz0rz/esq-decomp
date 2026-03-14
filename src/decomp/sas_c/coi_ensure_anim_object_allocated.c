#include <exec/types.h>
enum {
    STRUCT_ANIMOB_SIZE = 42,
    ENTRY_ANIM_PTR_OFFSET = 48,
    ANIM_SENTINEL_INVALID = -1,
    COI_ALLOC_LINE = 1458
};

static const ULONG COI_MEMF_PUBLIC_CLEAR = 0x10001UL;

extern const char Global_STR_COI_C_2[];
extern const char COI_STR_DEFAULT_TOKEN_TEMPLATE_B[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(const char *new_ptr, char *old_ptr);

typedef struct COI_AnimObject {
    UBYTE pad0[28];
    void *defaultStr;
    LONG sentinel;
} COI_AnimObject;

typedef struct COI_Entry {
    UBYTE pad0[ENTRY_ANIM_PTR_OFFSET];
    COI_AnimObject *anim;
} COI_Entry;

void COI_EnsureAnimObjectAllocated(void *entry)
{
    COI_Entry *e;

    e = (COI_Entry *)entry;
    if (e == (COI_Entry *)0) {
        return;
    }

    if (e->anim != (COI_AnimObject *)0) {
        return;
    }

    e->anim = (COI_AnimObject *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_COI_C_2,
        COI_ALLOC_LINE,
        STRUCT_ANIMOB_SIZE,
        COI_MEMF_PUBLIC_CLEAR);

    if (e->anim != (COI_AnimObject *)0) {
        e->anim->defaultStr = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
            COI_STR_DEFAULT_TOKEN_TEMPLATE_B,
            (char *)e->anim->defaultStr);
        e->anim->sentinel = ANIM_SENTINEL_INVALID;
    }
}
