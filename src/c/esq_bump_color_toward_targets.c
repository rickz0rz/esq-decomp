/* RESTORES: ESQ_BumpColorTowardTargets
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     3200340002410f00024200f00240000f76001619e14bb24367040641010076001619e94bb44367040642001076001619b04367025240d041d0424e75
 *   got:     48e70f043e2f001a2a6f001c2c0702460f002a07024500f028070244000f7000101de180b0466704064601007000101de980b045670406450010700030047200121db081670252443004d046d0457200320020014cdf20f04e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. No C function can express that convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument function: the caller passes the packed colour in D0 and the
 * target triple pointer in A1. Documented for reference; cannot be linked. */
long ESQ_BumpColorTowardTargets(unsigned short colour, unsigned char *target)
{
    unsigned short r = colour & 0x0f00;
    unsigned short g = colour & 0x00f0;
    unsigned short b = colour & 0x000f;

    if (r != (unsigned short)(*target++ << 8))
        r += 0x100;
    if (g != (unsigned short)(*target++ << 4))
        g += 0x10;
    if (b != *target++)
        b += 1;
    return (unsigned short)(b + r + g);
}
