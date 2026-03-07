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
    UBYTE status[560];
    UBYTE clock_buf[64];
    UBYTE alt_buf[64];
    UBYTE parse_buf[256];
    UBYTE *fieldA;
    UBYTE *fieldB;

    status[0] = 0;
    clock_buf[0] = 0;
    alt_buf[0] = 0;
    parse_buf[0] = 0;

    if (GROUP_AI_JMPTBL_STR_FindCharPtr(CLOCK_STR_TEMPLATE_CODE_SET_FGN, CLOCK_TEMPLATE_TOKEN_F) != (UBYTE *)0) {
        GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible(0, 0, clock_buf, 0);
    }
    if (GROUP_AI_JMPTBL_STR_FindCharPtr(CLOCK_STR_TEMPLATE_CODE_SET_FGN, CLOCK_TEMPLATE_TOKEN_O) != (UBYTE *)0) {
        GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible(0, 0, alt_buf, 1);
    }

    CLEANUP_BuildAlignedStatusLine(status, sourceMode, modeSel, slot, 0);

    CLEANUP_ParseAlignedListingBlock(parse_buf, status);

    CLEANUP_UpdateEntryFlagBytes((void *)status, slot);

    fieldA = (UBYTE *)0;
    fieldB = (UBYTE *)0;
    CLEANUP_FormatEntryStringTokens((void **)&fieldA, (void **)&fieldB, parse_buf);

    CLEANUP_DrawInsetRectFrame();
    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort();
    GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition();
}

void CLEANUP_RenderAlignedStatusScreen(UWORD sourceMode, UWORD modeSel, UWORD slot)
{
    CLEANUP_BuildAndRenderAlignedStatusBanner(sourceMode, modeSel, slot);
}
