typedef unsigned char UBYTE;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

typedef struct DISKIO2_Entry {
    UBYTE pad0[27];
    UBYTE flags27;
} DISKIO2_Entry;

typedef struct DISKIO2_AuxData {
    UBYTE pad0[7];
    UBYTE slotFlags[49];
    UBYTE pad1[0x38 - 0x38];
    const char *slotTextTable[49];
} DISKIO2_AuxData;

extern char *GROUP_AI_JMPTBL_STR_FindCharPtr(const char *text, long ch);
extern char *GROUP_AH_JMPTBL_STR_FindAnyCharPtr(const char *text, const char *charMask);

extern const char NEWGRID_EntrySplitDelimiterMask[];

char *DISKIO2_CopyAndSanitizeSlotString(
    char *dst,
    const UBYTE *flags,
    const UBYTE *entryTable,
    UWORD slotIndex)
{
    const DISKIO2_Entry *entryView;
    const DISKIO2_AuxData *auxView;
    const char *src;
    char *dstStart;
    char *cutPos;

    dstStart = dst;
    auxView = (const DISKIO2_AuxData *)entryTable;
    src = auxView->slotTextTable[(ULONG)slotIndex];
    if (flags == 0 || entryTable == 0 || (WORD)slotIndex <= 0 || slotIndex >= 49U) {
        return (char *)src;
    }
    if (src == 0 || src[0] == 0) {
        return (char *)src;
    }

    entryView = (const DISKIO2_Entry *)flags;
    if ((auxView->slotFlags[slotIndex] & 0x02U) == 0) {
        if ((entryView->flags27 & 0x10U) == 0) {
            return (char *)src;
        }
    }

    while (*src != 0) {
        *dst = *src;
        dst++;
        src++;
    }
    *dst = 0;

    cutPos = GROUP_AI_JMPTBL_STR_FindCharPtr(dstStart, 34L);
    if (cutPos != 0) {
        cutPos = GROUP_AI_JMPTBL_STR_FindCharPtr(cutPos + 1, 34L);
    }
    if (cutPos != 0) {
        char *delimPos = GROUP_AH_JMPTBL_STR_FindAnyCharPtr(
            cutPos,
            NEWGRID_EntrySplitDelimiterMask);
        if (delimPos != 0) {
            cutPos = delimPos;
        }

        while (*cutPos != 0 && *cutPos != ' ') {
            cutPos++;
        }
        *cutPos = 0;
    }

    return dstStart;
}
