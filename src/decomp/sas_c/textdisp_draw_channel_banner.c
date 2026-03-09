typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD TEXTDISP_CurrentMatchIndex;
extern WORD TEXTDISP_ActiveGroupId;
extern WORD TEXTDISP_LinePenOverrideEnabledFlag;
extern WORD TEXTDISP_LinePenOverrideStateWord;
extern LONG WDISP_DisplayContextBase;
extern char TEXTDISP_EntryShortNameScratch[];
extern char TEXTDISP_ChannelLabelBuffer[];
extern char *Global_REF_RASTPORT_2;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern char *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern void TEXTDISP_BuildEntryShortName(char *entry, char *out);
extern void TEXTDISP_BuildChannelLabel(WORD includeOnPrefix);
extern void TEXTDISP_TrimTextToPixelWidth(char *text, LONG maxWidth);
extern void TEXTDISP_DrawInsetRectFrame(char *text, LONG drawMode);
extern LONG _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);

typedef struct TEXTDISP_DisplayContext {
    UBYTE pad0[2];
    WORD widthWord2;
    UBYTE rastPortTail[1];
} TEXTDISP_DisplayContext;

void TEXTDISP_DrawChannelBanner(WORD mode, WORD drawMode)
{
    TEXTDISP_DisplayContext *context;
    char *entry;
    char *src;
    char *dst;
    char *rastPort;
    LONG trimWidth;

    context = (TEXTDISP_DisplayContext *)WDISP_DisplayContextBase;

    entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(
        (LONG)TEXTDISP_CurrentMatchIndex,
        (TEXTDISP_ActiveGroupId == 0) ? 2 : 1);

    TEXTDISP_BuildEntryShortName(entry, TEXTDISP_EntryShortNameScratch);

    src = TEXTDISP_EntryShortNameScratch;
    dst = TEXTDISP_ChannelLabelBuffer;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    TEXTDISP_BuildChannelLabel(1);

    TEXTDISP_LinePenOverrideStateWord = 0;
    if (drawMode == 3) {
        rastPort = Global_REF_RASTPORT_2;
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    } else {
        rastPort = (char *)&context->widthWord2;
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    }

    TEXTDISP_LinePenOverrideEnabledFlag = 1;

    trimWidth = (LONG)context->widthWord2;
    if (mode == 2) {
        if (trimWidth < 0) {
            ++trimWidth;
        }
        trimWidth >>= 1;
    }

    TEXTDISP_TrimTextToPixelWidth(TEXTDISP_ChannelLabelBuffer, trimWidth);
    TEXTDISP_DrawInsetRectFrame(TEXTDISP_ChannelLabelBuffer, (LONG)drawMode);

    if (drawMode == 3) {
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, 1);
    } else {
        _LVOSetDrMd(
            Global_REF_GRAPHICS_LIBRARY,
            (char *)&context->widthWord2,
            1);
    }
}
