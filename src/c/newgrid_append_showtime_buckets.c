/* RESTORES: NEWGRID_AppendShowtimeBuckets
 * MODULE:   modules/groups/b/a/newgrid1bb.s
 * STATUS:   behavioural
 *
 * Appends every showtime bucket's text to a buffer, separated by the bucket
 * separator string. Bucket 0 is appended before the loop, which is why the
 * loop starts at 1 and why there is no leading separator.
 *
 * NEWGRID_ShowtimeBucketPtrTable is an array of POINTERS to bucket records, not
 * an array of records: the original loads it with MOVEA.L (indirect) for entry
 * 0 and with ASL.L #2 / LEA / MOVEA.L (A0) for the rest. The text sits at +4 of
 * the record it points to, which is the same layout
 * newgrid_reset_showtime_buckets.c models.
 *
 * The bound is a signed long compare against NEWGRID_ShowtimeBucketCount, read
 * fresh on every iteration.
 *
 * 86 ref vs 86 got, and the structure carries the claim rather than the size.
 * EVERY instruction agrees in kind, order and size: the indirect load of entry
 * 0 (2079), the MOVE.L 4(A0),-(A7), the ADDQ.W #8,A7, the MOVEQ #1 loop seed,
 * the CMP.L against the count, the separator PEA, the ASL.L #2 / LEA / MOVEA.L
 * indexing, the MOVE.L 4(A1),(A7) argument-slot reuse, the LEA 12(A7),A7 and
 * the ADDQ.L #1 / BRA. Only the two documented classes differ.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     48e70110 266f000c 2f0b    D7/A3 saved, buffer in A3
 *   got:     48e70104 2a6f000c 2f0d    D7/A5 saved, buffer in A5
 *   summary: same instructions, same sizes, one register apart.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba388a / 4eba3872 / 4eba385a     JSR (d16,PC), three sites
 *   got:     61000000 x3                        BSR.W
 *   summary: same size, same displacement, same semantics, different opcode.
 *   scope:   every cross-unit restoration; AGENTS.md carries the count.
 *            docs/compiler-version.md, "Call encoding depends on the
 *            callee's translation unit".
 *   retest:  a compiler that emits JSR (d16,PC) for a call to an extern; the
 *            isolated probe is esqiff_handle_brush_ini_reload_hotkey.c.
 */
struct NewGridShowtimeBucket {
    long  code;
    char *text;
};

extern void PARSEINI_JMPTBL_STRING_AppendAtNull(char *dst, char *src);

extern struct NewGridShowtimeBucket *NEWGRID_ShowtimeBucketPtrTable[];
extern long NEWGRID_ShowtimeBucketCount;
extern char NEWGRID_ShowtimeBucketSeparator[];

void NEWGRID_AppendShowtimeBuckets(char *dst)
{
    long i;

    PARSEINI_JMPTBL_STRING_AppendAtNull(dst, NEWGRID_ShowtimeBucketPtrTable[0]->text);

    for (i = 1; i < NEWGRID_ShowtimeBucketCount; i++) {
        PARSEINI_JMPTBL_STRING_AppendAtNull(dst, NEWGRID_ShowtimeBucketSeparator);
        PARSEINI_JMPTBL_STRING_AppendAtNull(dst,
                                            NEWGRID_ShowtimeBucketPtrTable[i]->text);
    }
}
