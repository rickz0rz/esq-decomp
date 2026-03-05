typedef unsigned char UBYTE;
typedef long LONG;

LONG GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(void *old_ptr, const void *new_ptr);

void COI_ClearAnimObjectStrings(void *entry)
{
    UBYTE *e;
    UBYTE *anim;
    LONG owned;

    e = (UBYTE *)entry;
    if (e == (UBYTE *)0) {
        return;
    }

    anim = *(UBYTE **)(e + 48);
    if (anim == (UBYTE *)0) {
        return;
    }

    anim[0] = 0;
    anim[1] = 0;
    anim[2] = 0;
    anim[3] = 0;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + 4), (void *)0);
    *(LONG *)(anim + 4) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + 8), (void *)0);
    *(LONG *)(anim + 8) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + 12), (void *)0);
    *(LONG *)(anim + 12) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + 16), (void *)0);
    *(LONG *)(anim + 16) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + 20), (void *)0);
    *(LONG *)(anim + 20) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + 24), (void *)0);
    *(LONG *)(anim + 24) = owned;

    owned = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*(void **)(anim + 28), (void *)0);
    *(LONG *)(anim + 28) = owned;

    *(LONG *)(anim + 32) = 0;
}
