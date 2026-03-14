#include <exec/types.h>
typedef struct DISKIO2_Entry {
    UBYTE pad0[27];
    UBYTE flags27;
} DISKIO2_Entry;

typedef struct DISKIO2_TitleData {
    UBYTE pad0[7];
    UBYTE slotFlags[49];
    const char *slotTextTable[49];
} DISKIO2_TitleData;

extern char *STR_FindCharPtr(const char *text, long ch);
extern char *STR_FindAnyCharPtr(const char *text, const char *charMask);

extern const char NEWGRID_EntrySplitDelimiterMask[];

char *DISKIO2_CopyAndSanitizeSlotString(
    char *dst,
    const char *entryData,
    const char *titleData,
    UWORD slotIndex)
{
    const DISKIO2_Entry *entryView;
    const DISKIO2_TitleData *titleView;
    const char *src;
    char *dstStart;
    char *cutPos;

    dstStart = dst;
    src = (const char *)0;
    if (entryData == 0 || titleData == 0 || (WORD)slotIndex <= 0 || slotIndex >= 49U) {
        return (char *)src;
    }
    titleView = (const DISKIO2_TitleData *)titleData;
    src = titleView->slotTextTable[(ULONG)slotIndex];
    if (src == 0 || src[0] == 0) {
        return (char *)src;
    }

    entryView = (const DISKIO2_Entry *)entryData;
    if ((titleView->slotFlags[slotIndex] & 0x02U) == 0) {
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

    cutPos = STR_FindCharPtr(dstStart, 34L);
    if (cutPos != 0) {
        cutPos = STR_FindCharPtr(cutPos + 1, 34L);
    }
    if (cutPos != 0) {
        char *delimPos = STR_FindAnyCharPtr(
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
