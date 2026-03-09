typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Font {
    UBYTE pad0[26];
    WORD ySize;
} NEWGRID_Font;

typedef struct NEWGRID_RastPort {
    UBYTE pad0[52];
    NEWGRID_Font *font;
} NEWGRID_RastPort;

typedef struct NEWGRID_Context {
    UBYTE pad0[32];
    LONG selectedState;
    UBYTE pad1[18];
    WORD selectionCode;
    UBYTE pad2[6];
    NEWGRID_RastPort rastPort;
} NEWGRID_Context;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern UBYTE *SCRIPT_PtrSportsOnPrefix;
extern UBYTE *SCRIPT_PtrSummaryOfPrefix;
extern UBYTE *SCRIPT_PtrChannelSuffix;
extern WORD Global_WORD_SELECT_CODE_IS_RAVESC;
extern UBYTE NEWGRID_ShowtimeRangeDash[];
extern WORD NEWGRID_RowHeightPx;
extern WORD NEWGRID_ColumnStartXPx;
extern WORD NEWGRID_ColumnWidthPx;

extern UBYTE *NEWGRID2_JMPTBL_STR_SkipClass3Chars(UBYTE *s);
extern void NEWGRID2_JMPTBL_STRING_AppendN(UBYTE *dst, UBYTE *src, LONG len);
extern void PARSEINI_JMPTBL_STRING_AppendAtNull(UBYTE *dst, UBYTE *src);
extern void NEWGRID_DrawGridFrame(void *rp, LONG type, LONG penA, LONG penB, LONG height);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rp, LONG x, LONG y, LONG width, LONG color, LONG style);
extern LONG _LVOSetAPen(void *gfxBase, void *rp, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, void *rp, LONG mode);
extern LONG _LVOTextLength(void *gfxBase, void *rp, UBYTE *text, LONG len);
extern LONG _LVOMove(void *gfxBase, void *rp, LONG x, LONG y);
extern LONG _LVOText(void *gfxBase, void *rp, UBYTE *text, LONG len);
extern void NEWGRID_ValidateSelectionCode(void *rp, LONG code);

void NEWGRID_DrawShowtimesPrompt(UBYTE *rpCtx, UBYTE *outBuf, LONG mode)
{
    NEWGRID_Context *ctx;
    UBYTE prompt[136];
    UBYTE tmpSuffix[10];
    UBYTE *titlePart;
    UBYTE *channelPart;
    UBYTE *src;
    UBYTE *dst;
    NEWGRID_RastPort *rp;
    LONG len;
    LONG x;
    LONG y;
    LONG width;

    if (outBuf == 0) {
        return;
    }

    ctx = (NEWGRID_Context *)rpCtx;
    titlePart = NEWGRID2_JMPTBL_STR_SkipClass3Chars(outBuf + 19);
    channelPart = NEWGRID2_JMPTBL_STR_SkipClass3Chars(outBuf + 1);

    src = (mode == 0) ? SCRIPT_PtrSummaryOfPrefix : SCRIPT_PtrSportsOnPrefix;
    dst = prompt;
    while ((*dst++ = *src++) != 0) {
    }

    len = 0;
    src = titlePart;
    while (*src++ != 0) {
        len++;
    }
    NEWGRID2_JMPTBL_STRING_AppendN(prompt, titlePart, len);

    if (channelPart != 0 && channelPart[0] != 0) {
        PARSEINI_JMPTBL_STRING_AppendAtNull(prompt, SCRIPT_PtrChannelSuffix);
        if (Global_WORD_SELECT_CODE_IS_RAVESC != 0) {
            src = channelPart;
            dst = tmpSuffix;
            while ((*dst++ = *src++) != 0) {
            }
            tmpSuffix[2] = 0;
            PARSEINI_JMPTBL_STRING_AppendAtNull(prompt, tmpSuffix);
            PARSEINI_JMPTBL_STRING_AppendAtNull(prompt, NEWGRID_ShowtimeRangeDash);
            PARSEINI_JMPTBL_STRING_AppendAtNull(prompt, channelPart + 2);
        } else {
            PARSEINI_JMPTBL_STRING_AppendAtNull(prompt, channelPart);
        }
    }

    rp = &ctx->rastPort;
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 6);
    NEWGRID_DrawGridFrame(rpCtx, 7, 6, 6, (LONG)NEWGRID_RowHeightPx + 3);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rp, (LONG)NEWGRID_ColumnStartXPx + 35, 33, 0, (LONG)33, 0);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rp, (LONG)NEWGRID_ColumnStartXPx + 36, 0, 695, 33, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 3);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rp, 0);

    len = 0;
    while (prompt[len] != 0) {
        len++;
    }

    width = (LONG)((unsigned short)NEWGRID_ColumnWidthPx) * 3;
    x = (LONG)NEWGRID_ColumnStartXPx + ((width - _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp, prompt, len)) >> 1) + 36;

    y = ((((LONG)34 - (LONG)rp->font->ySize) >> 1) + (LONG)rp->font->ySize) - 1;
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, prompt, len);

    ctx->selectionCode = 17;
    ctx->selectedState = 17;
    NEWGRID_ValidateSelectionCode(rpCtx, 67);
}
