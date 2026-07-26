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
 */
struct PresetSrc { char pad[32]; long common; long slots[4]; char pad2[3]; unsigned char kinds[4]; };
extern char GCOMMAND_PresetWorkEntryTable[];
extern long NEWGRID_JMPTBL_MATH_Mulu32(long a, long b);
extern void GCOMMAND_InitPresetWorkEntry(char *dst, long kind, long common, long slot);
void GCOMMAND_LoadPresetWorkEntries(struct PresetSrc *src)
{
    long i;

    for (i = 0; i < 4; i++)
        GCOMMAND_InitPresetWorkEntry(GCOMMAND_PresetWorkEntryTable + NEWGRID_JMPTBL_MATH_Mulu32(i, 24),
                                     (long)src->kinds[i], src->common, src->slots[i]);
}
