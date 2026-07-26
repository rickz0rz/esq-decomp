/* RESTORES: DATETIME_UpdateSelectionField
 * MODULE:   modules/groups/a/j/disptext2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     4e55ffe048e70710266d00087c00200b6724486dffe66100ff042e002e872f0b6100ff2a504f2a00302b0010b0456706374500107c0120064cdf08e04e5d4e75
 *   got:     9efc001c48e707042a6f00307e00200d66042007602e486f0012610000002c002e862f0d610000002a00504f2005322d0010b24066042007600a20053b4000107e0120074cdf20e0defc001c4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct DtSel { char pad[16]; short value; };
extern long DATETIME_BuildFromGlobals(void *out);
extern long DATETIME_ClassifyValueInRange(struct DtSel *s, long v);
long DATETIME_UpdateSelectionField(struct DtSel *s)
{
    char scratch[26];
    long changed = 0;
    long built, cls;

    if (s == 0)
        return changed;
    built = DATETIME_BuildFromGlobals(scratch);
    cls = DATETIME_ClassifyValueInRange(s, built);
    if (s->value == (short)cls)
        return changed;
    s->value = (short)cls;
    changed = 1;
    return changed;
}
