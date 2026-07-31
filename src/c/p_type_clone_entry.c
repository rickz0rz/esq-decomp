/* RESTORES: P_TYPE_CloneEntry
 * MODULE:   modules/groups/b/a/p_typeb.s
 * STATUS:   behavioural
 *
 * Releases the old entry, then rebuilds it from a source entry by copying the
 * source's bytes into a stack buffer, terminating them, and allocating a fresh
 * entry from that.
 *
 * The source record is PACKED, and this is not a modeling choice: the original
 * reads its length with CMP.L 2(A2),D7 and its data pointer at 6(A2), so a long
 * sits at offset 2. That works because SAS/C aligns a long to 2 bytes on the
 * 68000, so `unsigned char` then `long` lands at +2 with no padding directive.
 * A compiler aligning to 4 would put it at +4 and read the wrong field.
 *
 * The copy is a hand-written byte loop rather than memcpy, because the original
 * indexes both sides (LEA 6(A2),A0 / ADDA.L D7,A0 / MOVE.B (A0),D0) instead of
 * walking two post-increment pointers. The result is then NUL-terminated at the
 * index the loop stopped on.
 *
 * The result register is cleared with SUBA.L A3,A3 BEFORE the null test, so a
 * null source returns 0 -- and the old entry is freed either way, before the
 * test.
 *
 * 90 ref vs 92 got. The copy loop, the terminator, the three argument pushes,
 * the LEA 12(A7),A7 cleanup and the whole control flow match instruction for
 * instruction. Two items differ and they net to the 2 bytes.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ff98 ... 1b80789c ... 486dff9c ... 4e5d
 *            LINK.W A5,#-104 / MOVE.B D0,-100(A5,D7.L) / PEA -100(A5) / UNLK
 *   got:     9efc0064 ... 1f907810 ... 486f0010 ... defc0064
 *            SUBA.W #100,A7 / MOVE.B D0,(16,A7,D7.L) / PEA 16(A7) / ADDA.W
 *   summary: the frame class. The original takes 104 bytes of frame for a
 *            100-byte buffer; 6.51 takes exactly 100 against A7.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: cross-module-short-branch
 *   ref:     6190                    BSR.S _P_TYPE_FreeEntry
 *   got:     61000000                BSR.W
 *   summary: the original reaches P_TYPE_FreeEntry with an EIGHT-BIT branch,
 *            which only works while the two sit adjacent in the image. That is
 *            the hazard AGENTS.md records under ESQ_FARCALLS -- a short branch
 *            crossing a module boundary. Replacing this function with C removes
 *            the site rather than creating one, since a C call is always BSR.W.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct PTypeEntry {
    unsigned char kind;         /* +0 */
    long          len;          /* +2, unaligned by 4 but 2-byte aligned */
    char         *data;         /* +6 */
};

extern void  P_TYPE_FreeEntry(void *entry);
extern void *P_TYPE_AllocateEntry(long kind, long len, char *data);

void *P_TYPE_CloneEntry(void *old, struct PTypeEntry *src)
{
    char  buf[100];
    long  i;
    void *out;

    P_TYPE_FreeEntry(old);

    out = 0;
    if (src != 0) {
        for (i = 0; i < src->len; i++)
            buf[i] = src->data[i];
        buf[i] = 0;
        out = P_TYPE_AllocateEntry((long)src->kind, src->len, buf);
    }
    return out;
}
