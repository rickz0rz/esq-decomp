/* RESTORES: ESQSHARED4_DecodeRgbNibbleTriplet
 * MODULE:   modules/groups/a/q/esqshared4_esqshared4_decodergbnibbletriplet.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-04, AS AN `__asm` REGISTER FUNCTION. The triple
 *   pointer arrives in A1 and the packed colour comes back in D0, which
 *   `register __a1` and the return value express exactly.
 *
 *   The clobber that used to make this unlinkable is gone by construction: the
 *   original works in D1 and D2 and restores neither, and a compiled C body
 *   saves every callee-saved register it touches. That was the reason
 *   esqshared4_blit_banner_rows.c INLINES this decode rather than calling it,
 *   and the inline is kept -- see below.
 *
 * IT HAS NO CALLER LEFT, and that is worth saying plainly rather than leaving
 * for the next reader to rediscover. Its one caller was
 * ESQSHARED4_LoadCopperColorWordsFromNibbleTable in esqshared4_p4.s, which is
 * now esqshared4_blit_banner_rows.c and inlines the three nibble reads. So this
 * function is restored to take the module out of assembly, not because anything
 * reaches it. Leaving the inline alone is deliberate: it is what the caller's
 * own restoration was measured against.
 *
 * THE POINTER IS ADVANCED BY 3 IN THE ORIGINAL AND IS NOT HERE. `MOVE.B (A1)+`
 * three times leaves A1 past the triple, and C cannot return a register. No
 * caller depends on it today, and the inline in the caller does its own
 * advance. This is the same register-threaded-pointer divergence recorded in
 * esq_bump_color_toward_targets.c.
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     1419121910190242000f0241000f0240000fe14ae949d041d0424e75   (28)
 *   summary: SAS/C copies A1 into a callee-saved register of its own and
 *            zero-extends each nibble through a MOVEQ/MOVE.B pair, where the
 *            original loads the byte straight and masks the word. The three
 *            masks, the two shifts and the two adds are the same arithmetic in
 *            the same order.
 *   tried:   `register` on the locals changes nothing; the parameter is
 *            already in a register and the copy is what `__asm` does.
 *   scope:   every `__asm` register function in the program.
 *   retest:  a compiler that works in the argument register directly.
 */
/* The triple pointer arrives in A1. */
long __asm ESQSHARED4_DecodeRgbNibbleTriplet(register __a1 unsigned char *p)
{
    unsigned short r = *p++ & 15;
    unsigned short g = *p++ & 15;
    unsigned short b = *p++ & 15;

    return (unsigned short)(b + (g << 4) + (r << 8));
}
