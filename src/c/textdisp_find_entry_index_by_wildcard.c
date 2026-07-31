/* RESTORES: TEXTDISP_FindEntryIndexByWildcard
 * MODULE:   modules/groups/b/a/textdisp3.s
 * STATUS:   behavioural
 *
 * Scans the primary group for the first entry whose title matches a wildcard
 * pattern, records its index, and answers whether one was found.
 *
 * Two details that are easy to invert:
 *
 *  - The match helper answers ZERO for a match. The original tests its result
 *    with TST.B / BNE and SKIPS the entry when non-zero, so the hit is the
 *    zero case. It is a byte result, not a long.
 *  - Entries with bit 3 of the byte at +27 set are skipped before the pattern
 *    is even tried.
 *
 * The saved-index store happens ONCE, before the loop, and copies memory to
 * memory (MOVE.W global,global). It is not part of the search.
 *
 * The count is compared with CMP.W against a plain MOVE.W load -- no
 * zero-extension -- so both it and the loop counter are signed shorts.
 *
 * 104 ref vs 100 got. The memory-to-memory saved-index store (33f9), the
 * ASL.L #2 table indexing, the BTST #3 skip, the ADDQ.W #8,A7 cleanup, the
 * TST.B result test and the MOVE.W D7,index store all match exactly.
 *
 * SASC-MISMATCH: widen-before-vs-after-copy
 *   ref:     2007 48c0 e580      MOVE.L D7,D0 / EXT.L D0 / ASL.L #2,D0
 *   got:     48c7 2007 e580      EXT.L D7 / MOVE.L D7,D0 / ASL.L #2,D0
 *   summary: the original copies the index and widens the copy; 6.51 widens in
 *            place then copies. Same three instructions, same size.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: link-frame-vs-none
 *   ref:     4e55fff4 ... 4e5d   LINK.W A5,#-12 / UNLK
 *   got:     (nothing)
 *   summary: the original opens a 12-byte frame it uses only to address the
 *            pattern parameter (2f2d0008); 6.51 reads it from A7 and needs no
 *            frame. The 4 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct TextDispWildcardEntry {
    char          pad0[27];
    unsigned char flags27;      /* +27 */
};

extern char UNKNOWN_JMPTBL_ESQ_WildcardMatch(char *title, char *pattern);

extern short  TEXTDISP_CurrentMatchIndex;
extern short  TEXTDISP_CurrentMatchIndexSaved;
extern short  TEXTDISP_PrimaryGroupEntryCount;
extern char  *TEXTDISP_PrimaryTitlePtrTable[];
extern struct TextDispWildcardEntry *TEXTDISP_PrimaryEntryPtrTable[];

long TEXTDISP_FindEntryIndexByWildcard(char *pattern)
{
    short i;

    TEXTDISP_CurrentMatchIndexSaved = TEXTDISP_CurrentMatchIndex;

    for (i = 0; i < TEXTDISP_PrimaryGroupEntryCount; i++) {
        if (!(TEXTDISP_PrimaryEntryPtrTable[i]->flags27 & 8)
            && UNKNOWN_JMPTBL_ESQ_WildcardMatch(TEXTDISP_PrimaryTitlePtrTable[i],
                                                pattern) == 0) {
            TEXTDISP_CurrentMatchIndex = i;
            return 1;
        }
    }
    return 0;
}
