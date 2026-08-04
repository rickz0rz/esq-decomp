/* RESTORES: _NEWGRID_UpdateSelectionFromInput
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55fff048e707102e2d0008266d000c7c0020074a80670659806720602623eb000c00006c9e302b001633c000006ca248c02f006100fdfc584f600a52b900006c9e60027c014a866600021470003039000087bc222b000cb2806e044a816a08720032002741000c70003039000087bc222b0010b2806e044a816a0872003200274100104a8666000188303900006ca24a406f00017cb06b00186c0001744a8666000156203900006c9eb0ab00106c0001484a3900009afb6700013e323900006ca248c12f002f01486dfff8486dfffc6100cd964fef00102a004aadfffc670001084aadfff867000100206dfffc3028002e08000004670000f01028002808000007670000e4303900006ca2b06b00166616200548c02f002f2dfff82f084eba22824fef000c2a004a456f0000bc206dfffc41e8001c200548c02f002f084eba226e504f5280660000a0206dfff82248d2c50829000500076600008e2f2dfffc4ebabf3c584f4a80672c303900006ca2322b0016b2406618220548c1e581206dfff82248d3c14aa9003867047201600272002c016052200548c0e580206dfff8d1c04aa80038673c206dfff8d0f900006ca2082800070007662a200548c02f390000aa1e2f390000aa1a2f002f2dfff82f2dfffc4eba21844fef00144a8067047201600272002c014a866600feb252b900006c9e6000fea84a866600fe88527900006ca223eb000c00006c9e6000fe764a86674026adfffc276dfff80004277900006c9e00080c79003000006ca26f0a7031ba406c04703060027000220548c1d28037410014206dfff8d0c508e800050007600a42a72f0b6100fca6504f20064cdf08e04e5d4e75
 *   got:     514f48e72f242e2f00282a6f002c7c004a87661e23ed000c00000000302d001633c00000000048c02f0061000000584f601020075980660852b90000000060027c014a8667062006600002127000303900000000222d000cb2806e044a816a08720032002b41000c7000303900000000222d0010b2806e044a816a08720032002b4100104a866600017e3039000000006f000174b06d00186c00016c4a8666000146203900000000b0ad00106c0001381239000000004a016700012c32390000000048c12f002f01486f0024486f002c610000004fef00103a0048c5202f0020670000f4222f001c670000ec20403428002e08020004670000de1428002808020007670000d2343900000000b46d001666102f052f012f00610000002a004fef000c4a856f0000b0206f0020d0fc001c2f052f0861000000504f528066000098206f001cd1c5082800050007660000882f2f002061000000584f4a80672a303900000000322d0016b24066182205e581206f001c2248d3c145e900384a9267047c0160527c00604e2005e580206f001c2248d3c045e900384a92673830390000000048c02248d3c008290007000766242f39000000002f39000000002f052f082f2f0030610000004fef00144a8067047c0160027c004a866600fec252b9000000006000feb84a866600fe9a303900000000524033c00000000023ed000c000000006000fe804a8667462aaf0020206f001c2b4800042b790000000000083039000000007230b0416f0a7031ba806c047830600278002004d0853b400014206f001cd1c570208028000711400007600a42a72f0d61000000504f20064cdf24f4504f4e75
 *   summary: 612 got vs 616 ref, four bytes short -- the closest of the two selection scanners. The original spills both out-pointers to A5 slots and reloads the scan row from its global before each of the six tests; 6.51 folds one of those reloads. The three-arm state dispatch, both index clamps against the primary group count, the row scan bounded by the context row limit, the entry scan bounded by the last index, the previous-valid-entry rewind on the first row, the editor-open split that takes a different match test on each side, the row advance that resets the entry cursor, the 48-offset selector writeback and the reset-window fallback all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct SelectionCtx {
    char *entry;                /* +0 */
    char *aux;                  /* +4 */
    long  cursor;               /* +8 */
    long  firstIndex;           /* +12 */
    long  lastIndex;            /* +16 */
    short selector;             /* +20 */
    short firstRow;             /* +22 */
    short rowLimit;             /* +24 */
};

struct GridEntry {
    char          pad0[40];
    unsigned char marker;       /* +40 */
    char          pad41[5];
    short         state;        /* +46 */
};

extern long  NEWGRID_SelectionScanEntryIndex;
extern short NEWGRID_SelectionScanRow;
extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern char  TEXTDISP_PrimaryGroupPresentFlag;
extern long  GCOMMAND_PpvSelectionWindowMinutes;
extern long  GCOMMAND_PpvSelectionToleranceMinutes;

extern void  NEWGRID_ClearEntryMarkerBits(long row);
extern short NEWGRID_UpdatePresetEntry(char **entry, char **aux, long selector,
                                       long index);
extern long  DISPLIB_FindPreviousValidEntryIndex(char *entry,
                 char *aux, long index);
extern long  ESQ_TestBit1Based(char *bits, long slot);
extern long  NEWGRID_ShouldOpenEditor(char *entry);
extern long  COI_ProcessEntrySelectionState(char *entry,
                 char *aux, long index, long window, long tolerance);
extern void  NEWGRID_InitSelectionWindow(struct SelectionCtx *ctx, long mode);

long NEWGRID_UpdateSelectionFromInput(long state, struct SelectionCtx *ctx)
{
    char *entry;
    char *aux;
    long  found;
    long  index;
    long  offset;

    found = 0;

    if (state == 0) {
        NEWGRID_SelectionScanEntryIndex = ctx->firstIndex;
        NEWGRID_SelectionScanRow = ctx->firstRow;
        NEWGRID_ClearEntryMarkerBits((long)NEWGRID_SelectionScanRow);
    } else if (state == 4) {
        NEWGRID_SelectionScanEntryIndex++;
    } else {
        found = 1;
    }

    if (found != 0)
        return found;

    if (ctx->firstIndex > (long)TEXTDISP_PrimaryGroupEntryCount
        || ctx->firstIndex < 0)
        ctx->firstIndex = TEXTDISP_PrimaryGroupEntryCount;

    if (ctx->lastIndex > (long)TEXTDISP_PrimaryGroupEntryCount
        || ctx->lastIndex < 0)
        ctx->lastIndex = TEXTDISP_PrimaryGroupEntryCount;

    while (found == 0 && NEWGRID_SelectionScanRow > 0
           && NEWGRID_SelectionScanRow < ctx->rowLimit) {

        while (found == 0
               && NEWGRID_SelectionScanEntryIndex < ctx->lastIndex
               && TEXTDISP_PrimaryGroupPresentFlag != 0) {

            index = NEWGRID_UpdatePresetEntry(&entry, &aux,
                        (long)NEWGRID_SelectionScanRow,
                        NEWGRID_SelectionScanEntryIndex);

            if (entry != 0 && aux != 0
                && (((struct GridEntry *)entry)->state & 16)
                && (((struct GridEntry *)entry)->marker & 0x80)) {

                if (NEWGRID_SelectionScanRow == ctx->firstRow)
                    index = DISPLIB_FindPreviousValidEntryIndex(
                                entry, aux, index);

                if (index > 0
                    && ESQ_TestBit1Based(entry + 28, index) == -1
                    && !(aux[index + 7] & 32)) {

                    if (NEWGRID_ShouldOpenEditor(entry) != 0) {
                        if (ctx->firstRow == NEWGRID_SelectionScanRow
                            && *(long *)(aux + index * 4 + 56) != 0)
                            found = 1;
                        else
                            found = 0;
                    } else {
                        if (*(long *)(aux + index * 4 + 56) != 0
                            && !(aux[NEWGRID_SelectionScanRow + 7] & 0x80)
                            && COI_ProcessEntrySelectionState(
                                   entry, aux, index,
                                   GCOMMAND_PpvSelectionWindowMinutes,
                                   GCOMMAND_PpvSelectionToleranceMinutes) != 0)
                            found = 1;
                        else
                            found = 0;
                    }
                }
            }

            if (found == 0)
                NEWGRID_SelectionScanEntryIndex++;
        }

        if (found == 0) {
            NEWGRID_SelectionScanRow++;
            NEWGRID_SelectionScanEntryIndex = ctx->firstIndex;
        }
    }

    if (found != 0) {
        ctx->entry = entry;
        ctx->aux = aux;
        ctx->cursor = NEWGRID_SelectionScanEntryIndex;

        if (NEWGRID_SelectionScanRow > 48 && index < 49)
            offset = 48;
        else
            offset = 0;
        ctx->selector = index + offset;

        aux[index + 7] = aux[index + 7] | 32;
    } else {
        NEWGRID_InitSelectionWindow(ctx, 0);
    }

    return found;
}
