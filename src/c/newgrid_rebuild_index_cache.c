/* RESTORES: NEWGRID_RebuildIndexCache
 * MODULE:   modules/groups/b/a/newgrid1.s
 * STATUS:   behavioural
 *
 * 162 bytes in the original, 152 emitted, 7 differing regions.
 *
 * Reproduces: the null-cache early return taken before anything is touched, the
 * save-and-restore of ESQPARS2_ReadModeFlags around the whole rebuild with 0x100
 * forced in between, the full 0x12e-entry clear to -1 done before any lookup, and
 * the rebuild loop with its three rejections (null entry, no wildcard match, or a
 * match past the secondary group's own count).
 *
 * The clear pass runs over 0x12e entries regardless of how many groups actually
 * exist, so stale indices from a previous larger data set cannot survive. Sizing
 * that loop to the current count would be the obvious optimisation and would
 * reintroduce exactly the staleness the pass exists to prevent.
 *
 * The wildcard search is given entry+12, not the entry itself -- the match runs
 * against a field twelve bytes in, not against the record head.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff0                   LINK.W A5,#-16
 *   got:     (none)                     MOVEM only
 *   summary: The A5-frame class. The entry pointer stays in a register for SAS/C
 *            where the original spills it, which is the whole -10.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls.
 */
extern unsigned char *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(long i, long mode);
extern long NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(char *s);
extern long *NEWGRID_SecondaryIndexCachePtr;
extern short ESQPARS2_ReadModeFlags;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern short TEXTDISP_SecondaryGroupEntryCount;

void NEWGRID_RebuildIndexCache(void)
{
    unsigned char *entry;
    register long i;
    register long idx;
    register short saved;

    if (NEWGRID_SecondaryIndexCachePtr == 0)
        return;

    saved = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = 0x100;

    for (i = 0; i < 0x12e; i++)
        NEWGRID_SecondaryIndexCachePtr[i] = -1;

    for (i = 0; i < TEXTDISP_PrimaryGroupEntryCount; i++) {
        entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i, 1);
        if (entry == 0)
            continue;
        idx = NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex((char *)entry + 12);
        if (idx <= -1)
            continue;
        if (idx >= TEXTDISP_SecondaryGroupEntryCount)
            continue;
        NEWGRID_SecondaryIndexCachePtr[i] = idx;
    }

    ESQPARS2_ReadModeFlags = saved;
}
