/* RESTORES: ESQIFF2_ValidateAsciiNumericByte
 * MODULE:   modules/groups/a/o/esqiff2.s
 * STATUS:   behavioural
 *
 * Returns the byte when it lies in 1..48, otherwise 1. 24 bytes ref vs 36.
 *
 * SASC-MISMATCH: byte-compare-and-stale-upper-half
 *   summary: The original keeps the argument in D7 loaded by MOVE.B, compares
 *            with CMP.B, and returns MOVE.L D7,D0 -- so the upper 24 bits of the
 *            result are whatever the caller left in D7. SAS/C allocates a second
 *            register for the result, widens the byte properly, and emits
 *            EXT.W/EXT.L, costing 12 bytes. As with
 *            [script_get_ctrl_line_flag.c], the original's reliance on an
 *            unextended register may not be expressible in C.
 *   tried:   char/signed char/long parameter, long and int result locals,
 *            single-return and early-return shapes.
 *   retest:  low value -- consider leaving this one in assembly permanently.
 */
long ESQIFF2_ValidateAsciiNumericByte(char b)
{
    long r = 1;

    if (b >= 1 && b <= 48)
        r = b;
    return r;
}
