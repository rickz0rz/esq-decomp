/* RESTORES: TLIBA3_InitPatternTable
 * MODULE:   modules/groups/b/a/tliba3.s
 * STATUS:   behavioural
 *
 * Builds the nine per-view-mode COPPER LISTS, 1074 bytes. Each list is nineteen
 * (register, value) pairs -- 76 bytes -- and that is what makes the function long:
 * nineteen register stores and nineteen value stores per pass, nine passes.
 *
 * THE 76-BYTE STRIDE IS NINETEEN COPPER MOVES, not a flat word array, and naming
 * it that way is what makes the body readable. The registers the original stores
 * are, in order:
 *
 *   0x8e/0x90   DIWSTRT / DIWSTOP    display window
 *   0x92/0x94   DDFSTRT / DDFSTOP    data fetch
 *   0x108/0x10a BPL1MOD / BPL2MOD    modulos, both the same value
 *   0x100..0x104 BPLCON0..2
 *   0xe0..0xf2  BPL1PTH..BPL5PTL     five plane pointers, split high/low
 *
 * So `struct VmCopper { reg; val; }` is the shape, and the plane-pointer pairs
 * are just the high and low halves of the five longs at runtime offsets 118..134.
 *
 * The window and fetch values are derived from the runtime entry's height and
 * width with a fixed base of 40 and a constant 97, which the original computes as
 * `((40 + 9) * 2 - 1) & 0xFF` rather than writing down -- it is transcribed as the
 * arithmetic, not folded, because folding it would drop four instructions.
 *
 * TWO OF THE FOUR EDGE-ADJUSTMENT ARMS ARE IDENTICAL. When the mode index is
 * non-zero the original tests three flag conditions and subtracts 4, 4, 2 -- and
 * its `else` also subtracts 2. So the last test decides nothing. It is kept
 * because removing it removes a comparison the original emits.
 *
 * MEASURED: 984 emitted against 1074 in the original, -90 over 47 regions.
 *
 * SASC-MISMATCH: register-argument-arithmetic-helpers
 *   ref:     724c 4eba....         MOVEQ #76,D1 / JSR MATH_Mulu32
 *   got:     array indexing, and inline divides
 *   summary: the original reaches MATH_Mulu32 and MATH_DivS32 with the operands
 *            already in D0/D1 -- twelve multiply sites, all of them index
 *            arithmetic that C expresses as `table[i]`, plus two divides. Not a C
 *            calling convention.
 *   scope:   program-wide wherever MATH_Mulu32/MATH_DivS32 appear.
 *   retest:  a compiler whose helpers ARE these routines.
 *
 * SASC-MISMATCH: recomputed-index-per-store
 *   ref:     MOVEA.L A0,A1 / ADDA.L D0,A1 before EVERY store
 *   got:     one base pointer per pass
 *   summary: the original recomputes the row address for each of the nineteen
 *            register stores rather than holding it. AGENTS.md notes the original
 *            "often recomputes the index multiply per access", but here it calls
 *            MATH_Mulu32 twelve times to do it, and reproducing that from C would
 *            need the register-argument convention above. So this class and the
 *            helper class are the same finding seen from two sides.
 *   scope:   this function; the VM table builders generally.
 *   retest:  as above.
 *
 * SASC-MISMATCH: bit-test-width
 *   ref:     0828 0007 0000        BTST #7,(A2)   and BTST #2,1(A2)
 *   got:     a word mask
 *   summary: the original tests bit 7 of the flag word's HIGH byte and bit 2 of
 *            its LOW byte. Written here as `& 0x8000` and `& 0x0004` on the word,
 *            because the same word is also read whole for the 0x8004 test and one
 *            member cannot be both.
 *   scope:   anywhere a flag word is tested a bit at a time.
 *   retest:  a compiler that narrows a word mask to a byte BTST.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffdc ... 4e5d     LINK.W A5,#-36 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 */
#include <exec/types.h>

struct VmCopper {
    unsigned short reg;
    unsigned short val;
};

struct VmPattern {
    struct VmCopper c[19];      /* 76 bytes */
};

struct VmRuntime {
    unsigned short flags0;      /*   0 */
    unsigned short width2;      /*   2 */
    short          pad4;        /*   4 */
    short          height6;     /*   6 */
    char           pad8[110];   /*   8 */
    long           plane118;    /* 118 */
    long           plane122;    /* 122 */
    long           plane126;    /* 126 */
    long           plane130;    /* 130 */
    long           plane134;    /* 134 */
    char           pad138[16];  /* 138, to the 154-byte stride */
};

extern short TLIBA1_PatternTableInitGuard;
extern struct VmPattern TLIBA3_VmArrayPatternTable[];
extern struct VmRuntime TLIBA3_VmArrayRuntimeTable[];
extern void  TLIBA3_InitRuntimeEntries(void);

void TLIBA3_InitPatternTable(void)
{
    struct VmPattern *p;
    struct VmRuntime *rt;
    long  i;
    long  base;
    long  edgeBase;
    long  divisor;
    long  scratch;
    short height;
    short halfHeight;
    short quarterStep;
    short remainder;
    short extra;
    short edge;

    TLIBA1_PatternTableInitGuard = 1;
    TLIBA3_InitRuntimeEntries();

    for (i = 0; i < 9; i++) {
        p = &TLIBA3_VmArrayPatternTable[i];

        p->c[0].reg = 0x8e;
        p->c[1].reg = 0x90;
        p->c[2].reg = 0x92;
        p->c[3].reg = 0x94;
        p->c[4].reg = 0x108;
        p->c[5].reg = 0x10a;
        p->c[6].reg = 0x100;
        p->c[7].reg = 0x102;
        p->c[8].reg = 0x104;
        p->c[9].reg = 0xe0;
        p->c[10].reg = 0xe2;
        p->c[11].reg = 0xe4;
        p->c[12].reg = 0xe6;
        p->c[13].reg = 0xe8;
        p->c[14].reg = 0xea;
        p->c[15].reg = 0xec;
        p->c[16].reg = 0xee;
        p->c[17].reg = 0xf0;
        p->c[18].reg = 0xf2;

        rt = &TLIBA3_VmArrayRuntimeTable[i];
        height = rt->height6;
        halfHeight = height / 2;
        quarterStep = (short)(((long)height / 16) * 4);
        remainder = (short)((long)height % 16);

        if (remainder != 0)
            scratch = (((long)remainder / 2) << 4) + (long)remainder / 2;
        else
            scratch = 0;
        extra = (short)scratch;

        base = 40;
        TLIBA3_VmArrayPatternTable[i].c[2].val =
            (unsigned short)(base + quarterStep);

        divisor = (TLIBA3_VmArrayRuntimeTable[i].flags0 & 0x8000) ? 4 : 2;
        TLIBA3_VmArrayPatternTable[i].c[3].val = (unsigned short)
            ((quarterStep + base) +
             (unsigned short)TLIBA3_VmArrayRuntimeTable[i].width2 / divisor);

        /* 97, which the original builds rather than writes down. */
        edgeBase = (((base + 9) * 2) - 1) & 0xFF;

        TLIBA3_VmArrayPatternTable[i].c[0].val =
            (unsigned short)(((halfHeight + edgeBase) & 0xFF) + 0x1700);

        divisor = (TLIBA3_VmArrayRuntimeTable[i].flags0 & 0x8000) ? 2 : 1;
        scratch = (long)(unsigned short)edgeBase + (long)halfHeight;
        TLIBA3_VmArrayPatternTable[i].c[1].val = (unsigned short)
            (((scratch +
               (long)(unsigned short)TLIBA3_VmArrayRuntimeTable[i].width2 /
                   divisor) & 0xFF) + 0xff00);

        rt = &TLIBA3_VmArrayRuntimeTable[i];
        if ((rt->flags0 & 0x0004) != 0)
            edge = (short)((((long)rt->width2 + 15) >> 3) & 0xfffe);
        else
            edge = 0;

        if (i == 0) {
            /* mode 0 takes the raw value */
        } else if ((TLIBA3_VmArrayRuntimeTable[i].flags0 & 0x8004) == 0x8004) {
            edge = edge - 4;
        } else if ((TLIBA3_VmArrayRuntimeTable[i].flags0 & 0x8000) != 0) {
            edge = edge - 4;
        } else if ((TLIBA3_VmArrayRuntimeTable[i].flags0 & 0x0004) != 0) {
            edge = edge - 2;
        } else {
            edge = edge - 2;
        }

        p = &TLIBA3_VmArrayPatternTable[i];
        p->c[4].val = edge;
        p->c[5].val = edge;
        p->c[6].val = TLIBA3_VmArrayRuntimeTable[i].flags0;
        p->c[7].val = extra;
        p->c[8].val = 0x24;

        rt = &TLIBA3_VmArrayRuntimeTable[i];
        p->c[9].val = (unsigned short)(rt->plane118 >> 16);
        p->c[10].val = (unsigned short)rt->plane118;
        p->c[11].val = (unsigned short)(rt->plane122 >> 16);
        p->c[12].val = (unsigned short)rt->plane122;
        p->c[13].val = (unsigned short)(rt->plane126 >> 16);
        p->c[14].val = (unsigned short)rt->plane126;
        p->c[15].val = (unsigned short)(rt->plane130 >> 16);
        p->c[16].val = (unsigned short)rt->plane130;
        p->c[17].val = (unsigned short)(rt->plane134 >> 16);
        p->c[18].val = (unsigned short)rt->plane134;
    }
}
