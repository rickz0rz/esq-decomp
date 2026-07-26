/* RESTORES: ESQ_DecColorStep
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     3200340002410f00024200f00240000f4a416704044101004a426704044200104a4067025340d041d0424e75
 *   got:     48e70f003e2f00162c0702460f002a07024500f028070244000f4a466704044601004a456704044500104a44670253443004d046d0457200320020014cdf00f04e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. No C function can express that convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument function: colour arrives in D0. Documented, not linkable. */
long ESQ_DecColorStep(unsigned short colour)
{
    unsigned short r = colour & 0x0f00;
    unsigned short g = colour & 0x00f0;
    unsigned short b = colour & 0x000f;

    if (r != 0) r -= 0x100;
    if (g != 0) g -= 0x10;
    if (b != 0) b -= 1;
    return (unsigned short)(b + r + g);
}
