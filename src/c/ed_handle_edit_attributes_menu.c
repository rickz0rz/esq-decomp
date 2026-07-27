/* RESTORES: ED_HandleEditAttributesMenu
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 * OPTIONS:  SHORTINT
 *
 * 680 bytes in the original and 680 emitted -- but that equality is a
 * COINCIDENCE, not a near-match. There are 29 differing regions. Do not read the
 * size as evidence of fidelity here; the ED_HandleSpecialFunctionsMenu file in
 * this directory is the one where the byte accounting actually closes.
 *
 * What does reproduce: the chained-subtract dispatch (SUBQ.W #8 / SUBQ.W #5 /
 * SUBI.W #$8e, testing keys 8, 13 and 155 with everything else falling to the
 * digit-input default), all four case bodies, the two distinct exits (most paths
 * fall into ED_RedrawCursorChar, the case-13 paths return before it), and the
 * ED_EditBufferScratch[ED_EditCursorOffset++] post-increment store.
 *
 * NOTE: requires SHORTINT. Without it the function comes out 672 bytes with
 * 32-bit compares throughout.
 *
 * SASC-MISMATCH: multiply-strength-reduction
 *   ref:     700a 4ebaaf7a               MOVEQ #10,D0 / JSR GROUP_AG_JMPTBL_MATH_Mulu32
 *   got:     e540 d041 d040              ASL.W #2,D0 / ADD.W D1,D0 / ADD.W D0,D0
 *   summary: For the two-digit ad number the original computes (tens-'0')*10 by
 *            calling the 32-bit multiply helper; SAS/C strength-reduces it to
 *            ((x<<2)+x)<<1 inline. Same family as shift-of-one-via-bset and
 *            constant-via-moveq-shift: SAS/C reaches for shifts where the
 *            original called out to the runtime. It is further evidence the
 *            original code generator optimises less than 6.51 -- see the
 *            bracket in docs/compiler-version.md.
 *   scope:   every multiply by a small constant.
 *
 * SASC-MISMATCH: case-body-layout-order
 *   summary: The compare chain matches but SAS/C places the case bodies in a
 *            different order, so every branch displacement in the dispatch
 *            differs (ref 0e/7a where we emit 10/3a) and the bodies appear
 *            shuffled through the function. Semantically identical, and it is
 *            why the diff has 29 regions rather than three.
 *   scope:   any switch with more than two cases.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA (JSR (d16,PC)) in the original against 6100 (BSR.W) from 6.51,
 *            for all fourteen calls. All were cross-unit in the original, so
 *            this function is pre-positioned to match on the right compiler.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     48e73800 .. 4cdf001c        MOVEM D2-D4
 *   got:     48e73102 .. 4cdf408c        MOVEM D2-D3/D7/A6
 *   summary: SAS/C saves A6 across the graphics.library calls and allocates D7
 *            where the original used D4.
 */
#include <proto/graphics.h>

extern void ED_DrawCursorChar(void);
extern void ED_RedrawCursorChar(void);
extern void ED_DrawAdEditingScreen(void);
extern void ED_LoadCurrentAdIntoBuffers(void);
extern void ED_DrawHelpPanels(long which);
extern void ED_UpdateAdNumberDisplay(void);
extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern struct RastPort *Global_REF_RASTPORT_1;

extern unsigned char ED_LastKeyCode;
extern unsigned char ED_MenuStateId;
extern long ED_EditCursorOffset;
extern char ED_EditBufferScratch[];
extern long ED_StateRingIndex;
extern char ED_StateRingTable[];
extern char ED_LastMenuInputChar;
extern char ED_AdNumberInputDigitTens;
extern char ED_AdNumberInputDigitOnes;
extern long Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern long ED_MaxAdNumber;
extern long ED_SaveTextAdsOnExitFlag;
extern char ED2_STR_NUMBER_TOO_BIG[];
extern char ED2_STR_NUMBER_TOO_SMALL[];
extern char ED2_STR_PUSH_ESC_TO_EXIT_ATTRIBUTE_EDIT_DOT[];
extern char ED2_STR_PUSH_RETURN_TO_ENTER_SELECTION[];
extern char ED2_STR_PUSH_ANY_KEY_TO_SELECT[];

void ED_HandleEditAttributesMenu(void)
{
    char navChar;

    ED_DrawCursorChar();

    switch (ED_LastKeyCode) {

    case 8:
        if (ED_EditCursorOffset > 12) {
            ED_EditCursorOffset--;
            ED_EditBufferScratch[ED_EditCursorOffset] = ' ';
            ED_DrawCursorChar();
        }
        break;

    case 13:
        if (ED_AdNumberInputDigitTens == ' ') {
            if (ED_AdNumberInputDigitOnes == ' ')
                Global_REF_LONG_CURRENT_EDITING_AD_NUMBER = 1;
            else
                Global_REF_LONG_CURRENT_EDITING_AD_NUMBER =
                    ED_AdNumberInputDigitOnes - '0';
        } else if (ED_AdNumberInputDigitOnes == ' ') {
            Global_REF_LONG_CURRENT_EDITING_AD_NUMBER =
                ED_AdNumberInputDigitTens - '0';
        } else {
            Global_REF_LONG_CURRENT_EDITING_AD_NUMBER =
                (ED_AdNumberInputDigitTens - '0') * 10
                + ED_AdNumberInputDigitOnes - '0';
        }

        if (Global_REF_LONG_CURRENT_EDITING_AD_NUMBER > ED_MaxAdNumber) {
            SetAPen(Global_REF_RASTPORT_1, 4L);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 150,
                                          ED2_STR_NUMBER_TOO_BIG);
            SetAPen(Global_REF_RASTPORT_1, 1L);
            return;
        }
        if (Global_REF_LONG_CURRENT_EDITING_AD_NUMBER == 0) {
            SetAPen(Global_REF_RASTPORT_1, 4L);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 150,
                                          ED2_STR_NUMBER_TOO_SMALL);
            SetAPen(Global_REF_RASTPORT_1, 1L);
            return;
        }
        if (ED_MenuStateId == 2) {
            ED_MenuStateId = 4;
            ED_DrawAdEditingScreen();
            ED_LoadCurrentAdIntoBuffers();
            ED_SaveTextAdsOnExitFlag = 1;
            return;
        }
        ED_MenuStateId = 5;
        ED_DrawHelpPanels(6);
        ED_UpdateAdNumberDisplay();
        SetDrMd(Global_REF_RASTPORT_1, 0L);
        SetAPen(Global_REF_RASTPORT_1, 1L);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 330,
                                      ED2_STR_PUSH_ESC_TO_EXIT_ATTRIBUTE_EDIT_DOT);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 360,
                                      ED2_STR_PUSH_RETURN_TO_ENTER_SELECTION);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 390,
                                      ED2_STR_PUSH_ANY_KEY_TO_SELECT);
        SetDrMd(Global_REF_RASTPORT_1, 1L);
        return;

    case 155:
        navChar = ED_StateRingTable[ED_StateRingIndex * 5 + 1];
        ED_LastMenuInputChar = navChar;
        if (navChar == 'C')
            ED_EditCursorOffset = 13;
        else if (navChar == 'D')
            ED_EditCursorOffset = 12;
        break;

    default:
        if (ED_LastKeyCode >= '0' && ED_LastKeyCode <= '9') {
            ED_DrawCursorChar();
            ED_EditBufferScratch[ED_EditCursorOffset] = ED_LastKeyCode;
            if (ED_EditCursorOffset < 13) {
                ED_DrawCursorChar();
                ED_EditBufferScratch[ED_EditCursorOffset++] = ED_LastKeyCode;
            }
        }
        break;
    }

    ED_RedrawCursorChar();
}
