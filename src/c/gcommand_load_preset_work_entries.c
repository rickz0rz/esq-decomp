/* RESTORES: GCOMMAND_LoadPresetWorkEntries
 * MODULE:   modules/groups/a/u/gcommand3b.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     48e70110266f000c7e007004be806c32200772184eba55d041f90000b26cd1c07000103378372207e5812f3318242f2b00202f002f086100ff324fef0010528760c84cdf08804e75
 *   got:     48e701042a6f000c7e007004be806c34487800182f076100000041f900000000d1c07000103578372207e5812eb518242f2d00202f002f08610000004fef0014528760c64cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
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
struct PresetSrc { char pad[32]; long common; long slots[4]; char pad2[3]; unsigned char kinds[4]; };
extern char GCOMMAND_PresetWorkEntryTable[];
extern void GCOMMAND_InitPresetWorkEntry(char *dst, long kind, long common, long slot);
void GCOMMAND_LoadPresetWorkEntries(struct PresetSrc *src)
{
    long i;

    for (i = 0; i < 4; i++)
        GCOMMAND_InitPresetWorkEntry(GCOMMAND_PresetWorkEntryTable + i * 24,
                                     (long)src->kinds[i], src->common, src->slots[i]);
}
