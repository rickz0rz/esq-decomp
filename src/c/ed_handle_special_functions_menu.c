/* RESTORES: ED_HandleSpecialFunctionsMenu
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 * OPTIONS:  SHORTINT
 *
 * 656 bytes in the original, 640 emitted. The structure reproduces exactly: the
 * eight-entry PC-relative jump table (000e 0016 0042 006e 009a .. 0100 00de),
 * the dispatch (ADD.W D0,D0 / MOVE.W table(PC,D0.W),D0 / JMP table+2(PC,D0.W)),
 * all eight case bodies, the case-6 fall-through into the default, and the whole
 * unrolled colour-bar block including the MOVE.L D2,D0 that carries each bar's
 * right edge into the next bar's left edge.
 *
 * NOTE: requires SHORTINT. Without it the switch selector is widened with an
 * extra EXT.L and compared with CMPI.L #8; with it the prologue is byte-identical
 * to the original's 2E00 1007 4880 0C40 0008.
 *
 * Every residual difference is a divergence class already recorded elsewhere,
 * and together they account for the size delta exactly:
 *
 * SASC-MISMATCH: constant-via-moveq-shift
 *   ref:     223c00000148                MOVE.L #328,D1
 *   got:     7252e589                    MOVEQ #82,D1 / ASL.L #2,D1
 *   summary: 328 as 82<<2, 340 as 85<<2, 640 as 80<<3. Eight sites in this
 *            function, each saving two bytes -- which is the entire 16-byte
 *            difference between 656 and 640. Nothing else is missing.
 *   scope:   every large constant with a small odd mantissa, program-wide.
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     4eba222c                    JSR (d16,PC)
 *   got:     61000000                    BSR.W
 *   summary: All twelve calls here were cross-unit in the original. Our
 *            one-function-per-file layout also makes them cross-unit, so this
 *            function is pre-positioned to match once the compiler emits 4EBA.
 *            See docs/compiler-version.md.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     48e73100 .. 4cdf008c
 *   got:     48e73102 .. 4cdf408c
 *   summary: SAS/C adds A6 to the MOVEM masks; the original treats it as scratch
 *            across the graphics.library calls.
 */
#include "esq-graphics.h"

extern long ED_GetEscMenuActionCode(void);
extern void ED_DrawESCMenuBottomHelp(void);
extern void ED_DrawAreYouSurePrompt(void);
extern void ED_DrawMenuSelectionHighlight(long n);
extern void ED_DrawSpecialFunctionsMenu(void);
extern void ED_DrawDiagnosticRegisterValues(void);
extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern struct RastPort *Global_REF_RASTPORT_1;
extern unsigned char ED_MenuStateId;
extern long ED_EditCursorOffset;
extern long ED_TempCopyOffset;
extern char ED2_STR_ALL_DATA_IS_TO_BE_SAVED_DOT[];
extern char ED2_STR_TV_GUIDE_DATA_IS_TO_BE_SAVED_DOT[];
extern char ED2_STR_TEXT_ADS_WILL_BE_LOADED_FROM_DH2_COL[];
extern char Global_STR_COMPUTER_WILL_RESET[];
extern char Global_STR_GO_OFF_AIR_FOR_1_2_MINS[];

void ED_HandleSpecialFunctionsMenu(void)
{
    register char code = (char)ED_GetEscMenuActionCode();

    switch (code) {
    case 0:
        ED_DrawESCMenuBottomHelp();
        break;

    case 1:
        ED_DrawAreYouSurePrompt();
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 90,
                                      ED2_STR_ALL_DATA_IS_TO_BE_SAVED_DOT);
        ED_MenuStateId = 0x0b;
        break;

    case 2:
        ED_DrawAreYouSurePrompt();
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 90,
                                      ED2_STR_TV_GUIDE_DATA_IS_TO_BE_SAVED_DOT);
        ED_MenuStateId = 0x0c;
        break;

    case 3:
        ED_DrawAreYouSurePrompt();
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 90,
                                      ED2_STR_TEXT_ADS_WILL_BE_LOADED_FROM_DH2_COL);
        ED_MenuStateId = 0x0d;
        break;

    case 4:
        ED_DrawAreYouSurePrompt();
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 90,
                                      Global_STR_COMPUTER_WILL_RESET);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 120,
                                      Global_STR_GO_OFF_AIR_FOR_1_2_MINS);
        ED_MenuStateId = 0x0e;
        break;

    case 7:
        if (--ED_EditCursorOffset < 0)
            ED_EditCursorOffset = 3;
        ED_DrawMenuSelectionHighlight(4);
        ED_DrawSpecialFunctionsMenu();
        break;

    case 6:
        if (ED_EditCursorOffset == 2) {
            ED_MenuStateId = 0x0f;
            SetAPen(Global_REF_RASTPORT_1, 0L);
            RectFill(Global_REF_RASTPORT_1,  40L, 328L, 115L, 399L);
            SetAPen(Global_REF_RASTPORT_1, 1L);
            RectFill(Global_REF_RASTPORT_1, 115L, 328L, 190L, 399L);
            SetAPen(Global_REF_RASTPORT_1, 2L);
            RectFill(Global_REF_RASTPORT_1, 190L, 328L, 265L, 399L);
            SetAPen(Global_REF_RASTPORT_1, 3L);
            RectFill(Global_REF_RASTPORT_1, 265L, 328L, 340L, 399L);
            SetAPen(Global_REF_RASTPORT_1, 4L);
            RectFill(Global_REF_RASTPORT_1, 340L, 328L, 415L, 399L);
            SetAPen(Global_REF_RASTPORT_1, 5L);
            RectFill(Global_REF_RASTPORT_1, 415L, 328L, 490L, 399L);
            SetAPen(Global_REF_RASTPORT_1, 6L);
            RectFill(Global_REF_RASTPORT_1, 490L, 328L, 565L, 399L);
            SetAPen(Global_REF_RASTPORT_1, 7L);
            RectFill(Global_REF_RASTPORT_1, 565L, 328L, 640L, 399L);
            ED_TempCopyOffset = 0;
            ED_DrawDiagnosticRegisterValues();
            break;
        }
        /* fall through */

    case 5:
    default:
        ED_EditCursorOffset++;
        if (ED_EditCursorOffset == 4)
            ED_EditCursorOffset = 0;
        ED_DrawMenuSelectionHighlight(4);
        ED_DrawSpecialFunctionsMenu();
        break;
    }
}
