/* RESTORES: NEWGRID_ResetShowtimeBuckets
 * MODULE:   modules/groups/b/a/newgrid1bb.s
 * STATUS:   behavioural
 *
 * Clears the showtime bucket count and resets all ten buckets: each gets the
 * code 0x3100 and has its owned string released and replaced.
 *
 * The bucket stride is 8 (ASL.L #3) and the string sits at +4, so the record is
 * one long and one pointer.
 *
 * Two details taken from the listing rather than invented:
 *
 *  - The count and the loop index are zeroed from ONE register: MOVEQ #0,D0 /
 *    MOVE.L D0,count / MOVE.L D0,D7. That is the chained-assignment idiom in
 *    AGENTS.md, and the count is written first, so the source order is
 *    `i = NEWGRID_ShowtimeBucketCount = 0;`.
 *  - ReplaceOwnedString takes the NEW string first and the old one second; the
 *    new one is a literal 0 here (CLR.L -(A7) is pushed last, so it is arg 1).
 *    The bucket address is parked in a frame local across the call and reloaded
 *    to store the result, which is the reserved-A5 spill class.
 *
 * 82 ref vs 80 got, and this one is as close as a cross-unit function gets.
 * EVERY instruction agrees in kind, order and size -- the chained zero, the
 * ASL.L #3 stride, the two MOVEA.L A0,A1 / ADDA.L D0,A1 pairs, the literal
 * 0x3100 store, the argument pushes including MOVE.L A1,16(A7), the ADDQ.W #8
 * cleanup, the reload through 8(A7) and the store to 4(A0). Only the two items
 * below differ, and they account for the 2 bytes exactly.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fff8 ... 4e5d       LINK.W A5,#-8 / UNLK          (6 bytes)
 *   got:     514f ... 504f           SUBQ.W #8,A7 / ADDQ.W #8,A7   (4 bytes)
 *   summary: the original opens an A5 frame for its one spill slot; 6.51
 *            adjusts A7 directly. Same 8 bytes of local space, 2 bytes cheaper.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba39e8                JSR (d16,PC)
 *   got:     61000000                BSR.W
 *   summary: same size, same displacement, same semantics, different opcode.
 *            The single class that caps the most restorations at behavioural.
 *   scope:   every cross-unit restoration; AGENTS.md carries the count.
 *            docs/compiler-version.md, "Call encoding depends on the
 *            callee's translation unit".
 *   retest:  a compiler that emits JSR (d16,PC) for a call to an extern; the
 *            isolated probe is esqiff_handle_brush_ini_reload_hotkey.c.
 */
extern char *PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(char *newStr, char *old);

struct NewGridShowtimeBucket {
    long  code;
    char *text;
};

extern long NEWGRID_ShowtimeBucketCount;
extern struct NewGridShowtimeBucket NEWGRID_ShowtimeBucketEntryTable[];

void NEWGRID_ResetShowtimeBuckets(void)
{
    long i;

    i = NEWGRID_ShowtimeBucketCount = 0;
    for (; i < 10; i++) {
        NEWGRID_ShowtimeBucketEntryTable[i].code = 0x3100;
        NEWGRID_ShowtimeBucketEntryTable[i].text =
            PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(
                0, NEWGRID_ShowtimeBucketEntryTable[i].text);
    }
}
