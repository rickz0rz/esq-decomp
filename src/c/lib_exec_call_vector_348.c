/* RESTORES: EXEC_CallVector_348
 * MODULE:   modules/submodules/unknown30.s   (its only label)
 * STATUS:   behavioural
 *
 * THE NAME IS WRONG AND SO IS THE LIBRARY. This is AutoRequest on
 * intuition.library, not FreeTrap on exec. The offset -348 exists in both
 * tables and the disassembly labelled it `_LVOFreeTrap` from the exec one --
 * exactly the class AGENTS.md documents for EXEC_CallVector_48, which turned
 * out to be console.device RawKeyConvert rather than an exec private.
 *
 * THE REGISTER SPEC IS WHAT MAKES THE IDENTIFICATION CERTAIN, not the offset.
 * The two stock pragmas at 15c are:
 *
 *     #pragma libcall SysBase        FreeTrap    15c 001
 *     #pragma libcall IntuitionBase  AutoRequest 15c 3210BA9808
 *
 * `08` is the argument count and the nibbles before it read right to left as
 * the registers: 8, 9, A, B, 0, 1, 2, 3 -- A0, A1, A2, A3, D0, D1, D2, D3.
 * That is precisely what this stub loads, in precisely that order. FreeTrap
 * takes ONE argument in D0 and cannot be it. AutoRequest's own parameter list
 * is (window, bodyText, positiveText, negativeText, positiveFlags,
 * negativeFlags, width, height), which lines up field for field with what its
 * one caller pushes: a null window, three IntuiText pointers, two zero flag
 * words, 250 and 60.
 *
 * THE LIBRARY BASE IS AN ARGUMENT, NOT A GLOBAL, which is the reason the stub
 * exists at all. Its caller opens intuition.library itself, uses it once and
 * closes it, so there is no program-wide base to reach through. SAS/C resolves
 * a `libcall` pragma's base by ordinary C scoping, so a LOCAL named
 * IntuitionBase shadows the global from esq-intuition.h and the emitted call
 * uses the parameter. Verified rather than assumed: the emitted stream carries
 * `4eaefea4` -- JSR -348(A6) -- with A6 loaded from the caller's slot, the same
 * instruction the original ends on.
 *
 * SASC-MISMATCH: argument-marshalling
 *   ref:     48e730322c6f0038206f0018 ... 4eaefea44cdf4c0c4e75   (52)
 *   summary: the original moves each argument straight from its stack slot to
 *            its register. SAS/C copies them through callee-saved registers of
 *            its own first, because a nine-argument frame does not fit in the
 *            scratch set, and it saves and restores what it uses. The library
 *            call and the register assignment are identical.
 *   tried:   `register` on the parameters, which SAS/C ignores for a
 *            non-__asm function. An __asm form would express it, but the
 *            arguments arrive on the STACK here, not in registers.
 *   scope:   one site.
 *   retest:  a compiler that marshals argument registers directly from the
 *            frame.
 */
#include "esq-intuition.h"

long EXEC_CallVector_348(void *window, void *bodyText, void *positiveText,
                         void *negativeText, long positiveFlags,
                         long negativeFlags, long width, long height,
                         void *base)
{
    /* Shadows the global from esq-intuition.h, so the pragma's call uses the
     * base this caller opened. See the header. */
    struct IntuitionBase *IntuitionBase = (struct IntuitionBase *)base;

    return AutoRequest((struct Window *)window,
                       (struct IntuiText *)bodyText,
                       (struct IntuiText *)positiveText,
                       (struct IntuiText *)negativeText,
                       positiveFlags, negativeFlags, width, height);
}
