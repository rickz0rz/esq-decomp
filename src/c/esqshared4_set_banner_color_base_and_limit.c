/* RESTORES: ESQSHARED4_SetBannerColorBaseAndLimit
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-04, AS AN `__asm` REGISTER FUNCTION. The base colour
 *   arrives in D0, and `register __d0` puts it there for every caller --
 *   esqshared4_p1.s reaches it with BSR.W twice, and
 *   esqshared4_init_banner_copper_system.c already declares exactly this
 *   prototype, so the two sides agreed before the definition did.
 *
 *   The clobber direction is safe: the original destroys D0 and D1 and nothing
 *   else, both scratch, and a compiled C body destroys a subset of that.
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     33c000005efe323c00d913c000002fa013c00000436413c100002fa113c1000043654e75
 *   got:     48e703003e2f000e3c3c00d933c700000000300713c00000000013c000000000320613c10000000013c1000000004cdf00c04e75
 *   summary: SAS/C copies the argument register into a callee-saved register
 *            of its own before using it, where the original stores straight out
 *            of D0. That costs the MOVEM pair and one register-to-register
 *            move. The five stores and the wait-row constant are the same.
 *   tried:   `register` on the locals changes nothing; the parameter is
 *            already in a register and the copy is what `__asm` does.
 *   scope:   every `__asm` register function in the program.
 *   retest:  a compiler that works in the argument register directly.
 */
/* The base colour arrives in D0. */
extern short ESQPARS2_BannerColorBaseValue;
extern unsigned char ESQ_BannerColorClampValueA, ESQ_BannerColorClampValueB;
extern unsigned char ESQ_BannerColorClampWaitRowA, ESQ_BannerColorClampWaitRowB;

void __asm ESQSHARED4_SetBannerColorBaseAndLimit(register __d0 short base)
{
    short row = 0xd9;

    ESQPARS2_BannerColorBaseValue = base;
    ESQ_BannerColorClampValueA = (unsigned char)base;
    ESQ_BannerColorClampValueB = (unsigned char)base;
    ESQ_BannerColorClampWaitRowA = (unsigned char)row;
    ESQ_BannerColorClampWaitRowB = (unsigned char)row;
}
