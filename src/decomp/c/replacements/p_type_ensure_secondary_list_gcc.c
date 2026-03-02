#include "esq_types.h"

extern void *P_TYPE_PrimaryGroupListPtr;
extern void *P_TYPE_SecondaryGroupListPtr;
extern u8 TEXTDISP_SecondaryGroupCode;

void *P_TYPE_CloneEntry(void *dst, const void *src) __attribute__((noinline));

typedef struct PTypeEntry {
    u8 type_byte;
    u8 subtype_byte;
    s32 len;
    u8 *payload;
} PTypeEntry;

void P_TYPE_EnsureSecondaryList(void) __attribute__((noinline, used));

void P_TYPE_EnsureSecondaryList(void)
{
    if (P_TYPE_PrimaryGroupListPtr == (void *)0) {
        return;
    }

    if (P_TYPE_SecondaryGroupListPtr != (void *)0) {
        return;
    }

    P_TYPE_SecondaryGroupListPtr = P_TYPE_CloneEntry(P_TYPE_SecondaryGroupListPtr, P_TYPE_PrimaryGroupListPtr);
    ((PTypeEntry *)P_TYPE_SecondaryGroupListPtr)->type_byte = TEXTDISP_SecondaryGroupCode;
}
