typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

enum {
    CLOCK_TEMPLATE_TOKEN_F = 'F',
    CLOCK_TEMPLATE_TOKEN_O = 'O'
};

extern const char CLOCK_STR_TEMPLATE_CODE_SET_FGN[];

char *GROUP_AI_JMPTBL_STR_FindCharPtr(const char *s, LONG c);
LONG GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible(LONG match_idx, LONG clock_idx, char *out, LONG alt);
void CLEANUP_BuildAlignedStatusLine(char *out, UWORD isPrimary, UWORD modeSel, UWORD slot, LONG alignToken);
LONG CLEANUP_ParseAlignedListingBlock(char *dst, const char *src);
void CLEANUP_UpdateEntryFlagBytes(void *entry, UWORD slot);
void CLEANUP_FormatEntryStringTokens(void **field_a, void **field_b, char *input);
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
    char statusLineBuffer[560];
    char clockBuffer[64];
    char altClockBuffer[64];
    char parsedStatusBuffer[256];
    char *fieldA;
    char *fieldB;

    statusLineBuffer[0] = CH_NUL;
    clockBuffer[0] = CH_NUL;
    altClockBuffer[0] = CH_NUL;
    parsedStatusBuffer[0] = CH_NUL;

    if (GROUP_AI_JMPTBL_STR_FindCharPtr(CLOCK_STR_TEMPLATE_CODE_SET_FGN, CLOCK_TEMPLATE_TOKEN_F) != 0) {
        GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible(
            MATCH_IDX_DEFAULT, CLOCK_IDX_DEFAULT, clockBuffer, ALT_STYLE_DEFAULT);
    }
    if (GROUP_AI_JMPTBL_STR_FindCharPtr(CLOCK_STR_TEMPLATE_CODE_SET_FGN, CLOCK_TEMPLATE_TOKEN_O) != 0) {
        GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible(
            MATCH_IDX_DEFAULT, CLOCK_IDX_DEFAULT, altClockBuffer, ALT_STYLE_ALT);
    }

    CLEANUP_BuildAlignedStatusLine(statusLineBuffer, sourceMode, modeSel, slot, ALIGN_TOKEN_DEFAULT);

    CLEANUP_ParseAlignedListingBlock(parsedStatusBuffer, statusLineBuffer);

    CLEANUP_UpdateEntryFlagBytes((void *)statusLineBuffer, slot);

    fieldA = 0;
    fieldB = 0;
    CLEANUP_FormatEntryStringTokens((void **)&fieldA, (void **)&fieldB, parsedStatusBuffer);

    CLEANUP_DrawInsetRectFrame();
    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort();
    GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition();
}

void CLEANUP_RenderAlignedStatusScreen(UWORD sourceMode, UWORD modeSel, UWORD slot)
{
    CLEANUP_BuildAndRenderAlignedStatusBanner(sourceMode, modeSel, slot);
}
