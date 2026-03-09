typedef unsigned char UBYTE;
typedef unsigned long ULONG;
typedef long LONG;

enum {
    STRUCT_ANIMOB_SIZE = 42,
    ENTRY_ANIM_PTR_OFFSET = 48,
    ANIM_SENTINEL_INVALID = -1,
    COI_ALLOC_LINE = 1458
};

static const ULONG COI_MEMF_PUBLIC_CLEAR = 0x10001UL;

extern UBYTE Global_STR_COI_C_2[];
extern UBYTE COI_STR_DEFAULT_TOKEN_TEMPLATE_B[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
LONG GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(const void *new_ptr, void *old_ptr);

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
    COI_AnimObject *anim;

    e = (COI_Entry *)entry;
    if (e == (COI_Entry *)0) {
        return;
    }

    anim = e->anim;
    if (anim != (COI_AnimObject *)0) {
        return;
    }

    anim = (COI_AnimObject *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_COI_C_2,
        COI_ALLOC_LINE,
        STRUCT_ANIMOB_SIZE,
        COI_MEMF_PUBLIC_CLEAR);
    e->anim = anim;

    if (anim != (COI_AnimObject *)0) {
        void *old_str;
        LONG new_owned;

        old_str = anim->defaultStr;
        new_owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(COI_STR_DEFAULT_TOKEN_TEMPLATE_B, old_str);
        anim->defaultStr = (void *)new_owned;
        anim->sentinel = ANIM_SENTINEL_INVALID;
    }
}
