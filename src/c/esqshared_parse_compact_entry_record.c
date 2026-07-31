/* RESTORES: ESQSHARED_ParseCompactEntryRecord
 * MODULE:   modules/groups/a/p/esqshared.s
 * STATUS:   behavioural
 *
 * Peels a compact record apart: two leading bytes, then a title copied out
 * until either the sentinel 18 or the ninth character, then one trailing byte,
 * then the rest of the record handed to the title matcher.
 *
 * Two things the listing settles that reading the code would not:
 *
 *  - The sentinel byte IS copied into the buffer before the test, and the
 *    terminator then overwrites it. The store comes first
 *    (MOVE.B D0,-15(A5,D7.W)) and the CMP.B follows.
 *  - The index cap is a SIGNED WORD compare (MOVEQ #8,D0 / CMP.W D0,D7 / BGE),
 *    so the counter is a short, not a long.
 *
 * The argument order at the call is fixed by the push order, which is the
 * reverse of the C order: buffer, then the SECOND byte read, then the FIRST,
 * then the trailing byte, then the advanced record pointer.
 *
 * 84 ref vs 92 got. The buffer is declared char[15] because the original places
 * it at -15(A5) inside a LINK.W A5,#-16 frame, so it runs to the end of the
 * frame; the loop itself never writes past index 8.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fff0 ... 1b8070f1 ... 486dfff1 ... 4ced08f4ffd8 4e5d
 *            LINK.W A5,#-16 / MOVE.B D0,-15(A5,D7.W) / PEA -15(A5) / MOVEM / UNLK
 *   got:     9efc0010 ... 1f807019 ... 486f0029 ... 4fef0014 4cdf20f4 defc0010
 *            SUBA.W #16,A7 / MOVE.B D0,(25,A7,D7.W) / PEA 41(A7) / LEA / ADDA.W
 *   summary: identical code written against an A5 frame in the original and
 *            against A7 in 6.51. Because 6.51 has no frame pointer it must pop
 *            the five call arguments explicitly and then undo its own SUBA,
 *            which is where the 8 bytes go. Same class as
 *            diskio_write_decimal_field.c, same root cause as A3/A5.
 *   tried:   nothing from the source side; the sc option list has no
 *            frame-pointer control.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void ESQSHARED_UpdateMatchingEntriesByTitle(char *title, long a, long b,
                                                   long c, unsigned char *rest);

void ESQSHARED_ParseCompactEntryRecord(unsigned char *p)
{
    char  buf[15];
    short i;
    unsigned char first, second, trailer;

    first  = *p++;
    second = *p++;

    i = 0;
    for (;;) {
        buf[i] = *p++;
        if (buf[i] == 18)
            break;
        if (i >= 8)
            break;
        i++;
    }
    buf[i] = 0;

    trailer = *p++;
    ESQSHARED_UpdateMatchingEntriesByTitle(buf, (long)second, (long)first,
                                           (long)trailer, p);
}
