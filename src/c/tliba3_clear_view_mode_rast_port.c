/* RESTORES: TLIBA3_ClearViewModeRastPort
 * MODULE:   modules/groups/b/a/tliba3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     48e703002e2f000c2c2f00102007724dd2814eba309a41f90000cdbcd1c043e8000a20062c79000028584eaeff164cdf00c04e75
 *   got:     48e703022c2f00142e2f00104878009a2f076100000041f900000000d1c043e8000a20062c79000000004eaeff16504f4cdf40c04e75
 *   summary: The OS call itself now matches exactly -- SAS/C's #pragma libcall emits the same MOVEA.L base,A6 / JSR _LVOxxx(A6) the original uses, with identical LVO offsets. The remaining gap is A6 handling: SAS/C treats A6 as callee-saved and adds it to the MOVEM save/restore masks (48e73002 / 4cdf400c) where the original treats A6 as scratch and does not save it (48e73000 / 4cdf000c), and it orders the base load before the argument setup. Not an option: CONSTLIBBASE, NOCONSTLIBBASE, SAVEDS and NOSAVEDS all leave it. This is now a single narrow code-generator difference rather than an unknown, and it affects every OS-calling function in the program.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * CORRECTED 2026-07-27, and this class is why the whole-program C build
 * reset the machine. MATH_DivS32/MATH_DivU32/MATH_Mulu32 are REGISTER-argument
 * helpers: dividend in D0, divisor in D1, quotient back in D0 and REMAINDER in
 * D1. This file declared one as an ordinary C function and called it with stack
 * arguments the helper never reads, so it divided by whatever happened to be in
 * D1 -- a divide by zero away from an exception. Several of these also took the
 * QUOTIENT where the original uses the REMAINDER.
 *
 * Written with C operators instead. That costs the byte match (SAS/C calls its
 * own __CXD33) but it is the only correct form: the remainder cannot be reached
 * through a C return value at all.
 */
#include <proto/graphics.h>
extern char TLIBA3_VmArrayRuntimeTable[];
void TLIBA3_ClearViewModeRastPort(long mode, long pen)
{
    SetRast((struct RastPort *)(TLIBA3_VmArrayRuntimeTable + mode * 154 + 10), pen);
}
