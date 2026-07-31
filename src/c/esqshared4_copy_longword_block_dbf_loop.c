/* RESTORES: ESQSHARED4_CopyLongwordBlockDbfLoop
 * MODULE:   modules/groups/a/q/esqshared4_esqshared4_copylongwordblockdbfloop_esqshared4_copylongwordblockdbfloop.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: not-a-callable-function
 *   ref:     28db51c9fffc4cdf1f034e75
 *   got:     48e701143e2f001a266f00142a6f00102adb200753474a4066f64cdf28804e75
 *   summary: Not expressible in C at all -- see the comment in the file. Documented so the label is accounted for; it must stay in assembly.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Not a callable function: this label is the top of a DBF copy loop that other
 * code jumps into with A3/A4/D1 already set up, and it falls through to a
 * MOVEM epilogue restoring registers its own body never saved. Documented for
 * completeness; there is no C form and it must stay in assembly. */
void ESQSHARED4_CopyLongwordBlockDbfLoop(long *dst, long *src, short count)
{
    do {
        *dst++ = *src++;
    } while (count--);
}
