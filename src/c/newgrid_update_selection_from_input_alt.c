/* RESTORES: NEWGRID_UpdateSelectionFromInputAlt
 * MODULE:   modules/groups/b/a/newgrid1bb_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-and-cursor-reload
 *   ref:     4e55fff048e70f102e2d0008266d000c2c2d00107a0020070c80000000066450d040303b00064efb0004000a0028004400400038004042b900006cbc302b001633c000006cc048c02f002f066100fe4a504f601e52b900006cbc33eb001600006cc0600e527900006cc060067a0160027e054a85660001ec4a856600019e70003039000087bc223900006cbcb2806c00018a4a3900009afb670001807005be8067000178303900006cc048c02f012f00486dfff8486dfffc6100ba7a2e862f2dfff82f2dfffc6100fd764fef00184a80670001244a856600011e303900006cc04a406f000112b06b00186c00010a7231b041661e48c02f3900006cbc2f00486dfff8486dfffc6100ba2c4fef00102800600c28007230b8416f04044400304aadfffc670000c24aadfff8670000ba303900006cc0b06b00166618200448c02f002f2dfff82f2dfffc4eba0f244fef000c28004a446f00008c206dfffc41e8001c200448c02f002f084eba0f10504f52806670206dfff82248d2c408290005000766602248d2f900006cc00829000700076650200448c0e580d1c04aa800386742200448c02f390000060c487805a02f002f2dfff82f2dfffc4eba0e6c4fef00144a80671e7001bc806614200448c02f002f2dfff84eba6288504f4a8067047201600272002a014a856600feea527900006cc06000fee04a856600fe7e7004be8066067e056000fe7233eb001600006cc052b900006cbc6000fe604a8567447005be80673e26adfffc276dfff80004277900006cbc00080c79003000006cc06f0a7031b8406c04703060027000220448c1d28037410014206dfff8d0c408e8000500074a85660891c826882748000420054cdf08f04e5d4e75
 *   got:     9efc000c48e72f242c2f00342e2f002c2a6f00307a0020070c80000000066458d040303b00064efb0004000a0028004c00480038004842b900000000302d001633c00000000048c02f002f0661000000504f602652b90000000033ed0016000000006016303900000000524033c00000000060067a0160027e054a85660001f44a85660001967000303900000000223900000000b2806c0001821039000000004a006700017620075b806700016e30390000000048c02f012f00486f0028486f0030610000002e862f2f00302f2f0038610000004fef00184a806700011a4a85660001143039000000006f00010ab06d00186c0001027231b041662048c02f39000000002f00486f0028486f0030610000004fef0010380048c4600c380048c47230b8816f029881202f0024670000b0222f0020670000a8343900000000b46d001666102f042f012f006100000028004fef000c4a846f000084206f0024d0fc001c2f042f0861000000504f5280666c206f00202248d3c4082900050007665c30390000000048c02248d3c008290007000766482004e5802248d3c045e900384a9267382f3900000000487805a02f042f082f2f0034610000004fef00144a80671a2006538066102f042f2f002461000000504f4a8067047a0160027a004a856600fefc303900000000524033c0000000006000feea4a856600fe862007598066067e056000fe7a33ed00160000000052b9000000006000fe684a85675420075b80674e2aaf0024206f00202b4800042b790000000000083039000000007230b0416f0e7031b8806c0870302f40001c600670002f40001c202f001cd0843b400014206f0020d1c4702080280007114000074a856606429542ad000420054cdf24f4defc000c4e75
 *   summary: 648 got vs 632 ref. The original spills the entry and aux out-pointers to A5 slots and reloads the entry cursor from its global before each of the eight tests; 6.51 reloads it at three more of them. The six-entry state jump table has the same shape, including states 3 and 5 sharing the found arm and state 2 sharing the default. The row scan with its three exit conditions, the inner entry scan, the 49-selector re-fetch, the 48-offset normalisation, the previous-valid-entry rewind when the cursor is at the first entry, all six per-entry guards including the mode-1 grid-eligibility test, the state-4 to state-5 promotion, the row advance and the 48-offset selector writeback match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct AltSelectionCtx {
    char *entry;                /* +0 */
    char *aux;                  /* +4 */
    long  row;                  /* +8 */
    char  pad12[8];
    short selector;             /* +20 */
    short firstEntry;           /* +22 */
    short entryLimit;           /* +24 */
};

extern long NEWGRID_AltSelectionRowCursor;
extern short NEWGRID_AltSelectionEntryCursor;
extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern char TEXTDISP_PrimaryGroupPresentFlag;
extern long CONFIG_TimeWindowMinutes;

extern void NEWGRID_ClearMarkersIfSelectable(long mode, long entry);
extern short NEWGRID_UpdatePresetEntry(char **entry, char **aux, long selector,
                                       long row);
extern long NEWGRID_TestEntrySelectable(char *entry, char *aux, long mode);
extern long DISPLIB_FindPreviousValidEntryIndex(char *entry,
                char *aux, long index);
extern long ESQ_TestBit1Based(char *bits, long slot);
extern long COI_ProcessEntrySelectionState(char *entry,
                char *aux, long index, long window, long fallback);
extern long ESQDISP_TestEntryGridEligibility(char *aux,
                long index);

long NEWGRID_UpdateSelectionFromInputAlt(long state,
                                         struct AltSelectionCtx *ctx, long mode)
{
    char *entry;
    char *aux;
    long  found;
    long  index;
    long  offset;

    found = 0;

    switch (state) {
    case 0:
        NEWGRID_AltSelectionRowCursor = 0;
        NEWGRID_AltSelectionEntryCursor = ctx->firstEntry;
        NEWGRID_ClearMarkersIfSelectable(mode,
            (long)NEWGRID_AltSelectionEntryCursor);
        break;
    case 1:
        NEWGRID_AltSelectionRowCursor++;
        NEWGRID_AltSelectionEntryCursor = ctx->firstEntry;
        break;
    case 4:
        NEWGRID_AltSelectionEntryCursor++;
        break;
    case 3:
    case 5:
        found = 1;
        break;
    default:
        state = 5;
        break;
    }

    if (found == 0) {
        while (found == 0
               && NEWGRID_AltSelectionRowCursor
                    < (long)TEXTDISP_PrimaryGroupEntryCount
               && TEXTDISP_PrimaryGroupPresentFlag != 0
               && state != 5) {

            NEWGRID_UpdatePresetEntry(&entry, &aux,
                (long)NEWGRID_AltSelectionEntryCursor,
                NEWGRID_AltSelectionRowCursor);

            if (NEWGRID_TestEntrySelectable(entry, aux, mode) != 0) {
                while (found == 0
                       && NEWGRID_AltSelectionEntryCursor > 0
                       && NEWGRID_AltSelectionEntryCursor < ctx->entryLimit) {

                    if (NEWGRID_AltSelectionEntryCursor == 49) {
                        index = NEWGRID_UpdatePresetEntry(&entry, &aux,
                            (long)NEWGRID_AltSelectionEntryCursor,
                            NEWGRID_AltSelectionRowCursor);
                    } else {
                        index = NEWGRID_AltSelectionEntryCursor;
                        if (index > 48)
                            index -= 48;
                    }

                    if (entry != 0 && aux != 0) {
                        if (NEWGRID_AltSelectionEntryCursor == ctx->firstEntry)
                            index = DISPLIB_FindPreviousValidEntryIndex(
                                        entry, aux, index);

                        if (index > 0
                            && ESQ_TestBit1Based(entry + 28,
                                   index) == -1
                            && !(aux[index + 7] & 32)
                            && !(aux[NEWGRID_AltSelectionEntryCursor + 7] & 0x80)
                            && *(long *)(aux + index * 4 + 56) != 0
                            && COI_ProcessEntrySelectionState(
                                   entry, aux, index, 1440,
                                   CONFIG_TimeWindowMinutes) != 0
                            && (mode != 1
                                || ESQDISP_TestEntryGridEligibility(
                                       aux, index) != 0))
                            found = 1;
                        else
                            found = 0;
                    }

                    if (found == 0)
                        NEWGRID_AltSelectionEntryCursor++;
                }
            }

            if (found == 0) {
                if (state == 4) {
                    state = 5;
                } else {
                    NEWGRID_AltSelectionEntryCursor = ctx->firstEntry;
                    NEWGRID_AltSelectionRowCursor++;
                }
            }
        }

        if (found != 0 && state != 5) {
            ctx->entry = entry;
            ctx->aux = aux;
            ctx->row = NEWGRID_AltSelectionRowCursor;

            if (NEWGRID_AltSelectionEntryCursor > 48 && index < 49)
                offset = 48;
            else
                offset = 0;
            ctx->selector = index + offset;

            aux[index + 7] = aux[index + 7] | 32;
        }
    }

    if (found == 0) {
        ctx->entry = 0;
        ctx->aux = 0;
    }
    return found;
}
