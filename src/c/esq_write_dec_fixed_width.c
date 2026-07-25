/* RESTORES: ESQ_WriteDecFixedWidth
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * Writes a NUL-terminated fixed-width decimal number, right-aligned. Used for
 * on-screen numbers, so a fault shows up directly in the display.
 * 42 bytes ref vs 62.
 *
 * SASC-MISMATCH: inline-divide-and-dbf-loop
 *   summary: The original divides with a single DIVS #10 and SWAP to take the
 *            remainder, and closes the loop with DBF. SAS/C emits a call to the
 *            32-bit divide helper for `%` and `/` separately and uses an
 *            explicit compare-and-branch, roughly 50% larger. Reproducing it
 *            needs 16-bit division, which means both the value and the divisor
 *            must be `short` -- SHORTINT alone was not sufficient.
 *   tried:   default and OPTIMIZE, SHORTINT, int/short/long value and width,
 *            do/while and for loop shapes, combined divmod via a single /.
 *   retest:  check whether a different version emits DIVS for `short % 10` and
 *            DBF for a counted do/while.
 */
void ESQ_WriteDecFixedWidth(char *buf, int value, int width)
{
    buf += width;
    *buf = 0;
    width--;
    do {
        *--buf = (char)(value % 10) + '0';
        value /= 10;
    } while (width--);
}
