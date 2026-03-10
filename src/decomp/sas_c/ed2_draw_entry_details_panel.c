typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct ED2_Entry {
    UBYTE pad0[1];
    UBYTE channelText[18];
    UBYTE callLetters[1];
} ED2_Entry;

typedef struct ED2_TitleData {
    UBYTE pad0[7];
    UBYTE slotFlags[49];
} ED2_TitleData;

typedef struct ED2_DisplayContext {
    UBYTE pad0[2];
    UBYTE rastPort[1];
} ED2_DisplayContext;

extern UWORD ED2_SelectedEntryIndex;
extern UWORD ED2_SelectedFlagByteOffset;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE *ED2_SelectedEntryDataPtr;
extern UBYTE *ED2_SelectedEntryTitlePtr;
extern char *TEXTDISP_PrimaryTitlePtrTable[];
extern LONG WDISP_DisplayContextBase;

extern const char Global_STR_ED2_C_1[];
extern const char Global_STR_ED2_C_2[];
extern const char Global_STR_PI_CLU_POS1[];
extern const char Global_STR_CHAN_SOURCE_CALLLTRS_1[];
extern const char Global_STR_TS_TITLE_TIME[];
extern const char ED2_STR_NullFallbackChannel[];
extern const char ED2_STR_NullFallbackSource[];
extern const char ED2_STR_NullFallbackCallLetters[];
extern const char ED2_STR_NullFallbackTitle[];
extern const char ED2_STR_NONE_ProgramFlagSummary[];
extern const char ED2_STR_MOVIE[];
extern const char ED2_STR_ALTHILITEPROG[];
extern const char ED2_STR_TAGPROG[];
extern const char ED2_STR_SPORTSPROG[];
extern const char ED2_STR_DVIEW_USED[];
extern const char ED2_STR_REPEATPROG[];
extern const char ED2_STR_PREVDAYSDATA[];

extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(const char *tag, LONG pool, LONG size, LONG flags);
extern void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(const char *tag, LONG pool, void *ptr, LONG size);
extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(char *rastPort, char *text, LONG y);
extern char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);
extern UBYTE *DISKIO2_CopyAndSanitizeSlotString(UBYTE *buf, UBYTE *entryData, UBYTE *titlePtr, LONG slot);
extern void GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex(char *dst, LONG slot, UBYTE *titlePtr);

void ED2_DrawEntryDetailsPanel(void)
{
    char panelTextBuffer[120];
    char timeBuf[20];
    ED2_DisplayContext *context;
    UBYTE *scratch;
    ED2_Entry *entry;
    ED2_TitleData *title;
    UBYTE *chan;
    UBYTE *src;
    UBYTE *calls;
    UBYTE *safeTitle;
    char *rastPort;
    UBYTE flags;

    if (ED2_SelectedEntryIndex >= TEXTDISP_PrimaryGroupEntryCount || (LONG)(short)ED2_SelectedEntryIndex < 0) {
        ED2_SelectedEntryTitlePtr = (UBYTE *)0;
        ED2_SelectedEntryIndex = 0;
    } else {
        ED2_SelectedEntryTitlePtr = (UBYTE *)TEXTDISP_PrimaryTitlePtrTable[ED2_SelectedEntryIndex];
    }

    if (ED2_SelectedEntryTitlePtr == (UBYTE *)0 || ED2_SelectedEntryDataPtr == (UBYTE *)0) {
        return;
    }

    scratch = (UBYTE *)ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_STR_ED2_C_1, 1000, 374, 3);
    context = (ED2_DisplayContext *)WDISP_DisplayContextBase;
    rastPort = (char *)context->rastPort;

    if (ED2_SelectedFlagByteOffset < 1 || ED2_SelectedFlagByteOffset > 48) {
        ED2_SelectedFlagByteOffset = 1;
    }

    ED2_SelectedEntryTitlePtr = (UBYTE *)TEXTDISP_PrimaryTitlePtrTable[ED2_SelectedEntryIndex];

    GROUP_AM_JMPTBL_WDISP_SPrintf(panelTextBuffer, Global_STR_PI_CLU_POS1,
                                  (LONG)ED2_SelectedEntryIndex,
                                  (LONG)TEXTDISP_PrimaryGroupEntryCount);
    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(rastPort, panelTextBuffer, 90);

    entry = (ED2_Entry *)ED2_SelectedEntryDataPtr;
    chan = (entry != (ED2_Entry *)0) ? entry->channelText : (UBYTE *)ED2_STR_NullFallbackChannel;
    src = (ED2_SelectedEntryTitlePtr != (UBYTE *)0) ? ED2_SelectedEntryTitlePtr : (UBYTE *)ED2_STR_NullFallbackSource;
    calls = (entry != (ED2_Entry *)0) ? entry->callLetters : (UBYTE *)ED2_STR_NullFallbackCallLetters;

    GROUP_AM_JMPTBL_WDISP_SPrintf(panelTextBuffer, Global_STR_CHAN_SOURCE_CALLLTRS_1,
                                  chan, src, calls);
    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(rastPort, panelTextBuffer, 120);

    safeTitle = DISKIO2_CopyAndSanitizeSlotString(scratch, ED2_SelectedEntryDataPtr, ED2_SelectedEntryTitlePtr,
                                                  (LONG)ED2_SelectedFlagByteOffset);
    if (safeTitle != (UBYTE *)0) {
        GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex(timeBuf, (LONG)ED2_SelectedFlagByteOffset,
                                                         ED2_SelectedEntryTitlePtr);
    } else {
        timeBuf[0] = 0;
        safeTitle = (UBYTE *)ED2_STR_NullFallbackTitle;
    }

    GROUP_AM_JMPTBL_WDISP_SPrintf(panelTextBuffer, Global_STR_TS_TITLE_TIME,
                                  (LONG)ED2_SelectedFlagByteOffset,
                                  safeTitle,
                                  timeBuf);
    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(rastPort, panelTextBuffer, 150);

    panelTextBuffer[0] = 0;
    title = (ED2_TitleData *)(ED2_SelectedEntryTitlePtr + (LONG)ED2_SelectedFlagByteOffset);
    flags = title->slotFlags[0];
    if ((flags & (1u << 0)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_NONE_ProgramFlagSummary);
    if ((flags & (1u << 1)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_MOVIE);
    if ((flags & (1u << 2)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_ALTHILITEPROG);
    if ((flags & (1u << 3)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_TAGPROG);
    if ((flags & (1u << 4)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_SPORTSPROG);
    if ((flags & (1u << 5)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_DVIEW_USED);
    if ((flags & (1u << 6)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_REPEATPROG);
    if ((flags & (1u << 7)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_PREVDAYSDATA);
    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(rastPort, panelTextBuffer, 210);

    ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ED2_C_2, 427, scratch, 1000);
}
