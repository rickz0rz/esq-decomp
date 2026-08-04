/* RESTORES: ESQSHARED4_TickCopperAndBannerTransitions
 * MODULE:   modules/groups/a/q/esqshared4_p3_p0.s   (1 of its 3 blocks)
 * STATUS:   behavioural
 *
 * The per-field tick. ESQ_TickGlobalCounters -- the vertical-blank interrupt
 * server -- calls it, so this runs on every VERTB and everything in it is on
 * the interrupt path.
 *
 * IT PICKS THE COPPER LIST BY FIELD, and the test is a SIGN test on VPOSR, not
 * a mask. Bit 15 is the long-frame bit: `BPL` takes list A when the bit is
 * clear and list B when it is set, and the select flag stored alongside is 1
 * for A and 0 for B -- inverted against what the letters suggest. The same
 * idiom appears at the end of
 * esqshared4_program_display_window_and_copper.c.
 *
 * THE READ-MODE DISPATCH IS A CHAIN OF EQUALITY TESTS ON ONE WORD, and three
 * of its five arms do nothing but leave. 0x200 rewrites the word to 0x100 and
 * jumps to the reseed; 0x102, 0x101 and 0x100 all fall straight out; anything
 * else decrements the word by one, unless the word is NEGATIVE, in which case
 * the highlight countdown is decremented instead. The dead-looking arms are
 * written out rather than folded, because folding them would change which
 * comparisons the emitted code performs and the chain is what the original
 * has.
 *
 * THE HOLDOFF ARM IS THE BANNER BLIT. When GCOMMAND_HighlightHoldoffTickCount
 * is non-zero the routine skips the whole read-mode chain, decrements the
 * holdoff and the countdown, and calls BlitBannerRowsForActiveField -- the
 * hand-unrolled row copier whose restoration must stay unrolled, because on
 * this path a slower loop tears the screen. See esqshared4_blit_banner_rows.c.
 *
 * THE COUNTDOWN DECREMENT AT .lab_0C88 TESTS THE RESULT, so the reseed at
 * .lab_0C89 runs only when the decrement took the counter below zero. Written
 * as `if (--n < 0)`, which is the decrement-then-branch shape the original
 * uses; a pre-test would reseed one field early.
 *
 * SASC-MISMATCH: hardware-register-base
 *   ref:     LEA BLTDDAT,A0 once, then VPOSR and COP1LCH as displacements off
 *            A0
 *   got:     each register reached as its own absolute address
 *   summary: the original keeps one pointer into the custom chip block and
 *            indexes it, which costs 4 bytes for the LEA and saves 2 per
 *            access. There are two accesses here, so the original is 2 bytes
 *            ahead. The absolute form is what an extern gives, and
 *            tools/mkabsdefs.py exports these as EXT_ABS precisely so they are
 *            reached as externs rather than pointer casts.
 *   scope:   every restoration that touches more than one custom register.
 *   retest:  a compiler that pools nearby absolute addresses into a base
 *            register.
 *
 * SASC-MISMATCH: branch-width
 *   ref:     BRA.W and BNE.W throughout, even where the target is close
 *   got:     SAS/C picks the short form where it fits
 *   summary: the disassembly's widths are the original's; several are wider
 *            than the distance needs. Size only.
 *   scope:   program-wide.
 *   retest:  nothing to retest; it is an assembler choice, not a semantic one.
 */
extern volatile unsigned short VPOSR;
extern volatile unsigned long  COP1LCH;

extern unsigned short ESQ_CopperEffectListA[];
extern unsigned short ESQ_CopperEffectListB[];

extern long  ESQPARS2_ActiveCopperListSelectFlag;
extern short ESQPARS2_CopperProgramPendingFlag;
extern short ESQPARS2_ReadModeFlags;
extern short ESQPARS2_HighlightTickCountdown;
extern short ESQPARS2_StateIndex;
extern short SCRIPT_BannerTransitionActive;
extern short ED2_HighlightTickEnabledFlag;
extern char  GCOMMAND_HighlightHoldoffTickCount;

extern void ESQSHARED4_ProgramDisplayWindowAndCopper(void);
extern void SCRIPT_UpdateBannerCharTransition(void);
extern void GCOMMAND_TickHighlightState(void);
extern void ESQSHARED4_BlitBannerRowsForActiveField(void);

void ESQSHARED4_TickCopperAndBannerTransitions(void)
{
    unsigned short *list = ESQ_CopperEffectListA;
    long select = 1;
    short reseed = 0;

    if ((short)VPOSR < 0) {             /* bit 15 -- the long-frame bit */
        list = ESQ_CopperEffectListB;
        select = 0;
    }
    COP1LCH = (unsigned long)list;
    ESQPARS2_ActiveCopperListSelectFlag = select;

    if (ESQPARS2_CopperProgramPendingFlag != 0) {
        ESQSHARED4_ProgramDisplayWindowAndCopper();
        ESQPARS2_CopperProgramPendingFlag = 0;
        return;
    }

    SCRIPT_UpdateBannerCharTransition();
    if (SCRIPT_BannerTransitionActive != 0)
        return;

    if (GCOMMAND_HighlightHoldoffTickCount != 0) {
        GCOMMAND_HighlightHoldoffTickCount--;
        ESQPARS2_HighlightTickCountdown--;
        ESQSHARED4_BlitBannerRowsForActiveField();
        return;
    }

    if (ESQPARS2_ReadModeFlags == 0x200) {
        ESQPARS2_ReadModeFlags = 0x100;
        reseed = 1;
    } else if (ESQPARS2_ReadModeFlags == 0x102) {
        return;
    } else if (ESQPARS2_ReadModeFlags == 0x101) {
        return;
    } else if (ESQPARS2_ReadModeFlags == 0x100) {
        return;
    } else if (ESQPARS2_ReadModeFlags >= 0) {
        ESQPARS2_ReadModeFlags -= 1;
        return;
    } else if (--ESQPARS2_HighlightTickCountdown >= 0) {
        return;
    } else {
        reseed = 1;
    }

    if (reseed) {
        ESQPARS2_HighlightTickCountdown = ESQPARS2_StateIndex;
        if (ED2_HighlightTickEnabledFlag != 0)
            GCOMMAND_TickHighlightState();
    }
}
