typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD TEXTDISP_CurrentMatchIndex;
extern WORD TEXTDISP_ActiveGroupId;
extern WORD TEXTDISP_LinePenOverrideEnabledFlag;
extern WORD TEXTDISP_LinePenOverrideStateWord;
extern LONG WDISP_DisplayContextBase;
extern UBYTE TEXTDISP_EntryShortNameScratch[];
extern UBYTE TEXTDISP_ChannelLabelBuffer[];
extern void *Global_REF_RASTPORT_2;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern void TEXTDISP_BuildEntryShortName(UBYTE *entry, UBYTE *out);
extern void TEXTDISP_BuildChannelLabel(WORD includeOnPrefix);
extern void TEXTDISP_TrimTextToPixelWidth(UBYTE *text, LONG maxWidth);
extern void TEXTDISP_DrawInsetRectFrame(UBYTE *text, LONG drawMode);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);

void TEXTDISP_DrawChannelBanner(WORD mode, WORD drawMode)
{
    UBYTE *entry;
    UBYTE *src;
    UBYTE *dst;
    void *rastPort;
    LONG trimWidth;

    entry = (UBYTE *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(
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
        rastPort = (void *)((UBYTE *)WDISP_DisplayContextBase + 2);
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    }

    TEXTDISP_LinePenOverrideEnabledFlag = 1;

    trimWidth = (LONG)*(WORD *)((UBYTE *)WDISP_DisplayContextBase + 2);
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
            (void *)((UBYTE *)WDISP_DisplayContextBase + 2),
            1);
    }
}
