#include <exec/types.h>
typedef struct PTypeEntry {
    UBYTE type_byte;
    UBYTE subtype_byte;
    LONG len;
    UBYTE *payload;
} PTypeEntry;

extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern PTypeEntry *P_TYPE_PrimaryGroupListPtr;
extern PTypeEntry *P_TYPE_SecondaryGroupListPtr;

extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG count);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *src);
extern void P_TYPE_FreeEntry(PTypeEntry *entry);
extern PTypeEntry *P_TYPE_AllocateEntry(UBYTE typeByte, LONG length, UBYTE *dataPtr);

LONG P_TYPE_ParseAndStoreTypeRecord(const char *src)
{
    char parseBuf[4];
    UBYTE groupCode;
    LONG parsedLength;
    LONG slot;
    LONG result;
    PTypeEntry **slotPtr;

    result = 0;

    STRING_CopyPadNul(parseBuf, src, 3);
    parseBuf[3] = '\0';
    groupCode = (UBYTE)PARSE_ReadSignedLongSkipClass3_Alt(parseBuf);
    src += 3;

    STRING_CopyPadNul(parseBuf, src, 2);
    parseBuf[2] = '\0';
    parsedLength = PARSE_ReadSignedLongSkipClass3_Alt(parseBuf);
    src += 2;

    if (groupCode == TEXTDISP_PrimaryGroupCode) {
        slot = 0;
    } else if (groupCode == TEXTDISP_SecondaryGroupCode) {
        slot = 1;
    } else {
        slot = 2;
    }

    if (slot != 2) {
        slotPtr = (slot == 0) ? &P_TYPE_PrimaryGroupListPtr : &P_TYPE_SecondaryGroupListPtr;
        P_TYPE_FreeEntry(*slotPtr);
        *slotPtr = P_TYPE_AllocateEntry(groupCode, (LONG)(WORD)parsedLength, (UBYTE *)src);
        result = 1;
    }

    return result;
}
