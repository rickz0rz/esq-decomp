typedef unsigned char UBYTE;
typedef unsigned long ULONG;
typedef long LONG;

enum {
    STRUCT_ANIMOB_SIZE = 42,
    ENTRY_ANIM_PTR_OFFSET = 48,
    ANIM_DEFAULT_STR_OFFSET = 28,
    ANIM_SENTINEL_OFFSET = 32,
    ANIM_SENTINEL_INVALID = -1,
    COI_ALLOC_LINE = 1458,
    COI_MEMF_PUBLIC_CLEAR = 0x10001UL
};

extern UBYTE Global_STR_COI_C_2[];
extern UBYTE COI_STR_DEFAULT_TOKEN_TEMPLATE_B[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
LONG GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(void *old_ptr, const void *new_ptr);

void COI_EnsureAnimObjectAllocated(void *entry)
{
    UBYTE *e;
    UBYTE *anim;

    e = (UBYTE *)entry;
    if (e == (UBYTE *)0) {
        return;
    }

    anim = *(UBYTE **)(e + ENTRY_ANIM_PTR_OFFSET);
    if (anim != (UBYTE *)0) {
        return;
    }

    anim = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_COI_C_2,
        COI_ALLOC_LINE,
        STRUCT_ANIMOB_SIZE,
        COI_MEMF_PUBLIC_CLEAR);
    *(UBYTE **)(e + ENTRY_ANIM_PTR_OFFSET) = anim;

    if (anim != (UBYTE *)0) {
        void *old_str;
        LONG new_owned;

        old_str = *(void **)(anim + ANIM_DEFAULT_STR_OFFSET);
        new_owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(old_str, COI_STR_DEFAULT_TOKEN_TEMPLATE_B);
        *(LONG *)(anim + ANIM_DEFAULT_STR_OFFSET) = new_owned;
        *(LONG *)(anim + ANIM_SENTINEL_OFFSET) = ANIM_SENTINEL_INVALID;
    }
}
