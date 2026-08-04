/* RESTORES: TEXTDISP_ShouldOpenEditorForEntry
 * MODULE:   modules/groups/b/a/textdisp_p1_2.s
 * STATUS:   behavioural
 *
 * Same shape as esqdisp_test_entry_bits0and2_core.c -- a null guard, two bit
 * tests on one flag byte, and a 1/0 result assigned through a single variable.
 * This one adds a call between the second bit test and the result, plus a
 * third bit test on the byte at offset 27.
 *
 * The caller textdisp_build_match_index_list.c already declares this as
 * `long TEXTDISP_ShouldOpenEditorForEntry(unsigned char *entry)`, so the
 * signature is fixed by an existing restoration.
 *
 * 66 ref vs 64 got, in two items that account for the 2 bytes exactly.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     48e70110 266f000c 082b...   MOVEM D7/A3 / MOVEA.L 12(A7),A3 / BTST ...(A3)
 *   got:     48e70104 2a6f000c 082d...   MOVEM D7/A5 / MOVEA.L 12(A7),A5 / BTST ...(A5)
 *   summary: the pointer parameter lives in A3 in the original and A5 in 6.51.
 *            Same instructions, same sizes, one register apart. Root cause is
 *            settled: the original reserves A5 as a frame pointer, so its first
 *            free address register is A3.
 *   scope:   program-wide. See docs/compiler-version.md, "The A3/A5 divergence
 *            has a single root cause".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 *
 * THE RESULT IS BUILT THROUGH AN EXPLICIT TEMPORARY, and that is measured.
 * Assigning the 1/0 straight to the result variable emits
 * `7e01 6002 7e00` -- MOVEQ into the result register in each arm, 64 bytes.
 * Routing it through a separate local reintroduces the original's own shape:
 *
 *     ref  7001 6002 7000 2e00    MOVEQ #1,D0 / BRA / MOVEQ #0,D0 / MOVE.L D0,D7
 *     got  7c01 6002 7c00 2e06    the same four instructions, one register apart
 *
 * and takes the function from 64 bytes to 66 against the original's 66. The
 * extra MOVE is not waste -- it is what the original does, and matching it is
 * worth 2 bytes of "growth" per AGENTS.md rule 1.
 */
struct TextDispEntry {
    char          pad27[27];
    unsigned char flags27;
    char          pad40[12];
    unsigned char flags40;
};

extern long NEWGRID_ShouldOpenEditor(struct TextDispEntry *e);

long TEXTDISP_ShouldOpenEditorForEntry(struct TextDispEntry *e)
{
    long r = 0;
    long t;

    if (e != 0) {
        if ((e->flags40 & 1) && (e->flags40 & 8)
            && NEWGRID_ShouldOpenEditor(e) == 0
            && (e->flags27 & 8) == 0)
            t = 1;
        else
            t = 0;
        r = t;
    }
    return r;
}
