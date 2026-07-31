/* RESTORES: ED_UpdateAdNumberDisplay
 * MODULE:   modules/groups/a/l/ed3bbbb.s
 * STATUS:   behavioural
 *
 * Formats and draws the current ad number, then resets the five state latches
 * the active/inactive indicator reads and calls it.
 *
 * The active flag comes from the FIRST WORD of the ad record, tested with
 * TST.W / BLE -- so a record whose leading word is zero or negative is
 * inactive, and the test is signed.
 *
 * The three -1 latches are written from ONE register, and the store order is
 * BlockB, then CachedState, then LatchA. A C chained assignment stores its
 * RIGHTMOST target first, so the chain below is written in the reverse of the
 * order the stores appear -- that is what puts them back in the original's
 * order.
 *
 * ED_AdActiveFlag and ED_ViewportOffset both take the same zero from one
 * MOVEQ, but they are not adjacent in the emitted code and are not chained
 * here; the register is simply still live.
 *
 * 132 ref vs 136 got. The SPrintf call, the DisplayTextAtPosition with its
 * PEA 180 / PEA 40, the LEA 28(A7),A7 cleanup, the ASL.L #2 table index, the
 * TST.W / BLE active test, the MOVEQ #-1 and all three latch stores match
 * exactly -- including the store ORDER of the three -1 latches, which is what
 * the reversed chained assignment in the source is for.
 *
 * SASC-MISMATCH: zero-through-register-vs-clr
 *   ref:     7000 23c000008188 ... 23c000008184
 *            MOVEQ #0,D0 / MOVE.L D0,flag / ... / MOVE.L D0,offset
 *   got:     42b900000000 ... 42b900000000
 *            CLR.L flag / ... / CLR.L offset
 *   summary: the original builds zero once and stores it to both globals from
 *            the register, even though they are far apart; 6.51 emits an
 *            independent CLR.L at each. Two bytes cheaper per site, and the
 *            reason the source does NOT chain them -- chaining would move the
 *            second store next to the first, which is not where the original
 *            has it.
 *   tried:   nothing further; a plain `= 0` is what the original compiled from.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffd8 ... 4e5d       LINK.W A5,#-40 / UNLK
 *   got:     9efc0028 ... defc0028   SUBA.W #40,A7 / ADDA.W #40,A7
 *   summary: the frame class; same 40 bytes of buffer either way.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

extern void GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, char *fmt, long a);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);
extern void ED_UpdateActiveInactiveIndicator(void);

extern struct RastPort *Global_REF_RASTPORT_1;
extern long   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern char   Global_STR_AD_NUMBER_FORMATTED[];
extern short *ED_AdRecordPtrTable[];
extern long   ED_AdActiveFlag;
extern long   ED_AdDisplayResetFlag;
extern long   ED_ViewportOffset;
extern long   ED_AdDisplayStateLatchBlockB;
extern long   ED_ActiveIndicatorCachedState;
extern long   ED_AdDisplayStateLatchA;

void ED_UpdateAdNumberDisplay(void)
{
    char buf[40];

    GROUP_AM_JMPTBL_WDISP_SPrintf(buf, Global_STR_AD_NUMBER_FORMATTED,
                                  Global_REF_LONG_CURRENT_EDITING_AD_NUMBER);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 180L, buf);

    ED_AdActiveFlag = 0;
    if (*ED_AdRecordPtrTable[Global_REF_LONG_CURRENT_EDITING_AD_NUMBER] > 0)
        ED_AdActiveFlag = 1;

    ED_AdDisplayResetFlag = 1;
    ED_ViewportOffset     = 0;

    ED_AdDisplayStateLatchA = ED_ActiveIndicatorCachedState =
        ED_AdDisplayStateLatchBlockB = -1;

    ED_UpdateActiveInactiveIndicator();
}
