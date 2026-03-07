typedef unsigned char UBYTE;
typedef long LONG;

enum {
    COI_NULL = 0,
    ENTRY_ANIM_OFFSET = 48,
    ANIM_FLAG_0_OFFSET = 0,
    ANIM_FLAG_1_OFFSET = 1,
    ANIM_FLAG_2_OFFSET = 2,
    ANIM_FLAG_3_OFFSET = 3,
    ANIM_OWNED_0_OFFSET = 4,
    ANIM_OWNED_1_OFFSET = 8,
    ANIM_OWNED_2_OFFSET = 12,
    ANIM_OWNED_3_OFFSET = 16,
    ANIM_OWNED_4_OFFSET = 20,
    ANIM_OWNED_5_OFFSET = 24,
    ANIM_OWNED_6_OFFSET = 28,
    ANIM_STATUS_OFFSET = 32
};

LONG GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(void *old_ptr, const void *new_ptr);

void COI_ClearAnimObjectStrings(void *entry)
{
    UBYTE *e;
    UBYTE *anim;
    LONG owned;

    e = (UBYTE *)entry;
    if (e == (UBYTE *)COI_NULL) {
        return;
    }

    anim = *(UBYTE **)(e + ENTRY_ANIM_OFFSET);
    if (anim == (UBYTE *)COI_NULL) {
        return;
    }

    anim[ANIM_FLAG_0_OFFSET] = COI_NULL;
    anim[ANIM_FLAG_1_OFFSET] = COI_NULL;
    anim[ANIM_FLAG_2_OFFSET] = COI_NULL;
    anim[ANIM_FLAG_3_OFFSET] = COI_NULL;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + ANIM_OWNED_0_OFFSET), (void *)COI_NULL);
    *(LONG *)(anim + ANIM_OWNED_0_OFFSET) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + ANIM_OWNED_1_OFFSET), (void *)COI_NULL);
    *(LONG *)(anim + ANIM_OWNED_1_OFFSET) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + ANIM_OWNED_2_OFFSET), (void *)COI_NULL);
    *(LONG *)(anim + ANIM_OWNED_2_OFFSET) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + ANIM_OWNED_3_OFFSET), (void *)COI_NULL);
    *(LONG *)(anim + ANIM_OWNED_3_OFFSET) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + ANIM_OWNED_4_OFFSET), (void *)COI_NULL);
    *(LONG *)(anim + ANIM_OWNED_4_OFFSET) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + ANIM_OWNED_5_OFFSET), (void *)COI_NULL);
    *(LONG *)(anim + ANIM_OWNED_5_OFFSET) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + ANIM_OWNED_6_OFFSET), (void *)COI_NULL);
    *(LONG *)(anim + ANIM_OWNED_6_OFFSET) = owned;

    *(LONG *)(anim + ANIM_STATUS_OFFSET) = COI_NULL;
}
