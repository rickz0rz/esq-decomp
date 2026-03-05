typedef unsigned char UBYTE;
typedef unsigned long ULONG;
typedef long LONG;

extern UBYTE Global_STR_COI_C_2[];
extern UBYTE COI_STR_DEFAULT_TOKEN_TEMPLATE_B[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
LONG GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(void *old_ptr, const void *new_ptr);

#define STRUCT_ANIMOB_SIZE 42

void COI_EnsureAnimObjectAllocated(void *entry)
{
    UBYTE *e;
    UBYTE *anim;

    e = (UBYTE *)entry;
    if (e == (UBYTE *)0) {
        return;
    }

    anim = *(UBYTE **)(e + 48);
    if (anim != (UBYTE *)0) {
        return;
    }

    anim = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_COI_C_2, 1458, STRUCT_ANIMOB_SIZE, 0x10001UL);
    *(UBYTE **)(e + 48) = anim;

    if (anim != (UBYTE *)0) {
        void *old_str;
        LONG new_owned;

        old_str = *(void **)(anim + 28);
        new_owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(old_str, COI_STR_DEFAULT_TOKEN_TEMPLATE_B);
        *(LONG *)(anim + 28) = new_owned;
        *(LONG *)(anim + 32) = -1;
    }
}
