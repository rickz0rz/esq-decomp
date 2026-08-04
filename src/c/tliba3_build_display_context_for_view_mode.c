/* RESTORES: _TLIBA3_BuildDisplayContextForViewMode
 * MODULE:   modules/groups/b/a/tliba3_p3.s
 * STATUS:   behavioural
 *
 * Builds the two copper-effect row templates for a view mode by taking the
 * mode's pattern, offsetting its five row addresses by two independently
 * computed deltas, and writing the results into the two global template blocks.
 * It answers a pointer to the mode's runtime entry.
 *
 * THE TWO DELTAS ARE NOT INTERCHANGEABLE AND THEY CROSS OVER. The first copy
 * gets deltaB and the second gets deltaA -- the original stores them at -244
 * and -248 and then applies -244 to the block it copies to Set0 and -248 to
 * the one it copies to Set1. Swapping them displaces both copper lists by the
 * wrong amount, which is a display fault rather than a crash.
 *
 * THE FOUR-WAY DELTA SELECTION reads three bits of one word:
 *
 *   bits 15 AND 2 both set   deltaA = rowbytes - 2,  deltaB = -2
 *   bit 15 alone             both -2
 *   bit 2 alone              deltaA = rowbytes,      deltaB = 0
 *   neither                  both 0
 *
 * where `rowbytes` is `((width + 15) >> 3) & 0xfffe` -- rounded up to a byte
 * and then down to an even one. The shift is ARITHMETIC in the original, so a
 * negative width would round the other way; the value is zero-extended from a
 * word first, so it cannot be.
 *
 * MODE 0 OVERRIDES the selection afterwards: it forces deltaB to 0, recomputes
 * deltaA from the width regardless of the flags, and NUDGES TWO PATTERN FIELDS
 * -- +10 by four and +14 by minus four. Those two adjustments happen nowhere
 * else and are what makes the default view's margins differ.
 *
 * THE HIGHLIGHT IS PACKED INTO BITS 12..14 of the pattern's word at +26, with
 * the runtime word's low twelve bits and top bit preserved (`& 0x8fff`). A
 * highlight of -1 means "leave it alone" and skips the store entirely.
 *
 * THE ROW ADDRESSES ARE SPLIT ACROSS TWO WORDS four bytes apart -- high half at
 * +0 of the row, low half at +4 -- so each update is recombine, add, re-split.
 * The recombination zero-extends both halves and the re-split sign-extends the
 * high one, which is the original's `SWAP / EXT.L` pair.
 *
 * THE TABLE INDEX IS RECOMPUTED AT EVERY SITE, and reproducing that is worth 92
 * bytes of accuracy. Hoisting the runtime entry into a local -- the obvious
 * thing to write -- gives 584 bytes against a 650-byte reference, SIXTY-SIX
 * UNDER, because the original calls MATH_Mulu32 seven separate times to
 * re-derive the same address. Writing `TLIBA3_VmArrayRuntimeTable[mode]` at
 * each of the five test sites instead gives 676 -- 26 over. Further from zero
 * in the other direction, but far closer in absolute distance and structurally
 * what the original does. This is the AGENTS.md table entry `table[i].field
 * repeatedly, not hoisting p = &table[i]` applied to a case where it costs
 * bytes rather than saving them.
 *
 * 650 ref vs 676 got, 20 differing regions -- the second-lowest count in this
 * tranche. The pattern-table fetch, all four delta arms with their three bit
 * tests, both rowbytes computations, the mode-0 override with both field
 * nudges, the highlight pack with its 0x8fff mask and 12-bit shift, both
 * 76-byte struct copies, both five-row update loops with their crossed deltas,
 * both writes to the template globals and the recomputed return address match
 * in kind and size.
 *
 * SASC-MISMATCH: strength-reduced-index-multiply
 *   ref:     4eba....   JSR MATH_Mulu32, seven times
 *   got:     an inline shift-and-add sequence at each site
 *   summary: the documented 32-bit constant multiply divergence, and the whole
 *            26 bytes. The original calls the helper for `mode * 154` and
 *            `mode * 76`; 6.51 strength-reduces both. Same value, no call.
 *   tried:   the stride-local trick from
 *            tliba1_draw_formatted_text_block.c does not apply -- there the
 *            multiply is an array subscript 6.51 can be made to emit MULS for,
 *            here the original emits a CALL, which no C spelling produces.
 *   scope:   program-wide. docs/compiler-version.md, "32-bit constant
 *            multiply".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct VmPattern {                      /* 76 bytes */
    char  pad0[10];
    short w10;                          /* +10 */
    short pad12;
    short w14;                          /* +14 */
    char  pad16[10];
    short w26;                          /* +26 */
    char  pad28[10];
    short cells[19];                    /* +38, five 8-byte rows */
};

struct VmRuntime {                      /* 154 bytes */
    short w0;                           /* +0 */
    short w2;                           /* +2 */
    char  pad4[150];
};

extern void TLIBA3_InitPatternTable(void);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern void GCOMMAND_ApplyHighlightFlag(void);

extern struct VmPattern TLIBA3_VmArrayPatternTable[];
extern struct VmRuntime TLIBA3_VmArrayRuntimeTable[];
extern struct VmPattern ESQ_CopperEffectTemplateRowsSet0;
extern struct VmPattern ESQ_CopperEffectTemplateRowsSet1;

extern long  TLIBA1_CurrentViewModeIndex;
extern short TLIBA1_PatternTableInitGuard;

struct VmRuntime *TLIBA3_BuildDisplayContextForViewMode(long mode, long unused,
                                                        short highlight)
{
    struct VmPattern *set0;
    struct VmPattern *set1;
    struct VmPattern  pattern;
    struct VmPattern  copyA;
    struct VmPattern  copyB;
    long  deltaA;
    long  deltaB;
    long  v;
    long  k;

    TLIBA1_CurrentViewModeIndex = mode;

    if (TLIBA1_PatternTableInitGuard == 0)
        TLIBA3_InitPatternTable();

    set0 = &ESQ_CopperEffectTemplateRowsSet0;
    set1 = &ESQ_CopperEffectTemplateRowsSet1;

    pattern = TLIBA3_VmArrayPatternTable[mode];

    if ((TLIBA3_VmArrayRuntimeTable[mode].w0 & 0x8004) == 0x8004) {

        deltaA = ((((long)(unsigned short)TLIBA3_VmArrayRuntimeTable[mode].w2 + 15) >> 3) & 0xfffe) - 2;
        deltaB = -2;

    } else if (TLIBA3_VmArrayRuntimeTable[mode].w0 & 0x8000) {

        deltaB = deltaA = -2;

    } else if (TLIBA3_VmArrayRuntimeTable[mode].w0 & 4) {

        deltaA = (((long)(unsigned short)TLIBA3_VmArrayRuntimeTable[mode].w2 + 15) >> 3) & 0xfffe;
        deltaB = 0;

    } else {

        deltaB = deltaA = 0;
    }

    if (mode == 0) {
        deltaB = 0;
        pattern.w10 += 4;
        pattern.w14 -= 4;
        deltaA = (((long)(unsigned short)TLIBA3_VmArrayRuntimeTable[mode].w2 + 15) >> 3) & 0xfffe;
    }

    if (highlight != -1)
        pattern.w26 = (short)((TLIBA3_VmArrayRuntimeTable[mode].w0 & 0x8fff)
                              | (((long)highlight << 8) << 4));

    copyA = pattern;
    copyB = pattern;

    for (k = 0; k < 5; k++) {
        v = ((long)(unsigned short)copyA.cells[k * 4] << 16)
            + (long)(unsigned short)copyA.cells[k * 4 + 2];
        v += deltaB;
        copyA.cells[k * 4]     = (short)(v >> 16);
        copyA.cells[k * 4 + 2] = (short)(v & 0xffff);
    }

    for (k = 0; k < 5; k++) {
        v = ((long)(unsigned short)copyB.cells[k * 4] << 16)
            + (long)(unsigned short)copyB.cells[k * 4 + 2];
        v += deltaA;
        copyB.cells[k * 4]     = (short)(v >> 16);
        copyB.cells[k * 4 + 2] = (short)(v & 0xffff);
    }

    *set0 = copyA;
    *set1 = copyB;

    GCOMMAND_ApplyHighlightFlag();

    return &TLIBA3_VmArrayRuntimeTable[mode];
}
