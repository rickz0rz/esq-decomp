/* RESTORES: ED_DrawDiagnosticModeText
 * MODULE:   modules/groups/a/l/ed3.s
 * STATUS:   behavioural
 *
 * 544 bytes in the original, 528 emitted, 18 differing regions. The whole
 * structure reproduces -- two DisplayTextAtPosition calls, the pen changes, and
 * all eleven Move/Text pairs in order with their exact coordinates and text
 * lengths (including the length-2 ESQ_TAG_36 among the length-1 entries).
 *
 * SASC-MISMATCH: constant-via-moveq-shift
 *   ref:     223c0000012c               MOVE.L #300,D1
 *   got:     724be589                   MOVEQ #75,D1 / ASL.L #2,D1
 *   summary: This function pins down the original's rule, which is narrower than
 *            SAS/C's. The ORIGINAL does use a MOVEQ trick, but only doubling:
 *              190 -> 705f d080   MOVEQ #95  / ADD.L D0,D0
 *              150 -> 704b d080   MOVEQ #75  / ADD.L D0,D0
 *              240 -> 7078 d080   MOVEQ #120 / ADD.L D0,D0
 *            and it falls back to a full MOVE.L for 280, 300, 345, 385, 450,
 *            475, 555, 595 -- every value whose half does not fit in a signed
 *            byte. SAS/C generalises to an arbitrary ASL.L #n, so it reduces 300
 *            as 75<<2 and 280 as 70<<2 where the original would not.
 *
 *            So the rule is: original = MOVEQ + ADD.L (x2 only); SAS/C = MOVEQ +
 *            ASL.L #n (any power of two). That is a sharper statement of the
 *            class first recorded in ed_draw_bottom_help_bar_background.c, and it
 *            is a testable prediction for a candidate compiler.
 *   scope:   every constant load program-wide.
 *
 * NOTE: the -16 delta is dominated by this idiom offset against the +4 for the
 * A6 save/restore, but it is NOT itemised to the byte here. Treat it as
 * substantially-but-not-fully attributed.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   summary: 2F0E/2C5F around the body; the original leaves A6 alone.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit DisplayTextAtPosition calls.
 */
#include "esq-graphics.h"
extern struct RastPort *Global_REF_RASTPORT_1;
extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern char Global_STR_VIN_BCK_FWD_SSPD_AD_LINE[];
extern char Global_STR_TZ_DST_CONT_TXT_GRPH[];
extern char ED_DiagVinModeChar[];
extern char ESQ_STR_B[];
extern char ESQ_STR_E[];
extern char ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED[];
extern char ESQ_TAG_36[];
extern char ED_DiagScrollSpeedChar[];
extern char ESQ_STR_6[];
extern char ESQ_SecondarySlotModeFlagChar[];
extern char ESQ_STR_Y[];
extern char ED_DiagTextModeChar[];
extern char ED_DiagGraphModeChar[];

void ED_DrawDiagnosticModeText(void)
{
    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetDrMd(Global_REF_RASTPORT_1, 1L);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 300,
                                  Global_STR_VIN_BCK_FWD_SSPD_AD_LINE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 330,
                                  Global_STR_TZ_DST_CONT_TXT_GRPH);
    SetAPen(Global_REF_RASTPORT_1, 3L);

    Move(Global_REF_RASTPORT_1, 100L, 300L);
    Text(Global_REF_RASTPORT_1, ED_DiagVinModeChar, 1L);
    Move(Global_REF_RASTPORT_1, 190L, 300L);
    Text(Global_REF_RASTPORT_1, ESQ_STR_B, 1L);
    Move(Global_REF_RASTPORT_1, 280L, 300L);
    Text(Global_REF_RASTPORT_1, ESQ_STR_E, 1L);
    Move(Global_REF_RASTPORT_1, 385L, 300L);
    Text(Global_REF_RASTPORT_1, ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED, 1L);
    Move(Global_REF_RASTPORT_1, 475L, 300L);
    Text(Global_REF_RASTPORT_1, ESQ_TAG_36, 2L);
    Move(Global_REF_RASTPORT_1, 595L, 300L);
    Text(Global_REF_RASTPORT_1, ED_DiagScrollSpeedChar, 1L);

    Move(Global_REF_RASTPORT_1, 150L, 330L);
    Text(Global_REF_RASTPORT_1, ESQ_STR_6, 1L);
    Move(Global_REF_RASTPORT_1, 240L, 330L);
    Text(Global_REF_RASTPORT_1, ESQ_SecondarySlotModeFlagChar, 1L);
    Move(Global_REF_RASTPORT_1, 345L, 330L);
    Text(Global_REF_RASTPORT_1, ESQ_STR_Y, 1L);
    Move(Global_REF_RASTPORT_1, 450L, 330L);
    Text(Global_REF_RASTPORT_1, ED_DiagTextModeChar, 1L);
    Move(Global_REF_RASTPORT_1, 555L, 330L);
    Text(Global_REF_RASTPORT_1, ED_DiagGraphModeChar, 1L);

    SetAPen(Global_REF_RASTPORT_1, 1L);
}
