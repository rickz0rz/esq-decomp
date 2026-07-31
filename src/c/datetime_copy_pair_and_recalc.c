/* RESTORES: DATETIME_CopyPairAndRecalc
 * MODULE:   modules/groups/a/j/disptext2_p2.s
 * STATUS:   behavioural
 *
 * Copies two 22-byte date records into the buffers a pair record already owns,
 * then recomputes both second-counts.
 *
 * The three guards are separate tests in the original -- the pair pointer, then
 * each of its two buffer pointers -- and all three jump to the same exit, so
 * they are written as one short-circuit chain.
 *
 * The copies are BYTE-AT-A-TIME (MOVEQ #21 / MOVE.B (A0)+,(A1)+ / DBF), which
 * is what memcpy of a char buffer inlines to. AGENTS.md records the pairing
 * both ways round: struct assignment gives a MOVE.L loop, memcpy of a plain
 * byte array gives this MOVE.B loop. The destination here is a char * with no
 * struct type, so memcpy is the faithful form. 22 bytes, not 21 -- DBF runs the
 * body count+1 times.
 *
 * 90 ref vs 84 got. BOTH copy loops match the original byte for byte
 * (7015 / 12d8 / 51c8fffc twice), which is the evidence that memcpy is right
 * here rather than a struct assignment. The 6 bytes are the frame class alone.
 *
 * SASC-MISMATCH: link-frame-vs-none
 *   ref:     4e550000 ... 4e5d       LINK.W A5,#0 / UNLK
 *   got:     (nothing)               no frame at all
 *   summary: the original opens a ZERO-SIZED frame -- LINK.W A5,#0 -- purely
 *            because its code generator addresses parameters through A5. It has
 *            no locals to hold. 6.51 has no frame pointer, reads the same three
 *            parameters at A7 offsets, and emits neither the LINK nor the UNLK,
 *            which is the 6 bytes.
 *   tried:   nothing from the source side; there is no frame-pointer option in
 *            the sc option list.
 *   scope:   program-wide, and a LINK #0 is the clearest single sighting of the
 *            reserved-A5 property there is -- the frame exists for nothing but
 *            addressing. docs/compiler-version.md, "The A3/A5 divergence has a
 *            single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

struct DateTimePair {
    char *first;                /* +0  */
    char *second;               /* +4  */
    long  firstSeconds;         /* +8  */
    long  secondSeconds;        /* +12 */
};

extern long DATETIME_NormalizeStructToSeconds(char *rec);

void DATETIME_CopyPairAndRecalc(struct DateTimePair *p, char *a, char *b)
{
    if (p == 0 || p->first == 0 || p->second == 0)
        return;

    memcpy(p->first, a, 22);
    memcpy(p->second, b, 22);

    p->firstSeconds  = DATETIME_NormalizeStructToSeconds(a);
    p->secondSeconds = DATETIME_NormalizeStructToSeconds(b);
}
