typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;
typedef unsigned char UBYTE;

enum {
    COI_ENTRY_ANIM_OFFSET = 48,
    COI_ANIM_COUNT_OFFSET = 36,
    COI_ANIM_TABLE_OFFSET = 38,
    COI_ANIM_FIELD_0_OFFSET = 4,
    COI_ANIM_FIELD_1_OFFSET = 8,
    COI_ANIM_FIELD_2_OFFSET = 12,
    COI_ANIM_FIELD_3_OFFSET = 16,
    COI_ANIM_FIELD_4_OFFSET = 20,
    COI_ANIM_FIELD_6_OFFSET = 24,
    COI_ANIM_FIELD_7_OFFSET = 28,
    COI_SUB_FIELD_1_OFFSET = 2,
    COI_SUB_FIELD_2_OFFSET = 6,
    COI_SUB_FIELD_3_OFFSET = 10,
    COI_SUB_FIELD_4_OFFSET = 14,
    COI_SUB_FIELD_6_OFFSET = 18,
    COI_SUB_FIELD_7_OFFSET = 22,
    COI_SUB_KEY_OFFSET = 0,
    COI_MODE_FIELD_0 = 0,
    COI_MODE_FIELD_1 = 1,
    COI_MODE_FIELD_2 = 2,
    COI_MODE_FIELD_3 = 3,
    COI_MODE_FIELD_4 = 4,
    COI_MODE_ANIM_POINTER = 5,
    COI_MODE_FIELD_6 = 6,
    COI_MODE_FIELD_7 = 7
};

LONG COI_GetAnimFieldPointerByMode(void *entry, UWORD key, UWORD mode)
{
    UBYTE *e;
    UBYTE *anim;
    UBYTE *sub;
    WORD found;
    WORD i;
    LONG out;

    e = (UBYTE *)entry;
    sub = (UBYTE *)0;
    found = 0;

    if (e == (UBYTE *)0 || *(LONG *)(e + COI_ENTRY_ANIM_OFFSET) == 0) {
        return 0;
    }

    anim = *(UBYTE **)(e + COI_ENTRY_ANIM_OFFSET);
    i = 0;
    while (i < *(WORD *)(anim + COI_ANIM_COUNT_OFFSET)) {
        UBYTE **table;
        UBYTE *cur;

        table = *(UBYTE ***)(anim + COI_ANIM_TABLE_OFFSET);
        cur = table[i];
        sub = cur;
        if (*(UWORD *)(cur + COI_SUB_KEY_OFFSET) == key) {
            found = 1;
            break;
        }
        i += 1;
    }

    switch (mode) {
    case COI_MODE_ANIM_POINTER:
        out = (LONG)anim;
        break;
    case COI_MODE_FIELD_0:
        out = *(LONG *)(anim + COI_ANIM_FIELD_0_OFFSET);
        break;
    case COI_MODE_FIELD_1:
        out = (found != 0) ? *(LONG *)(sub + COI_SUB_FIELD_1_OFFSET) : *(LONG *)(anim + COI_ANIM_FIELD_1_OFFSET);
        break;
    case COI_MODE_FIELD_2:
        out = (found != 0) ? *(LONG *)(sub + COI_SUB_FIELD_2_OFFSET) : *(LONG *)(anim + COI_ANIM_FIELD_2_OFFSET);
        break;
    case COI_MODE_FIELD_3:
        out = (found != 0) ? *(LONG *)(sub + COI_SUB_FIELD_3_OFFSET) : *(LONG *)(anim + COI_ANIM_FIELD_3_OFFSET);
        break;
    case COI_MODE_FIELD_4:
        out = (found != 0) ? *(LONG *)(sub + COI_SUB_FIELD_4_OFFSET) : *(LONG *)(anim + COI_ANIM_FIELD_4_OFFSET);
        break;
    case COI_MODE_FIELD_6:
        out = (found != 0) ? *(LONG *)(sub + COI_SUB_FIELD_6_OFFSET) : *(LONG *)(anim + COI_ANIM_FIELD_6_OFFSET);
        break;
    case COI_MODE_FIELD_7:
        out = (found != 0) ? *(LONG *)(sub + COI_SUB_FIELD_7_OFFSET) : *(LONG *)(anim + COI_ANIM_FIELD_7_OFFSET);
        break;
    default:
        out = 0;
        break;
    }

    return out;
}
