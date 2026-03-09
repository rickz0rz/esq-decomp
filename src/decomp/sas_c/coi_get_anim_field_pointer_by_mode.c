typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;
typedef unsigned char UBYTE;

enum {
    COI_ENTRY_ANIM_OFFSET = 48,
    COI_MODE_ANIM_POINTER = 5
};

typedef struct COI_SubEntry {
    UWORD key0;
    void *field1;
    void *field2;
    void *field3;
    void *field4;
    void *field6;
    void *field7;
    void *extraPtr;
} COI_SubEntry;

typedef struct COI_AnimObject {
    UBYTE pad0[4];
    void *field0;
    void *field1;
    void *field2;
    void *field3;
    void *field4;
    void *field6;
    void *field7;
    WORD subEntryCount;
    COI_SubEntry **subEntryTable;
} COI_AnimObject;

typedef struct COI_Entry {
    UBYTE pad0[COI_ENTRY_ANIM_OFFSET];
    COI_AnimObject *anim;
} COI_Entry;

LONG COI_GetAnimFieldPointerByMode(void *entry, UWORD key, UWORD mode)
{
    COI_Entry *e;
    COI_AnimObject *anim;
    COI_SubEntry *sub;
    WORD found;
    WORD i;
    LONG out;

    e = (COI_Entry *)entry;
    sub = (COI_SubEntry *)0;
    found = 0;

    if (e == (COI_Entry *)0 || e->anim == (COI_AnimObject *)0) {
        return 0;
    }

    anim = e->anim;
    i = 0;
    while (i < anim->subEntryCount) {
        COI_SubEntry **table;
        COI_SubEntry *cur;

        table = anim->subEntryTable;
        cur = table[i];
        sub = cur;
        if (cur->key0 == key) {
            found = 1;
            break;
        }
        i += 1;
    }

    switch (mode) {
    case COI_MODE_ANIM_POINTER:
        out = (LONG)anim;
        break;
    case 0:
        out = (LONG)anim->field0;
        break;
    case 1:
        out = (found != 0) ? (LONG)sub->field1 : (LONG)anim->field1;
        break;
    case 2:
        out = (found != 0) ? (LONG)sub->field2 : (LONG)anim->field2;
        break;
    case 3:
        out = (found != 0) ? (LONG)sub->field3 : (LONG)anim->field3;
        break;
    case 4:
        out = (found != 0) ? (LONG)sub->field4 : (LONG)anim->field4;
        break;
    case 6:
        out = (found != 0) ? (LONG)sub->field6 : (LONG)anim->field6;
        break;
    case 7:
        out = (found != 0) ? (LONG)sub->field7 : (LONG)anim->field7;
        break;
    default:
        out = 0;
        break;
    }

    return out;
}
