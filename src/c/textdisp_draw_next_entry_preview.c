/* RESTORES: TEXTDISP_DrawNextEntryPreview
 * MODULE:   modules/groups/b/a/textdisp2_p0_p0.s
 * STATUS:   behavioural
 *
 * Walks the entry table forward, wrapping at 46, until it finds an entry whose
 * word at +4 is 1, draws that entry's preview, and leaves the cursor one past
 * it.
 *
 * The wrap is the REMAINDER of MATH_DivS32, not its quotient: the original
 * stores D1 back (33c1), not D0. That is the documented register-argument
 * helper class -- the remainder cannot be reached through a C return value at
 * all, so this is written with the C % operator and SAS/C calls its own helper.
 * Getting this backwards is what once divided by whatever happened to be in D1;
 * see tliba3_get_view_mode_height.c.
 *
 * LADFUNC_EntryCount is a short that is EXT.L-widened at every use, so it is
 * signed, and the final bump is a word add on the global itself (ADDQ.W #1).
 *
 * 84 ref vs 80 got -- the restoration is SMALLER, and the reason is worth
 * reading rather than treating as a win.
 *
 * SASC-MISMATCH: reload-vs-cse
 *   ref:     30390000a2e0 48c0       MOVE.W count,D0 / EXT.L D0
 *   got:     48c0                    EXT.L D0
 *   summary: entering the wrap, the original RE-READS LADFUNC_EntryCount from
 *            memory even though the loop test loaded it two instructions
 *            earlier. 6.51 keeps the loaded value and eliminates the second
 *            read, saving the 6-byte load. Same value either way -- nothing
 *            between the two points can change the global.
 *   tried:   nothing from the source side. The C is a single expression over
 *            the global, which is exactly the shape the original compiled from;
 *            the difference is common-subexpression elimination, not spelling.
 *   scope:   anywhere a global is read twice in one expression chain.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: index-shift-needs-a-copy
 *   ref:     e580                    ASL.L #2,D0
 *   got:     2200 e581               MOVE.L D0,D1 / ASL.L #2,D1
 *   summary: scaling the table index, the original shifts in place and 6.51
 *            copies first. +2. The same 2 bytes appear in the compare pairing
 *            (7001 b069 against 7201 b269).
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: register-argument-helper-vs-operator
 *   ref:     722e 4eba6410 33c1...   MOVEQ #46,D1 / JSR MATH_DivS32 / MOVE.W D1,count
 *   got:     722e 61000000 33c1...   the same, calling SAS/C's own helper
 *   summary: the original takes the REMAINDER from D1, which is what
 *            MATH_DivS32 leaves there alongside the quotient in D0. Written
 *            with % because a C return value cannot reach D1 at all.
 *   scope:   program-wide. See cleanup_process_alerts.c and coi_load_oi_data_file.c.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct LadfuncEntry {
    char  pad0[4];
    short state;                /* +4 */
};

extern void  TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview(long index);
extern short LADFUNC_EntryCount;
extern struct LadfuncEntry *LADFUNC_EntryPtrTable[];

void TEXTDISP_DrawNextEntryPreview(void)
{
    while (LADFUNC_EntryPtrTable[LADFUNC_EntryCount]->state != 1)
        LADFUNC_EntryCount = (short)(((long)LADFUNC_EntryCount + 1) % 46);

    TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview((long)LADFUNC_EntryCount);
    LADFUNC_EntryCount++;
}
