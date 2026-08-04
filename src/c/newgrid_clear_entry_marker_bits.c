/* RESTORES: NEWGRID_ClearEntryMarkerBits
 * MODULE:   modules/groups/b/a/newgrid2.s
 * STATUS:   behavioural
 *
 * 206 bytes in the original, 192 emitted, only FOUR differing regions.
 *
 * Reproduces: the mode gate that runs the primary block only when mode > 1 while
 * the secondary block always runs, both group walks bounded by their own entry
 * counts, the present-flag test placed INSIDE each loop so a cleared flag breaks
 * out rather than being checked once up front, the bit-4-of-byte-47 filter on
 * each entry, and the inner 1..48 sweep clearing bit 5 of aux[7+j].
 *
 * The present-flag placement is worth noting: checking it before the loop would
 * be the natural rewrite and would be equivalent only because the flag cannot
 * change mid-loop. The original tests it every iteration and this reproduces
 * that.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff0                   LINK.W A5,#-16
 *   got:     (none)                     MOVEM only
 *   summary: The A5-frame class. The entry and aux pointers stay in registers for
 *            SAS/C, which is the whole -14.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit calls.
 */
extern unsigned char *ESQDISP_GetEntryPointerByMode(long i, long mode);
extern unsigned char *ESQDISP_GetEntryAuxPointerByMode(long i, long mode);
extern short TEXTDISP_PrimaryGroupEntryCount;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern char  TEXTDISP_PrimaryGroupPresentFlag;
extern char  TEXTDISP_SecondaryGroupPresentFlag;

void NEWGRID_ClearEntryMarkerBits(short mode)
{
    unsigned char *entry;
    unsigned char *aux;
    register long i;
    register long j;

    if (mode > 1) {
        for (i = 0; i < TEXTDISP_PrimaryGroupEntryCount; i++) {
            if (TEXTDISP_PrimaryGroupPresentFlag == 0)
                break;
            entry = ESQDISP_GetEntryPointerByMode(i, 1);
            if (entry[47] & 0x10) {
                aux = ESQDISP_GetEntryAuxPointerByMode(i, 1);
                for (j = 1; j < 49; j++)
                    aux[7 + j] &= ~0x20;
            }
        }
    }

    for (i = 0; i < TEXTDISP_SecondaryGroupEntryCount; i++) {
        if (TEXTDISP_SecondaryGroupPresentFlag == 0)
            break;
        entry = ESQDISP_GetEntryPointerByMode(i, 2);
        if (entry[47] & 0x10) {
            aux = ESQDISP_GetEntryAuxPointerByMode(i, 2);
            for (j = 1; j < 49; j++)
                aux[7 + j] &= ~0x20;
        }
    }
}
