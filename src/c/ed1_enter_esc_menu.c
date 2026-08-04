/* RESTORES: ED1_EnterEscMenu
 * MODULE:   modules/groups/a/k/ed1_p0.s
 * STATUS:   behavioural
 *
 * 456 bytes in the original, 460 emitted, only 14 differing regions -- one of
 * the structurally closest large restorations so far.
 *
 * Reproduces: the flag and saved-char setup, SetFont, the direct assignment of
 * the bitmap into rp->BitMap before InitBitMap is called on it, SetRast/SetDrMd,
 * the drop transition, the 24-byte palette copy loop, the Disable/Enable pair
 * bracketing the serial and banner setup, the two-digit ad-number parse, the
 * TextLimit clamp that also rewrites ED_DiagScrollSpeedChar to '6', the SPrintf
 * of the version banner into the frame, and the vertical centring
 * (34 - tf_Baseline)/2 + tf_Baseline + 33 including the signed-divide idiom.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffd0                   LINK.W A5,#-48
 *   got:     9efc002c                   SUBA.W #44,A7
 *   summary: The original reserves A5 as a frame pointer; SAS/C adjusts A7. This
 *            is the single most diagnostic divergence in the project -- a
 *            compiler that emits LINK.W A5 here also passes the A3 acceptance
 *            test, because they are the same property. See
 *            docs/compiler-version.md.
 *
 * SASC-MISMATCH: multiply-strength-reduction
 *   ref:     720a 4eba7de4              MOVEQ #10,D1 / JSR ESQIFF_JMPTBL_MATH_Mulu32
 *   got:     e582 d480 d482             shift/add chain
 *   summary: Two sites, *10 for the ad number and *40 for the block offset. The
 *            original calls the multiply helper for both.
 *
 * SASC-MISMATCH: constant-via-moveq-shift
 *   ref:     223c000002b8               MOVE.L #696,D1
 *   got:     7257e789                   MOVEQ #87,D1 / ASL.L #3,D1
 *   summary: 696 = 87<<3. Consistent with the rule established in
 *            ed_draw_diagnostic_mode_text.c: the original only ever doubles.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the nine cross-unit calls.
 */
#include "esq-exec.h"
#include "esq-graphics.h"

extern void ESQIFF_RunCopperDropTransition(void);
extern void ESQIFF_RunCopperRiseTransition(void);
extern void ED_DrawESCMenuBottomHelp(void);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(long v);
extern void ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void GCOMMAND_SeedBannerDefaults(void);
extern void CLEANUP_DrawDateTimeBannerRow(void);
extern void WDISP_SPrintf(char *buf, char *fmt, char *s, long v);
extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);

extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap Global_REF_696_400_BITMAP;
extern struct TextFont *Global_HANDLE_H26F_FONT;
extern short Global_UIBusyFlag;
extern short ESQPARS2_ReadModeFlags;
extern short ESQSHARED_BannerColorModeWord;
extern char ED_DiagGraphModeChar[];
extern char ED_SavedDiagGraphModeChar;
extern unsigned char WDISP_PaletteTriplesRBase[];
extern unsigned char KYBD_CustomPaletteTriplesRBase[];
extern unsigned char ESQ_TAG_36[];
extern unsigned char ED_DiagScrollSpeedChar[];
extern long ED_MaxAdNumber;
extern long ED_TextLimit;
extern long ED_BlockOffset;
extern long ED_SaveTextAdsOnExitFlag;
extern long Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern long Global_LONG_PATCH_VERSION_NUMBER;
extern char Global_STR_NINE_POINT_ZERO[];
extern char Global_STR_VER_PERCENT_S_PERCENT_L_D[];

/* The original falls through into this; the tail of the body below is that
 * fall-through written as a call. See the note at the end of the function. */
extern void ED1_EnterEscMenu_AfterVersionText(void);

void ED1_EnterEscMenu(void)
{
    char versionBanner[41];
    register long i;
    struct TextFont *font;
    long y;

    Global_UIBusyFlag = 1;
    ED_SavedDiagGraphModeChar = ED_DiagGraphModeChar[0];
    SetFont(Global_REF_RASTPORT_1, Global_HANDLE_H26F_FONT);
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
    InitBitMap(&Global_REF_696_400_BITMAP, 3L, 696L, 509L);
    SetRast(Global_REF_RASTPORT_1, 2L);
    SetDrMd(Global_REF_RASTPORT_1, 1L);
    ESQIFF_RunCopperDropTransition();

    for (i = 0; i < 24; i++)
        WDISP_PaletteTriplesRBase[i] = KYBD_CustomPaletteTriplesRBase[i];

    Disable();
    ESQPARS2_ReadModeFlags = 0x100;
    ESQSHARED_BannerColorModeWord = 0;
    SCRIPT_UpdateSerialShadowFromCtrlByte(3);
    ESQ_SetCopperEffect_OffDisableHighlight();
    ED_SaveTextAdsOnExitFlag = 0;
    GCOMMAND_SeedBannerDefaults();
    Enable();

    ED_MaxAdNumber = (ESQ_TAG_36[0] - '0') * 10 + ESQ_TAG_36[1] - '0';
    ED_TextLimit = ED_DiagScrollSpeedChar[0] - '0';
    if (ED_TextLimit > 6) {
        ED_TextLimit = 6;
        ED_DiagScrollSpeedChar[0] = '6';
    }
    ED_BlockOffset = ED_TextLimit * 40;
    Global_REF_LONG_CURRENT_EDITING_AD_NUMBER = 1;
    ED_DrawESCMenuBottomHelp();

    WDISP_SPrintf(versionBanner,
                                  Global_STR_VER_PERCENT_S_PERCENT_L_D,
                                  Global_STR_NINE_POINT_ZERO,
                                  Global_LONG_PATCH_VERSION_NUMBER);
    CLEANUP_DrawDateTimeBannerRow();

    SetAPen(Global_REF_RASTPORT_1, 3L);
    SetDrMd(Global_REF_RASTPORT_1, 0L);

    font = Global_REF_RASTPORT_1->Font;
    y = (34 - font->tf_Baseline) / 2 + font->tf_Baseline + 33;
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 280, y, versionBanner);

    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetDrMd(Global_REF_RASTPORT_1, 1L);
    ESQIFF_RunCopperRiseTransition();

    /* THE ORIGINAL FALLS THROUGH HERE. There is no branch and no return: the
     * copper rise is the last instruction before the
     * _ED1_EnterEscMenu_AfterVersionText label, and execution simply carries
     * on into it and out through the epilogue the two share.
     *
     * This call is that fall-through, written down. It is what makes the
     * module mergeable -- as two independent C functions the filter-cursor
     * reset would never run on the ESC-menu path, silently, which is the case
     * merge_module_c.py's fall-through check exists to catch. The check now
     * accepts the module because this call is the LAST statement here; a call
     * anywhere else in the body would run the block at the wrong point.
     *
     * It costs the call and one stack frame for its duration. Nothing else
     * changes: nothing outside this module names the second label, so no other
     * caller can tell the two apart. */
    ED1_EnterEscMenu_AfterVersionText();
}
