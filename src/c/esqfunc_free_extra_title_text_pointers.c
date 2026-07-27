/* RESTORES: ESQFUNC_FreeExtraTitleTextPointers
 * MODULE:   modules/groups/a/n/esqfunc.s
 * STATUS:   behavioural
 *
 * Walks every primary entry and, within each, its title-text slots from the
 * caller's index downwards. The highest-numbered non-null slot is kept; every
 * non-null slot below it is released and cleared. The `keep` flag is what makes
 * it "extra" pointers rather than all of them.
 *
 * The slot index is clamped to 34 rather than checked, so a caller passing more
 * than the table holds walks the table's last slot instead of running off it.
 *
 * `entry` is assigned from the entry-pointer table on every iteration and never
 * read. It is in the original as a store to -4(A5) with no matching load, so the
 * local is kept: deleting it drops a store the original makes.
 *
 * 146 bytes in the original, 124 emitted. `tools/casm.py` itemises the whole -22
 * and every line of it is the frame class: three locals that live at -4(A5),
 * -8(A5) and -12(A5) in the original become A5, A3 and a plain register here.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffec ... 4e5d      LINK.W A5,#-20 / UNLK A5
 *   got:     48e70f34               MOVEM only, three more registers in the mask
 *   summary: The A5-frame class: -4 prologue, -2 epilogue, and then -2, -2, -4,
 *            -4, -4, -4 as each frame access becomes a register. The dead store
 *            noted above (MOVE.L A0,-12(A5) with no matching load) simply
 *            disappears, since the value it holds is already in a register.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: sign-extend-in-place
 *   ref:     2005 48c0        MOVE.L D5,D0 / EXT.L D0
 *   got:     48c5             EXT.L D5
 *   summary: Widening the short loop counter for the index multiply. The original
 *            copies to D0 and widens there, keeping the counter narrow; 6.51
 *            widens in place. Three sites, and each shows up in casm as a
 *            +2 / -2 pair, so the class costs nothing net.
 *
 * SASC-MISMATCH: ternary-branch-polarity
 *   ref:     6e06 ... 6002 7022     BGT to the clamp, fall through to the value
 *   got:     6f04 7022 6004 3007    BLE past the clamp
 *   summary: `from > 34 ? 34 : from` with the two arms in the opposite order.
 *            +4 in one hunk and -4 in the next; no net cost.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the one cross-unit call.
 */

extern void ESQPARS_ReplaceOwnedString(char *newText, char *old);

extern short TEXTDISP_PrimaryGroupEntryCount;
extern char *TEXTDISP_PrimaryEntryPtrTable[];
extern char *TEXTDISP_PrimaryTitlePtrTable[];

struct TitleRecord {
    char  pad[56];
    char *slots[35];
};

void ESQFUNC_FreeExtraTitleTextPointers(short from)
{
    char *entry;
    struct TitleRecord *rec;
    char *text;
    short i;
    short slot;
    short keep;

    for (i = 0; i < TEXTDISP_PrimaryGroupEntryCount; i++) {
        entry = TEXTDISP_PrimaryEntryPtrTable[i];
        rec = (struct TitleRecord *)TEXTDISP_PrimaryTitlePtrTable[i];
        keep = 0;

        for (slot = from > 34 ? 34 : from; slot >= 0; slot--) {
            text = rec->slots[slot];
            if (text) {
                if (keep) {
                    ESQPARS_ReplaceOwnedString(0, text);
                    rec->slots[slot] = 0;
                } else {
                    keep = 1;
                }
            }
        }
    }
}
