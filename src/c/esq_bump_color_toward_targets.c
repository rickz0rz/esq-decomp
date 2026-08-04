/* RESTORES: ESQ_BumpColorTowardTargets
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-04, AS AN `__asm` REGISTER FUNCTION. This is the same
 *   move that made esq_dec_color_step.c linkable on 2026-08-01, and it closes
 *   the last two DO-NOT-LINK entries in the copper family along with it.
 *
 *   The original reads the packed colour from D0, reads three target bytes
 *   through A1, and returns the new colour in D0. `register __d0` and
 *   `register __a1` express all of that.
 *
 *   THE CLOBBER PROBLEM SOLVES ITSELF, which is the point. The original works
 *   in D1, D2 and D3 and restores none of them, so SAS/C-compiled callers --
 *   which assume D2 and D3 survive a call -- could not be linked against it.
 *   That is why esq_inc_copper_lists_towards_targets.c and its sibling each
 *   carried a DO-NOT-LINK of their own. A compiled C callee SAVES every
 *   callee-saved register it uses, so the caller's assumption becomes true and
 *   both callers are now linkable. The restoration is strictly safer than the
 *   original, and the original's own callers open MOVEM.L D2-D6/A2-A3 anyway,
 *   so nothing depends on the clobber.
 *
 *   ONE THING IS NOT REPRODUCED, and it is recorded rather than worked around:
 *   the original leaves A1 ADVANCED BY 3. C cannot return a register, so each
 *   caller threads the cursor itself. Both callers are in this repository and
 *   both already do -- see the register-threaded-pointer note in
 *   esq_inc_copper_lists_towards_targets.c. There is no third caller: a grep
 *   over src/modules, src/data and src/c finds exactly app2_p4.s and
 *   app2_p4_p1.s, and both are converted.
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     3200340002410f00024200f00240000f76001619e14bb24367040641010076001619e94bb44367040642001076001619b04367025240d041d0424e75   (62)
 *   summary: SAS/C copies D0 and A1 into callee-saved registers of its own
 *            before using them, and it zero-extends each target byte with
 *            MOVEQ #0 / MOVE.B where the original clears D3 once per channel.
 *            The three compare-and-step blocks and the final two adds are the
 *            same arithmetic in the same order.
 *   tried:   `register` on the locals changes nothing; the parameters are
 *            already in registers and the copies are what `__asm` does.
 *   scope:   every `__asm` register function in the program.
 *   retest:  a compiler that works in the argument registers directly drops
 *            the MOVEM pair and both copies.
 */
#include "esq-copper.h"

unsigned short __asm ESQ_BumpColorTowardTargets(register __d0 unsigned short colour,
                                                register __a1 char *targets)
{
    unsigned char *t = (unsigned char *)targets;
    unsigned short r = colour & 0x0f00;
    unsigned short g = colour & 0x00f0;
    unsigned short b = colour & 0x000f;

    if (r != (unsigned short)(*t++ << 8))
        r += 0x100;
    if (g != (unsigned short)(*t++ << 4))
        g += 0x10;
    if (b != *t++)
        b += 1;
    return (unsigned short)(b + r + g);
}
