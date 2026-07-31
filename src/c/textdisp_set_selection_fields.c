/* RESTORES: TEXTDISP_SetSelectionFields
 * MODULE:   modules/groups/b/a/textdisp_p1.s
 * STATUS:   behavioural
 *
 * Stores a group mode, a display index and an entry index into a selection
 * record, clamping each, and resets the whole selection if any of them came out
 * invalid.
 *
 * The mode is passed through only when it is 1 or 2; anything else becomes 3,
 * which the reset test below then treats as invalid. So mode 3 is the
 * "no selection" marker rather than a real group.
 *
 * The display index is compared against the group's entry count, which is read
 * back through a call rather than a field, and the count is widened with
 * MOVEQ #0 / MOVE.W -- unsigned short.
 *
 * The entry index is valid only in 1..48 (TST.L / BLE, then MOVEQ #49 / CMP.L /
 * BGE), and it is stored as a WORD at +218 while the other two are longs.
 *
 * The reset condition RE-READS all three fields from the record rather than
 * using the values just computed, which is why the C below tests s->... rather
 * than the locals.
 *
 * 134 ref vs 144 got. The mode chain, the entry-count call, the MOVEQ #49
 * bound, all three field stores at +210, +214 and +218, the CLR.B at +220 and
 * the three-way reset test all match in kind and size.
 *
 * SASC-MISMATCH: result-through-d0-vs-per-arm-store
 *   ref:     2006 6002 70ff 274000d6      one store, fed by two arms
 *   got:     70ff 2b4000d6 6006 2006 2b4000d6
 *                                          a store in each arm
 *   summary: the original computes the clamped value into D0 and stores it
 *            ONCE after the branches rejoin; 6.51 duplicates the store into
 *            both arms. Same field, same two values, 10 bytes more across the
 *            two clamps.
 *   tried:   computing each clamp into a local and storing the local after the
 *            if, which is the fix that worked in
 *            textdisp_should_open_editor_for_entry.c. Here it is much WORSE:
 *            144 -> 156 against the original's 134. 6.51 keeps the duplicated
 *            store AND adds a frame to hold the locals. REJECTED, and the two
 *            results together are the useful record -- the temporary trick
 *            helps a register-sized 1/0 result and hurts a struct-field
 *            clamp.
 *   scope:   any clamp written as an if/else onto a struct field.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct TextDispSelection {
    char  pad0[210];
    long  mode;                 /* +210 */
    long  displayIndex;         /* +214 */
    short entryIndex;           /* +218 */
    char  flag220;              /* +220 */
};

extern short TEXTDISP_GetGroupEntryCount(long mode);
extern void  TEXTDISP_ResetSelectionState(struct TextDispSelection *s);

void TEXTDISP_SetSelectionFields(struct TextDispSelection *s, long mode,
                                 long displayIndex, long entryIndex)
{
    long m;

    if (s == 0)
        return;

    if (mode == 1 || mode == 2)
        m = mode;
    else
        m = 3;
    s->mode = m;

    if (displayIndex >= (long)(unsigned short)TEXTDISP_GetGroupEntryCount(m))
        s->displayIndex = -1;
    else
        s->displayIndex = displayIndex;

    if (entryIndex > 0 && entryIndex < 49)
        s->entryIndex = (short)entryIndex;
    else
        s->entryIndex = -1;

    s->flag220 = 0;

    if (s->mode == 3 || s->displayIndex == -1 || s->entryIndex == -1)
        TEXTDISP_ResetSelectionState(s);
}
