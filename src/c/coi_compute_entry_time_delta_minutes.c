/* RESTORES: COI_ComputeEntryTimeDeltaMinutes
 * MODULE:   modules/groups/a/e/coi.s
 * STATUS:   behavioural
 *
 * 190 bytes in the original, 228 emitted, 7 differing regions -- few regions but
 * a large delta, so the difference is concentrated rather than spread.
 *
 * Reproduces: the -1 sentinel returned for out-of-range slots, the forward scan
 * for the next populated slot pointer at entry+56, the fallback that re-resolves
 * through a wildcard match into the secondary table and rescans from slot 1, the
 * sentinel reset when that resolution fails, and the two outcomes -- the
 * 2880-minus-elapsed formula when nothing was found, or a delegated time-offset
 * computation when it was.
 *
 * NOTE on the multiply rule. This function computes CLOCK_HalfHourSlotIndex * 30
 * with an inline MULU #30 -- NOT a call to MATH_Mulu32. Taken with the helper
 * calls recorded in ed_handle_edit_attributes_menu.c and
 * tliba3_init_runtime_entry.c, the original's rule is narrower than previously
 * stated: 16-bit multiplies go inline through MULU, and only 32-bit multiplies
 * call the helper. The earlier files say "every multiply by a small constant",
 * which is too broad and is corrected here.
 *
 * SASC-MISMATCH: unattributed-loop-expansion
 *   summary: The +38 bytes are NOT itemised. The original shares a single tail
 *            between the two scan loops and the sentinel reset, reached from four
 *            separate branches; SAS/C emits the comparison and branch structure
 *            separately for each. That accounts for the shape of the difference
 *            but not for every byte of it.
 *   NOTE:    recorded as a known-unknown, like the tail delta in
 *            cleanup_release_display_resources.c. Do not promote this to exact on
 *            a new compiler without accounting for the 38 bytes first.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */
extern short TLIBA_FindFirstWildcardMatchIndex(unsigned char *entry);
extern unsigned char *ESQDISP_GetEntryAuxPointerByMode(long i, long mode);
extern long TEXTDISP_ComputeTimeOffset(long code, unsigned char *entry,
                                                       long slot);
extern char  TEXTDISP_PrimaryGroupCode;
extern unsigned short CLOCK_HalfHourSlotIndex;

long COI_ComputeEntryTimeDeltaMinutes(unsigned char *entry, short slot)
{
    register short i;
    register long result;

    i = 49;
    result = -1;

    if (slot <= 0)
        return result;
    if (slot >= 49)
        return result;

    for (i = slot + 1; i < 49; i++)
        if (((long *)(entry + 56))[i])
            break;

    if (i > 48 && entry[498] == TEXTDISP_PrimaryGroupCode) {
        i = TLIBA_FindFirstWildcardMatchIndex(entry);
        entry = ESQDISP_GetEntryAuxPointerByMode((long)i, 2);
        if (entry == 0) {
            i = 49;
        } else {
            for (i = 1; i < 49; i++)
                if (((long *)(entry + 56))[i])
                    break;
        }
    }

    if (i > 48)
        result = 2880 - (long)(CLOCK_HalfHourSlotIndex * 30);
    else
        result = TEXTDISP_ComputeTimeOffset((long)entry[498], entry,
                                                            (long)i);
    return result;
}
