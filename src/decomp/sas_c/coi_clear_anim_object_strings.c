#include <exec/types.h>
enum {
    COI_NULL = 0,
    ENTRY_ANIM_OFFSET = 48
};

char *ESQPARS_ReplaceOwnedString(const char *new_ptr, char *old_ptr);

typedef struct COI_AnimObject {
    UBYTE flags0;
    UBYTE flags1;
    UBYTE flags2;
    UBYTE flags3;
    void *owned0;
    void *owned1;
    void *owned2;
    void *owned3;
    void *owned4;
    void *owned5;
    void *owned6;
    LONG status;
} COI_AnimObject;

typedef struct COI_Entry {
    UBYTE pad0[ENTRY_ANIM_OFFSET];
    COI_AnimObject *anim;
} COI_Entry;

void COI_ClearAnimObjectStrings(void *entry)
{
    COI_Entry *e;
    COI_AnimObject *anim;
    LONG *statusPtr;
    char *owned;

    e = (COI_Entry *)entry;
    if (e == (COI_Entry *)COI_NULL) {
        return;
    }

    anim = e->anim;
    if (anim == (COI_AnimObject *)COI_NULL) {
        return;
    }

    ((LONG *)anim)[0] = COI_NULL;

    owned = ESQPARS_ReplaceOwnedString((const char *)COI_NULL, anim->owned0);
    anim->owned0 = owned;

    owned = ESQPARS_ReplaceOwnedString((const char *)COI_NULL, anim->owned1);
    anim->owned1 = owned;

    owned = ESQPARS_ReplaceOwnedString((const char *)COI_NULL, anim->owned2);
    anim->owned2 = owned;

    owned = ESQPARS_ReplaceOwnedString((const char *)COI_NULL, anim->owned3);
    anim->owned3 = owned;

    owned = ESQPARS_ReplaceOwnedString((const char *)COI_NULL, anim->owned4);
    anim->owned4 = owned;

    owned = ESQPARS_ReplaceOwnedString((const char *)COI_NULL, anim->owned5);
    anim->owned5 = owned;

    owned = ESQPARS_ReplaceOwnedString((const char *)COI_NULL, anim->owned6);
    anim->owned6 = owned;

    statusPtr = &anim->status;
    *statusPtr = COI_NULL;
}
