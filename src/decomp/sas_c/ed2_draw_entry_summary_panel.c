typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct ED2_Entry {
    UBYTE pad0[1];
    UBYTE titleText[11];
    UBYTE aliasText[7];
    UBYTE channelText[8];
    UBYTE flags27;
    UBYTE pad1[18];
    UWORD flags46;
} ED2_Entry;

typedef struct ED2_DisplayContext {
    UBYTE pad0[2];
    UBYTE rastPort[1];
} ED2_DisplayContext;

extern UWORD ED2_SelectedEntryIndex;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE *ED2_SelectedEntryDataPtr;
extern UBYTE *ED2_SelectedEntryTitlePtr;
extern UWORD ED2_SelectedFlagByteOffset;
extern ED2_Entry *TEXTDISP_PrimaryEntryPtrTable[];
extern LONG WDISP_DisplayContextBase;

extern const char Global_STR_CLU_CLU_POS1[];
extern const char Global_STR_CHAN_SOURCE_CALLLTRS_2[];
extern const char ED2_STR_NONE_SourceFlagSummary[];
extern const char ED2_STR_HILITESRC[];
extern const char ED2_STR_SUMBYSRC[];
extern const char ED2_STR_VIDEO_TAG_DISABLE[];
extern const char ED2_STR_CAF_PPVSRC[];
extern const char ED2_STR_DITTO[];
extern const char ED2_STR_ALTHILITESRC[];
extern const char ED2_STR_STEREO[];
extern const char ED2_STR_GRID[];
extern const char ED2_STR_MR[];
extern const char ED2_STR_DNICHE[];
extern const char ED2_STR_DMPLEX[];
extern const char ED2_STR_CF2_DPPV[];

extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(char *rastPort, const char *text, LONG y);
extern char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);

void ED2_DrawEntrySummaryPanel(void)
{
    char panelTextBuffer[120];
    ED2_DisplayContext *context;
    ED2_Entry *entry;
    char *rastPort;
    UWORD flags8;
    UWORD flags16;

    if (ED2_SelectedEntryIndex >= TEXTDISP_PrimaryGroupEntryCount) {
        ED2_SelectedEntryIndex = 0;
    }

    if ((LONG)(short)ED2_SelectedEntryIndex < 0) {
        ED2_SelectedEntryIndex = 0;
    }

    if (TEXTDISP_PrimaryGroupEntryCount == 0) {
        ED2_SelectedEntryDataPtr = (UBYTE *)0;
        ED2_SelectedEntryTitlePtr = (UBYTE *)0;
    } else {
        ED2_SelectedEntryDataPtr = (UBYTE *)TEXTDISP_PrimaryEntryPtrTable[ED2_SelectedEntryIndex];
        ED2_SelectedFlagByteOffset = 0;
    }

    entry = (ED2_Entry *)ED2_SelectedEntryDataPtr;
    if (entry == (ED2_Entry *)0) {
        return;
    }

    context = (ED2_DisplayContext *)WDISP_DisplayContextBase;
    rastPort = (char *)context->rastPort;

    GROUP_AM_JMPTBL_WDISP_SPrintf(panelTextBuffer, Global_STR_CLU_CLU_POS1,
                                  (LONG)ED2_SelectedEntryIndex,
                                  (LONG)TEXTDISP_PrimaryGroupEntryCount);
    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(rastPort, panelTextBuffer, 120);

    GROUP_AM_JMPTBL_WDISP_SPrintf(panelTextBuffer, Global_STR_CHAN_SOURCE_CALLLTRS_2,
                                  (char *)entry->titleText,
                                  (char *)entry->aliasText,
                                  (char *)entry->channelText);
    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(rastPort, panelTextBuffer, 150);

    panelTextBuffer[0] = 0;
    flags8 = (UWORD)entry->flags27;
    if ((flags8 & (1u << 0)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_NONE_SourceFlagSummary);
    if ((flags8 & (1u << 1)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_HILITESRC);
    if ((flags8 & (1u << 2)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_SUMBYSRC);
    if ((flags8 & (1u << 3)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_VIDEO_TAG_DISABLE);
    if ((flags8 & (1u << 4)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_CAF_PPVSRC);
    if ((flags8 & (1u << 5)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_DITTO);
    if ((flags8 & (1u << 6)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_ALTHILITESRC);
    if ((flags8 & (1u << 7)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_STEREO);
    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(rastPort, panelTextBuffer, 180);

    panelTextBuffer[0] = 0;
    flags16 = entry->flags46;
    if ((flags16 & (1u << 0)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_GRID);
    if ((flags16 & (1u << 1)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_MR);
    if ((flags16 & (1u << 2)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_DNICHE);
    if ((flags16 & (1u << 3)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_DMPLEX);
    if ((flags16 & (1u << 4)) != 0) GROUP_AI_JMPTBL_STRING_AppendAtNull(panelTextBuffer, ED2_STR_CF2_DPPV);
    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(rastPort, panelTextBuffer, 210);
}
