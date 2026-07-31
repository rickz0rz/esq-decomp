/* RESTORES: ESQSHARED4_SetBannerColorBaseAndLimit
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   behavioural
 * DO-NOT-LINK: takes its arguments in REGISTERS, so the compiled C reads the
 *   stack and gets garbage. Proven: esq_dec_color_step.c linked alone over a
 *   clean 356-entry build paints a green panel over the grid area, and
 *   ESQ_SetCopperEffect_Custom compiles to 610000004e75 -- a call and a
 *   return, doing none of the work. Kept for the analysis, never linked.
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     33c000005efe323c00d913c000002fa013c00000436413c100002fa113c1000043654e75
 *   got:     48e703003e2f000e3c3c00d933c700000000300713c00000000013c000000000320613c10000000013c1000000004cdf00c04e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. No C function can express that convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument function: the base colour arrives in D0. */
extern short ESQPARS2_BannerColorBaseValue;
extern unsigned char ESQ_BannerColorClampValueA, ESQ_BannerColorClampValueB;
extern unsigned char ESQ_BannerColorClampWaitRowA, ESQ_BannerColorClampWaitRowB;

void ESQSHARED4_SetBannerColorBaseAndLimit(short base)
{
    short row = 0xd9;

    ESQPARS2_BannerColorBaseValue = base;
    ESQ_BannerColorClampValueA = (unsigned char)base;
    ESQ_BannerColorClampValueB = (unsigned char)base;
    ESQ_BannerColorClampWaitRowA = (unsigned char)row;
    ESQ_BannerColorClampWaitRowB = (unsigned char)row;
}
