/* RESTORES: ESQ_TestBit1Based
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: word-shift-index
 *   ref:     206f0004202f0008720053801200028100000007e6480330000056c0488048c04e75
 *   got:     48e737042e2f00202a6f001c53872a077007ca802007e6482c00700030062205740003c2760016350800c68256c04400488048c04cdf20ec4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
long ESQ_TestBit1Based(unsigned char *base, long bit)
{
    unsigned short byteIndex;
    long bitIndex;

    bit--;
    bitIndex = bit & 7;
    byteIndex = (unsigned short)bit >> 3;
    /* -1 WHEN THE BIT IS SET, NOT +1. The original ends
     *     BTST D1,0(A0,D0.W) / SNE D0 / EXT.W D0 / EXT.L D0
     * and Scc sets 0xFF, so sign-extending it twice gives -1. Returning +1
     * inverts every caller: all ~25 of them test `== -1`, `!= -1`, or the
     * `+ 1 == 0` spelling of the same thing, so with +1 the "bit is set" arm
     * becomes unreachable everywhere.
     *
     * It is the mirror of the class this project already records. Scc followed
     * by NEG.B and a widen gives +1; Scc followed by a bare widen gives -1.
     * The two differ only by one instruction and the restoration took the
     * wrong one.
     *
     * WHAT IT COST: DISKIO2_WriteCurDayDataFile writes a programme slot only
     * when this returns -1, so curday.dat came out with its header, its channel
     * records and NOT ONE PROGRAMME -- while the grid drew them correctly,
     * because the display reads the entry tables directly and never calls this.
     * No byte gate, audit or screen check can see it; it needs a real listings
     * feed and a look at the file. */
    return (base[byteIndex] & (1 << bitIndex)) ? -1L : 0L;
}
