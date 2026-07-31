/* RESTORES: NEWGRID_HandleGridSelection
 * MODULE:   modules/groups/b/a/newgrid1b_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: global-reload-per-test
 *   ref:     48e70310266f00103e2f00167c00200b665a7005b0b900006c56663e203900006c52e58041f9000087c0d1c02f104ebad928584f4a80671270002f002f002f0b6100eea44fef000c601070002f002f002f0b6100f8f84fef000c700023c000006c5623c000006c526000012a203900006c564a8067105780671a538067165380672c6000010a42b900006c4e700323c000006c562f3900006c522f3900006c566100fedc504f7c0123c000006c52203900006c5272ffb081670000d4e58041f9000087c0d1c02f104ebad88e584f4a80671e200748c02f002f3900006c522f0b6100ee044fef000c23c000006c566052200748c02f002f3900006c522f0b6100f84c4fef000c23c000006c564a8667320cb90000000100006c4e6c265b8066221039000006077259b0016616487800302f0b6100dfdc6100e532504f23c000006c4e1039000006007259b00166264a8667220cb90000000100006c4e6c16487800202f0b6100dfaa6100e500504f23c000006c4e203900006c4e4a806f162f0b6100e4a2584f91b900006c4e600642b900006c56203900006c564cdf08c04e75
 *   got:     48e703043e2f00162a6f00107c00200d665c7005b0b90000000066402039000000002200e58141f900000000d1c12f1061000000584f4a80671270002f002f002f0d610000004fef000c601070002f002f002f0d610000004fef000c700023c00000000023c000000000600001402039000000004a8067105780671a538067165380672c600000d042b900000000700323c0000000002f39000000002f39000000006100000023c000000000504f7c0120390000000072ffb081660a42b900000000600000982039000000002200e58141f900000000d1c12f1061000000584f4a80671e300748c02f002f39000000002f0d6100000023c0000000004fef000c605a300748c02f002f39000000002f0d6100000023c0000000004fef000c4a86673a0cb900000001000000006c2e5b80662a1039000000007259b001661e487800302f0d610000006100000023c000000000504f600642b9000000001039000000007259b00166264a8667220cb900000001000000006c16487800202f0d610000006100000023c000000000504f2039000000004a806f0e2f0d61000000584f91b9000000002039000000004cdf20c04e754e71
 *   summary: 436 got vs 416 ref, first divergence at byte 3. 6.51 reloads the workflow-state and entry-index globals before each test where the original keeps the value in D0 across two or three of them; that accounts for the excess at the four sites that test them twice. The null-panel state-5 flush with its editor probe, the two fall-through chains (state 0 into 3, states 3 and 4 into 5), the -1 index sentinel, the editor-versus-entries split, the 48 and 32 selection codes with their column-adjust guards and the closing column subtraction match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long NEWGRID_GridSelectionWorkflowState;
extern long NEWGRID_GridSelectionEntryIndex;
extern long NEWGRID_GridSelectionColumnAdjust;
extern char *TEXTDISP_PrimaryEntryPtrTable[];
extern unsigned char CONFIG_NewgridSelectionCode48_49EnabledFlag;
extern unsigned char CONFIG_NewgridSelectionCode32EnabledFlag;

extern long NEWGRID_ShouldOpenEditor(char *entry);
extern long NEWGRID_UpdateGridState(char *panel, long index, long sel);
extern long NEWGRID_ProcessGridEntries(char *panel, long index, long sel);
extern long NEWGRID_FindNextFlaggedEntry(long state, long index);
extern void NEWGRID_ValidateSelectionCode(char *panel, long code);
extern long NEWGRID_GetGridModeIndex(void);
extern long NEWGRID_ComputeColumnIndex(char *panel);

long NEWGRID_HandleGridSelection(char *panel, short sel)
{
    long touched;

    touched = 0;

    if (panel == 0) {
        if (NEWGRID_GridSelectionWorkflowState == 5) {
            if (NEWGRID_ShouldOpenEditor(
                    TEXTDISP_PrimaryEntryPtrTable[NEWGRID_GridSelectionEntryIndex]) != 0)
                NEWGRID_UpdateGridState(panel, 0, 0);
            else
                NEWGRID_ProcessGridEntries(panel, 0, 0);
        }
        NEWGRID_GridSelectionWorkflowState = NEWGRID_GridSelectionEntryIndex = 0;
        return NEWGRID_GridSelectionWorkflowState;
    }

    switch (NEWGRID_GridSelectionWorkflowState) {
    case 0:
        NEWGRID_GridSelectionColumnAdjust = 0;
        NEWGRID_GridSelectionWorkflowState = 3;
        /* fall through */
    case 3:
    case 4:
        NEWGRID_GridSelectionEntryIndex = NEWGRID_FindNextFlaggedEntry(
            NEWGRID_GridSelectionWorkflowState, NEWGRID_GridSelectionEntryIndex);
        touched = 1;
        /* fall through */
    case 5:
        if (NEWGRID_GridSelectionEntryIndex == -1) {
            NEWGRID_GridSelectionWorkflowState = 0;
            break;
        }
        if (NEWGRID_ShouldOpenEditor(
                TEXTDISP_PrimaryEntryPtrTable[NEWGRID_GridSelectionEntryIndex]) != 0) {
            NEWGRID_GridSelectionWorkflowState = NEWGRID_UpdateGridState(panel,
                NEWGRID_GridSelectionEntryIndex, (long)sel);
        } else {
            NEWGRID_GridSelectionWorkflowState = NEWGRID_ProcessGridEntries(panel,
                NEWGRID_GridSelectionEntryIndex, (long)sel);
            if (touched != 0 && NEWGRID_GridSelectionColumnAdjust < 1
                && NEWGRID_GridSelectionWorkflowState == 5
                && CONFIG_NewgridSelectionCode48_49EnabledFlag == 89) {
                NEWGRID_ValidateSelectionCode(panel, 48);
                NEWGRID_GridSelectionColumnAdjust = NEWGRID_GetGridModeIndex();
            }
        }
        break;

    default:
        NEWGRID_GridSelectionWorkflowState = 0;
        break;
    }

    if (CONFIG_NewgridSelectionCode32EnabledFlag == 89 && touched != 0
        && NEWGRID_GridSelectionColumnAdjust < 1) {
        NEWGRID_ValidateSelectionCode(panel, 32);
        NEWGRID_GridSelectionColumnAdjust = NEWGRID_GetGridModeIndex();
    }

    if (NEWGRID_GridSelectionColumnAdjust > 0)
        NEWGRID_GridSelectionColumnAdjust -= NEWGRID_ComputeColumnIndex(panel);

    return NEWGRID_GridSelectionWorkflowState;
}
