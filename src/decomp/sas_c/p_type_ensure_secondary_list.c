typedef unsigned char UBYTE;

typedef struct PTypeEntry {
    UBYTE type_byte;
    UBYTE subtype_byte;
    long len;
    UBYTE *payload;
} PTypeEntry;

extern PTypeEntry *P_TYPE_PrimaryGroupListPtr;
extern PTypeEntry *P_TYPE_SecondaryGroupListPtr;
extern UBYTE TEXTDISP_SecondaryGroupCode;

extern PTypeEntry *P_TYPE_CloneEntry(PTypeEntry *dstEntry, PTypeEntry *srcEntry);

void P_TYPE_EnsureSecondaryList(void)
{
    if (P_TYPE_PrimaryGroupListPtr == (PTypeEntry *)0) {
        return;
    }

    if (P_TYPE_SecondaryGroupListPtr != (PTypeEntry *)0) {
        return;
    }

    P_TYPE_SecondaryGroupListPtr = P_TYPE_CloneEntry(P_TYPE_SecondaryGroupListPtr, P_TYPE_PrimaryGroupListPtr);
    P_TYPE_SecondaryGroupListPtr->type_byte = TEXTDISP_SecondaryGroupCode;
}
