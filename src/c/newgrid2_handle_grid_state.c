/* RESTORES: NEWGRID2_HandleGridState
 * MODULE:   modules/groups/b/a/newgrid2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-only
 *   ref:     48e70710266f00143e2f001a2c2f001c7a00200b66287005b0b900006ce866122f0648790000b4362f0b6100fe444fef000c700023c000006ce860000116203900006ce80c800000000664000100d040303b00064efb0004000a002000f2006a006a0088200748c02f062f0048790000b4366100f2b04fef000c2f0648790000b4362f3900006ce86100f3244fef000c4a8067262f062f390000b4362f0b6100f9724fef000c7000720323c100006ce823c000006ce46000009a42b900006ce8600000902f0648790000b4362f3900006ce86100f2da2e866100f0e04fef000c2a004ab90000b43667582f0648790000b4362f0b6100fd7a2e8623c000006ce86100f0b84fef000c4a8067464a8567220cb90000000100006ce46c16487800322f0b6100a7ac6100ad02504f23c000006ce42f0b6100acae584f91b900006ce46010700123c000006ce8600642b900006ce84ab900006ce8660e200748c02f002f066100f0e2504f203900006ce84cdf08e04e75
 *   got:     48e707042c2f001c3e2f001a2a6f00147a00200d66287005b0b90000000066122f064879000000002f0d610000004fef000c700023c000000000600001302039000000000c8000000006640000fed040303b00064efb0004000a002000f0006800680086300748c02f062f00487900000000610000004fef000c2f064879000000002f3900000000610000004fef000c4a80660a42b900000000600000b42f062f39000000002f0d610000004fef000c700323c00000000042b900000000600000902f064879000000002f3900000000610000002e86610000002a004fef000c4ab900000000660a700123c000000000605e2f064879000000002f0d6100000023c0000000002e86610000004fef000c4a80673c4a8567220cb900000001000000006c16487800322f0d610000006100000023c000000000504f2f0d61000000584f91b900000000600642b9000000004ab900000000660e300748c02f002f0661000000504f2039000000004cdf20e04e754e71
 *   summary: 372 got vs 372 ref, size-exact, first divergence at byte 3 -- the panel pointer and the active flag land in different registers. The six-entry jump table has the same shape, including both fall-through chains: state 0 into state 1, and states 3 and 4 into state 5. The null-panel state-5 flush, the abort-to-zero path, the restart-at-1 path when the context pointer is null, the two TestModeFlagActive calls, the 50 selection code and the cached-mode arithmetic all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long  NEWGRID2_DispatchStateIndex;
extern long  NEWGRID2_CachedModeIndex;
extern char *NEWGRID2_ShowtimesSelectionContextPtr;

extern long NEWGRID2_ProcessGridState(char *panel, char **ctxSlot, long ctx);
extern void NEWGRID_InitSelectionWindowAlt(char **ctxSlot, long sel, long ctx);
extern long NEWGRID_UpdateSelectionFromInputAlt(long state, char **ctxSlot,
                                                long ctx);
extern void NEWGRID_DrawShowtimesPrompt(char *panel, char *ctxPtr, long ctx);
extern long NEWGRID_TestModeFlagActive(long ctx);
extern void NEWGRID_ValidateSelectionCode(char *panel, long code);
extern long NEWGRID_GetGridModeIndex(void);
extern long NEWGRID_ComputeColumnIndex(char *panel);
extern void NEWGRID_ClearMarkersIfSelectable(long ctx, long sel);

long NEWGRID2_HandleGridState(char *panel, short sel, long ctx)
{
    long active;

    active = 0;

    if (panel == 0) {
        if (NEWGRID2_DispatchStateIndex == 5)
            NEWGRID2_ProcessGridState(panel,
                &NEWGRID2_ShowtimesSelectionContextPtr, ctx);
        NEWGRID2_DispatchStateIndex = 0;
        return NEWGRID2_DispatchStateIndex;
    }

    switch (NEWGRID2_DispatchStateIndex) {
    case 0:
        NEWGRID_InitSelectionWindowAlt(&NEWGRID2_ShowtimesSelectionContextPtr,
                                       (long)sel, ctx);
        /* fall through */
    case 1:
        if (NEWGRID_UpdateSelectionFromInputAlt(NEWGRID2_DispatchStateIndex,
                &NEWGRID2_ShowtimesSelectionContextPtr, ctx) == 0) {
            NEWGRID2_DispatchStateIndex = 0;
            break;
        }
        NEWGRID_DrawShowtimesPrompt(panel,
            NEWGRID2_ShowtimesSelectionContextPtr, ctx);
        NEWGRID2_DispatchStateIndex = 3;
        NEWGRID2_CachedModeIndex = 0;
        break;

    case 3:
    case 4:
        NEWGRID_UpdateSelectionFromInputAlt(NEWGRID2_DispatchStateIndex,
            &NEWGRID2_ShowtimesSelectionContextPtr, ctx);
        active = NEWGRID_TestModeFlagActive(ctx);
        /* fall through */
    case 5:
        if (NEWGRID2_ShowtimesSelectionContextPtr == 0) {
            NEWGRID2_DispatchStateIndex = 1;
            break;
        }
        NEWGRID2_DispatchStateIndex = NEWGRID2_ProcessGridState(panel,
            &NEWGRID2_ShowtimesSelectionContextPtr, ctx);
        if (NEWGRID_TestModeFlagActive(ctx) == 0)
            break;
        if (active != 0 && NEWGRID2_CachedModeIndex < 1) {
            NEWGRID_ValidateSelectionCode(panel, 50);
            NEWGRID2_CachedModeIndex = NEWGRID_GetGridModeIndex();
        }
        NEWGRID2_CachedModeIndex -= NEWGRID_ComputeColumnIndex(panel);
        break;

    default:
        NEWGRID2_DispatchStateIndex = 0;
        break;
    }

    if (NEWGRID2_DispatchStateIndex == 0)
        NEWGRID_ClearMarkersIfSelectable(ctx, (long)sel);
    return NEWGRID2_DispatchStateIndex;
}
