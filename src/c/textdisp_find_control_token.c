/* RESTORES: TEXTDISP_FindControlToken
 * MODULE:   modules/groups/b/a/textdisp3_p1.s
 * STATUS:   behavioural
 *
 * Scans a string for the first embedded control token and returns a pointer to
 * it, or NULL. A token is a high-bit byte drawn from a fixed thirteen-value set.
 *
 * 88 bytes against 120, and casm.py puts the WHOLE +32 in one region: the set
 * test. Everything around it -- the loop, the high-bit test, the pointer bump,
 * both returns -- aligns instruction for instruction.
 *
 * SASC-MISMATCH: switch-not-chained
 *   ref:     04400084 6730 5340 672c 5340 6728 ...
 *            SUBI.W #$84 then SUBQ.W/BEQ.S per case, each consuming the running
 *            difference: 4 bytes a case, 64 bytes for the whole set.
 *   got:     the same thirteen cases in 96 bytes.
 *   summary: this is the chained-subtract dispatcher shape AGENTS.md records for
 *            the ED key handlers, but the recipe that works there does not work
 *            here. SHORTINT alone, SHORTINT with an (int) selector, and SHORTINT
 *            with an explicit `register short` selector give +32, +32 and +40 --
 *            the short selector is the WORST of the three, so this is not simply
 *            a width problem.
 *   tried:   switch(*p), switch((int)*p), and a `register short` selector, each
 *            with and without SHORTINT.
 *   scope:   dispatchers over a sparse case set. The ED handlers that do collapse
 *            step through dense runs; this one has gaps of 5, 2, 3, 6 and 8,
 *            which may be what stops the chain forming.
 *   retest:  a compiler that emits SUBQ.W/BEQ.S per case here takes 32 bytes off
 *            at once, and it is a clean single-class probe because nothing else
 *            in the function differs at all.
 */
unsigned char *TEXTDISP_FindControlToken(unsigned char *p)
{
    while (*p) {
        if (*p & 0x80) {
            switch (*p) {
            case 0x84: case 0x85: case 0x86: case 0x87:
            case 0x8C: case 0x8D: case 0x8F: case 0x90:
            case 0x93: case 0x99: case 0x9A: case 0x9B:
            case 0xA3:
                return p;
            }
        }
        p++;
    }
    return 0;
}
