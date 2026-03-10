typedef unsigned char UBYTE;

typedef struct PTypeEntry {
    UBYTE type_byte;
    UBYTE subtype_byte;
    long len;
    UBYTE *payload;
} PTypeEntry;

extern PTypeEntry *P_TYPE_PrimaryGroupListPtr;
extern PTypeEntry *P_TYPE_SecondaryGroupListPtr;

extern void P_TYPE_FreeEntry(PTypeEntry *entry);

void P_TYPE_PromoteSecondaryList(void)
{
    P_TYPE_FreeEntry(P_TYPE_PrimaryGroupListPtr);
    P_TYPE_PrimaryGroupListPtr = P_TYPE_SecondaryGroupListPtr;
    P_TYPE_SecondaryGroupListPtr = 0;
}
