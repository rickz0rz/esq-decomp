/* RESTORES: NEWGRID_ProcessAltEntryState
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1_2_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a7-frame-and-state-reload
 *   ref:     48e70710266f00143e2f001a3c2f001e7a00200b662c7005b0b900006c76661070002f002f002f0b6100fd0e4fef000c700023c000006c7623c000006c726000010c203900006c760c8000000006640000f6d040303b00064efb0004000a003e00e800600060008242b900006c6e200748c02f002f3900006c722f3900006c766100fe784fef000c23c000006c725280670000ba700123c000006c76200748c0220648c12f012f002f0b6100f86c4fef000c700323c000006c7660000090200748c02f002f3900006c722f3900006c766100fe284fef000c7a0123c000006c72203900006c7272ffb081675a220748c12f012f002f0b6100fc404fef000c1239000005fd23c000006c767059b200663c4a8567220cb90000000100006c6e6c16487800332f0b6100d39e6100d8f4504f23c000006c6e2f0b6100d8a0584f91b900006c6e600642b900006c76203900006c764cdf08e04e75
 *   got:     48e707043c2f001e3e2f001a2a6f00147a00200d662c7005b0b900000000661070002f002f002f0d610000004fef000c700023c00000000023c000000000600001262039000000000c80000000066400010ad040303b00064efb0004000a004600fc00680068008a42b900000000300748c02f002f39000000002f39000000006100000023c0000000004fef000c5280660a203900000000600000cc700123c000000000300748c0320648c12f012f002f0d610000004fef000c700323c0000000006000009c300748c02f002f39000000002f39000000006100000023c0000000004fef000c7a0120390000000072ffb081660842b9000000006064300748c02f002f39000000002f0d6100000023c0000000004fef000c1039000000007259b001663c4a8567220cb900000001000000006c16487800332f0d610000006100000023c000000000504f2f0d61000000584f91b900000000600642b9000000002039000000004cdf20e04e75
 *   summary: 364 got vs 344 ref, first divergence at byte 3. The six-entry jump table has the same shape and the same two fall-through chains: state 0 falls into state 1 after arming the cursor, and states 3 and 4 fall into state 5 after the marker scan. 6.51 reloads the workflow-state global before each store where the original keeps it in D0, and it holds the touched flag in a frame slot rather than D5. All three helper calls, the -1 cursor sentinel, the 89 selection-code gate and the attempt-counter arithmetic match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long NEWGRID_AltEntryWorkflowState;
extern long NEWGRID_AltEntryCursor;
extern long NEWGRID_AltEntryAttemptCounter;
extern unsigned char CONFIG_NewgridSelectionCode35EnabledFlag;

extern long NEWGRID_HandleAltGridState(char *panel, long cursor, long sel);
extern long NEWGRID_FindNextEntryWithMarkers(long op, long index, short sel);
extern void NEWGRID_DrawEmptyGridMessage(char *panel, long sel, long lines);
extern void NEWGRID_ValidateSelectionCode(char *panel, long code);
extern long NEWGRID_GetGridModeIndex(void);
extern long NEWGRID_ComputeColumnIndex(char *panel);

long NEWGRID_ProcessAltEntryState(char *panel, short sel, short lines)
{
    long touched;

    touched = 0;

    if (panel == 0) {
        if (NEWGRID_AltEntryWorkflowState == 5)
            NEWGRID_HandleAltGridState(panel, 0, 0);
        NEWGRID_AltEntryWorkflowState = NEWGRID_AltEntryCursor = 0;
        return NEWGRID_AltEntryWorkflowState;
    }

    switch (NEWGRID_AltEntryWorkflowState) {
    case 0:
        NEWGRID_AltEntryAttemptCounter = 0;
        NEWGRID_AltEntryCursor = NEWGRID_FindNextEntryWithMarkers(
            NEWGRID_AltEntryWorkflowState, NEWGRID_AltEntryCursor, sel);
        if (NEWGRID_AltEntryCursor == -1)
            return NEWGRID_AltEntryWorkflowState;
        NEWGRID_AltEntryWorkflowState = 1;
        /* fall through */
    case 1:
        NEWGRID_DrawEmptyGridMessage(panel, (long)sel, (long)lines);
        NEWGRID_AltEntryWorkflowState = 3;
        break;

    case 3:
    case 4:
        NEWGRID_AltEntryCursor = NEWGRID_FindNextEntryWithMarkers(
            NEWGRID_AltEntryWorkflowState, NEWGRID_AltEntryCursor, sel);
        touched = 1;
        /* fall through */
    case 5:
        if (NEWGRID_AltEntryCursor == -1) {
            NEWGRID_AltEntryWorkflowState = 0;
            break;
        }
        NEWGRID_AltEntryWorkflowState = NEWGRID_HandleAltGridState(panel,
            NEWGRID_AltEntryCursor, (long)sel);
        if (CONFIG_NewgridSelectionCode35EnabledFlag != 'Y')
            break;
        if (touched != 0 && NEWGRID_AltEntryAttemptCounter < 1) {
            NEWGRID_ValidateSelectionCode(panel, 51);
            NEWGRID_AltEntryAttemptCounter = NEWGRID_GetGridModeIndex();
        }
        NEWGRID_AltEntryAttemptCounter -= NEWGRID_ComputeColumnIndex(panel);
        break;

    default:
        NEWGRID_AltEntryWorkflowState = 0;
        break;
    }

    return NEWGRID_AltEntryWorkflowState;
}
