#include <exec/types.h>
typedef struct PTypeEntry {
    UBYTE type_byte;
    UBYTE subtype_byte;
    long len;
    UBYTE *payload;
} PTypeEntry;

extern PTypeEntry *P_TYPE_PrimaryGroupListPtr;
extern PTypeEntry *P_TYPE_SecondaryGroupListPtr;

extern long P_TYPE_LoadPromoIdDataFile(void);

void P_TYPE_ResetListsAndLoadPromoIds(void)
{
    P_TYPE_SecondaryGroupListPtr = (PTypeEntry *)0;
    P_TYPE_PrimaryGroupListPtr = (PTypeEntry *)0;
    P_TYPE_LoadPromoIdDataFile();
}
