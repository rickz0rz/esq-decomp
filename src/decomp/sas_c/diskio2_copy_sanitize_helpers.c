typedef unsigned char UBYTE;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern char *GROUP_AI_JMPTBL_STR_FindCharPtr(const char *text, long ch);
extern char *GROUP_AH_JMPTBL_STR_FindAnyCharPtr(const char *text, const char *charMask);

extern const char NEWGRID_EntrySplitDelimiterMask[];

char *DISKIO2_CopyAndSanitizeSlotString(
    char *dst,
    const UBYTE *flags,
    const UBYTE *entryTable,
    UWORD slotIndex)
{
    const char *src;
    char *dstStart;
    char *cutPos;

    dstStart = dst;
    src = ((const char *const *)(entryTable + 56UL))[(ULONG)slotIndex];
    if (flags == 0 || entryTable == 0 || (WORD)slotIndex <= 0 || slotIndex >= 49U) {
        return (char *)src;
    }
    if (src == 0 || src[0] == 0) {
        return (char *)src;
    }

    if ((entryTable[7U + slotIndex] & 0x02U) == 0) {
        if ((flags[27] & 0x10U) == 0) {
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
