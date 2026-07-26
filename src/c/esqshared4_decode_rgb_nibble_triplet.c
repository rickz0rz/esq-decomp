/* RESTORES: ESQSHARED4_DecodeRgbNibbleTriplet
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     1419121910190242000f0241000f0240000fe14ae949d041d0424e75
 *   got:     48e707042a6f00147000101d720fc0812e007000101dc0812c007000101dc0812a003006e9403205d2403007e140d240700030014cdf20e04e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. No C function can express that convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument function: the triple pointer arrives in A1. */
long ESQSHARED4_DecodeRgbNibbleTriplet(unsigned char *p)
{
    unsigned short r = *p++ & 15;
    unsigned short g = *p++ & 15;
    unsigned short b = *p++ & 15;

    return (unsigned short)(b + (g << 4) + (r << 8));
}
