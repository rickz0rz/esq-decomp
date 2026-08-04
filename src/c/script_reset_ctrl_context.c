/* RESTORES: SCRIPT_ResetCtrlContext
 * MODULE:   modules/groups/b/a/script3b_p0_p1_p0.s
 * STATUS:   behavioural
 *
 * Resets a CTRL context record to defaults.
 *
 * Only two fields get a non-zero value: the byte at +437 becomes 120 and the
 * word at +426 becomes 1. Everything else is cleared, and the owned string at
 * +440 is released through ReplaceOwnedString rather than simply zeroed.
 *
 * The zero stores come from THREE separate registers in the original, and the
 * grouping is reproduced because AGENTS.md records that the chain must stop
 * where the original's does:
 *
 *   MOVEQ #0,D0 -> the five WORDS at +6, +4, +10, +12, +14 (in that store order)
 *   MOVEQ #0,D1 -> the two LONGS at +16 and +20
 *   the same D0 -> the word at +24, on its own
 *
 * A C chained assignment stores its rightmost target first, so each chain below
 * is written in the reverse of the order the stores appear.
 *
 * The two 4-byte arrays at +428 and +432 are cleared by one loop that indexes
 * both, with the offsets computed as full longs (ADDI.L #428 / ADDI.L #432).
 *
 * 140 ref vs 136 got. All four byte fields, the MOVEQ #120, the MOVE.W #1 at
 * +426, the ReplaceOwnedString call with its CLR.L push, the five-word chain,
 * the two-long chain and the standalone word at +24 all match in kind, order
 * and size -- which is the evidence that the chain GROUPING above is right.
 *
 * SASC-MISMATCH: zero-through-register-vs-clr
 *   ref:     7000 174001b4 ... 174001b6 174001b7
 *            MOVEQ #0,D0 then MOVE.B D0 to each field
 *   got:     422d01b4 ... 422d01b6 422d01b7
 *            CLR.B on each field
 *   summary: the original builds zero once and stores it from the register;
 *            6.51 emits CLR.B per field. Same stores, 6.51 two bytes cheaper at
 *            the first and even at the rest.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: indexed-clear-vs-register-store
 *   ref:     700022070681000001ac 17801800    MOVEQ #0 / index / MOVE.B D0,(A3,D1.L)
 *   got:     20070680000001ac 42350800        index / CLR.B (A3,D1.L)
 *   summary: inside the array loop 6.51 clears the byte in place where the
 *            original stores a zeroed register, and it also folds the ADDI.L
 *            into the index register it already has. Same two stores per
 *            iteration.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct ScriptCtrlContext {
    char  pad0[4];
    short f4;                   /* +4   */
    short f6;                   /* +6   */
    char  pad8[2];
    short f10;                  /* +10  */
    short f12;                  /* +12  */
    short f14;                  /* +14  */
    long  f16;                  /* +16  */
    long  f20;                  /* +20  */
    short f24;                  /* +24  */
    char  f26;                  /* +26  */
    char  pad27[199];
    char  f226;                 /* +226 */
    char  pad227[199];
    short f426;                 /* +426 */
    char  arr428[4];            /* +428 */
    char  arr432[4];            /* +432 */
    char  f436;                 /* +436 */
    char  f437;                 /* +437 */
    char  f438;                 /* +438 */
    char  f439;                 /* +439 */
    char *owned;                /* +440 */
};

extern char *ESQPARS_ReplaceOwnedString(char *newStr, char *old);

void SCRIPT_ResetCtrlContext(struct ScriptCtrlContext *c)
{
    long i;

    c->f436 = 0;
    c->f437 = 120;
    c->f438 = 0;
    c->f439 = 0;

    c->owned = ESQPARS_ReplaceOwnedString(0, c->owned);

    c->f26 = c->f226 = 0;

    c->f14 = c->f12 = c->f10 = c->f4 = c->f6 = 0;
    c->f20 = c->f16 = 0;
    c->f24 = 0;

    c->f426 = 1;

    for (i = 0; i < 4; i++) {
        c->arr428[i] = 0;
        c->arr432[i] = 0;
    }
}
