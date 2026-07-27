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
 *
 * DO NOT LINK. This restoration is valid as ANALYSIS and its byte comparison
 * stands, but it must never be substituted into a build: entered with a live address register set by the caller.
 * A C function with an ordinary prologue is not a different encoding of that,
 * it is wrong. tools/gen_all_manifest.py excludes it automatically; this note
 * is here so the reason survives if the tooling changes.
 *
 * This class is what hung the machine on the first whole-program C run.
 */
/* Register-argument function: the triple pointer arrives in A1. */
long ESQSHARED4_DecodeRgbNibbleTriplet(unsigned char *p)
{
    unsigned short r = *p++ & 15;
    unsigned short g = *p++ & 15;
    unsigned short b = *p++ & 15;

    return (unsigned short)(b + (g << 4) + (r << 8));
}
