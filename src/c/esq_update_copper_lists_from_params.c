/* RESTORES: ESQ_UpdateCopperListsFromParams
 * MODULE:   modules/groups/a/a/app2_p1.s
 * STATUS:   behavioural
 *
 * Writes one highlight-effect bit across 16 rows of both copper effect lists,
 * rotating a packed seed by one bit per row.
 *
 * DATA ADJACENCY -- READ THIS BEFORE MOVING THE DATA SECTION TO C.
 * The original starts `MOVE.L _HIGHLIGHT_CopperEffectSeed,D0`, and that symbol
 * is `DC.W 0` followed by `_HIGHLIGHT_CopperEffectParamA` and
 * `_HIGHLIGHT_CopperEffectParamB`, both `DC.B 0`. So the long is
 * [seed hi][seed lo][ParamA][ParamB] -- THREE symbols read as one value. C
 * guarantees no such adjacency, so this file reads through a cast today and the
 * three must become one struct when src/data stops being assembly. Until then
 * the assembly layout is what makes the cast correct.
 *
 * ROTATE. coverage.py screens this function as `rotate-instruction`, and that
 * screen is about byte-exactness: C has no rotate operator and SAS/C emits
 * none, so `ROL.L #5` and `ROL.L #1` become a shift pair here. The VALUE is
 * identical for an unsigned long, so the screen blocks an exact match, not a
 * correct restoration.
 *
 * The seed arithmetic is byte-wide then word-wide on one register, which is why
 * each step masks: `ADD.B D0,D0` doubles the low BYTE and leaves the other
 * three alone, and `ADD.W D0,D0` doubles the low WORD and leaves the high word.
 * Writing them as a plain `d0 <<= 1` would carry across the boundaries and give
 * a different pattern.
 *
 * SASC-MISMATCH: rotate-and-swap-have-no-operator
 *   ref:     ROL.L #5,D0 / SWAP D0 / ROL.L #1,D0
 *   got:     shift pairs
 *   summary: three instructions C cannot spell. Same values, more bytes.
 *   retest:  a compiler that recognises the shift-pair idiom would emit ROL.
 *            Re-run tools/mismatches.py --recheck on a different SAS/C.
 */
#include <exec/types.h>

extern short HIGHLIGHT_CopperEffectSeed;    /* + ParamA + ParamB, read as a long */
extern UBYTE ESQ_CopperEffectTemplateRowsSet0[];
extern UBYTE ESQ_CopperEffectListA[];
extern UBYTE ESQ_CopperEffectListB[];

#define ROWS        16      /* MOVEQ #15,D4 then DBF */
#define EFFECT_BIT  0x100   /* MOVEA.W #$100,A6, ANDed against the seed */

long ESQ_UpdateCopperListsFromParams(void)
{
    UWORD tmpl = *(UWORD *)(ESQ_CopperEffectTemplateRowsSet0 + 26);
    UWORD *a = (UWORD *)(ESQ_CopperEffectListA + 6);
    UWORD *b = (UWORD *)(ESQ_CopperEffectListB + 6);
    UWORD base = (UWORD)(tmpl & ~EFFECT_BIT);       /* BCLR #8,D3 */
    ULONG seed = *(ULONG *)&HIGHLIGHT_CopperEffectSeed;
    short i;

    seed = (seed & 0xffffff00UL) | ((seed << 1) & 0xffUL);      /* ADD.B D0,D0 */
    seed = (seed & 0xffffff00UL) | ((seed << 1) & 0xffUL);      /* ADD.B D0,D0 */
    seed = (seed & 0xffff0000UL) | ((seed << 1) & 0xffffUL);    /* ADD.W D0,D0 */
    seed = (seed & 0xffff0000UL) | ((seed << 1) & 0xffffUL);    /* ADD.W D0,D0 */

    seed = (seed >> 16) | (seed << 16);                         /* SWAP D0 */
    if ((seed & 0xffUL) == 0)                                   /* TST.B D0 */
        seed = 0;
    seed = (seed << 5) | (seed >> 27);                          /* ROL.L #5,D0 */

    for (i = 0; i < ROWS; i++) {
        UWORD v = (UWORD)((EFFECT_BIT & (UWORD)seed) | base);

        a[0]  = v;  b[0]  = v;      /* +0   */
        a[2]  = v;  b[2]  = v;      /* +4   */
        a[68] = v;  b[68] = v;      /* +136 */
        a[70] = v;  b[70] = v;      /* +140 */

        a += 4;                     /* +8 bytes */
        b += 4;
        seed = (seed << 1) | (seed >> 31);                      /* ROL.L #1,D0 */
    }

    a[0]  = tmpl;  b[0]  = tmpl;
    a[68] = tmpl;  b[68] = tmpl;

    return 0;
}
