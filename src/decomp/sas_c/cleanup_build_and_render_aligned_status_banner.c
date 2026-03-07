typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

enum {
    CLOCK_TEMPLATE_TOKEN_F = 'F',
    CLOCK_TEMPLATE_TOKEN_O = 'O'
};

extern const UBYTE CLOCK_STR_TEMPLATE_CODE_SET_FGN[];

UBYTE *GROUP_AI_JMPTBL_STR_FindCharPtr(const UBYTE *s, LONG c);
LONG GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible(LONG match_idx, LONG clock_idx, UBYTE *out, LONG alt);
void CLEANUP_BuildAlignedStatusLine(UBYTE *out, UWORD isPrimary, UWORD modeSel, UWORD slot, LONG alignToken);
LONG CLEANUP_ParseAlignedListingBlock(UBYTE *dst, const UBYTE *src);
void CLEANUP_UpdateEntryFlagBytes(void *entry, UWORD slot);
void CLEANUP_FormatEntryStringTokens(void **field_a, void **field_b, UBYTE *input);
void CLEANUP_DrawInsetRectFrame(void);
LONG GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(void);
LONG GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition(void);

void CLEANUP_BuildAndRenderAlignedStatusBanner(UWORD sourceMode, UWORD modeSel, UWORD slot)
{
    const UBYTE CH_NUL = 0;
    const LONG MATCH_IDX_DEFAULT = 0;
    const LONG CLOCK_IDX_DEFAULT = 0;
    const LONG ALT_STYLE_DEFAULT = 0;
    const LONG ALT_STYLE_ALT = 1;
    const LONG ALIGN_TOKEN_DEFAULT = 0;
    UBYTE statusLineBuffer[560];
    UBYTE clockBuffer[64];
    UBYTE altClockBuffer[64];
    UBYTE parsedStatusBuffer[256];
    UBYTE *fieldA;
    UBYTE *fieldB;

    statusLineBuffer[0] = CH_NUL;
    clockBuffer[0] = CH_NUL;
    altClockBuffer[0] = CH_NUL;
    parsedStatusBuffer[0] = CH_NUL;

    if (GROUP_AI_JMPTBL_STR_FindCharPtr(CLOCK_STR_TEMPLATE_CODE_SET_FGN, CLOCK_TEMPLATE_TOKEN_F) != (UBYTE *)0) {
        GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible(
            MATCH_IDX_DEFAULT, CLOCK_IDX_DEFAULT, clockBuffer, ALT_STYLE_DEFAULT);
    }
    if (GROUP_AI_JMPTBL_STR_FindCharPtr(CLOCK_STR_TEMPLATE_CODE_SET_FGN, CLOCK_TEMPLATE_TOKEN_O) != (UBYTE *)0) {
        GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible(
            MATCH_IDX_DEFAULT, CLOCK_IDX_DEFAULT, altClockBuffer, ALT_STYLE_ALT);
    }

    CLEANUP_BuildAlignedStatusLine(statusLineBuffer, sourceMode, modeSel, slot, ALIGN_TOKEN_DEFAULT);

    CLEANUP_ParseAlignedListingBlock(parsedStatusBuffer, statusLineBuffer);

    CLEANUP_UpdateEntryFlagBytes((void *)statusLineBuffer, slot);

    fieldA = (UBYTE *)CH_NUL;
    fieldB = (UBYTE *)CH_NUL;
    CLEANUP_FormatEntryStringTokens((void **)&fieldA, (void **)&fieldB, parsedStatusBuffer);

    CLEANUP_DrawInsetRectFrame();
    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort();
    GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition();
}

void CLEANUP_RenderAlignedStatusScreen(UWORD sourceMode, UWORD modeSel, UWORD slot)
{
    CLEANUP_BuildAndRenderAlignedStatusBanner(sourceMode, modeSel, slot);
}
