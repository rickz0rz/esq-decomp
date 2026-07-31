/* RESTORES: _NEWGRID2_DispatchGridOperation
 * MODULE:   modules/groups/b/a/newgrid2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-only
 *   ref:     48e707102e2f0014266f00183c2f001e3a2f00224a87661097cb2e3900006cec42b900006cec600623c700006cec4a79000053ce67084279000053ce97cb23c700006c20200753806d0000e40c80000000076c0000dad040303b00064efb0004000c00240044005e007a009000ae200648c02f002f0b6100c5d4504f23c000006cf0600000b0200648c0220548c12f012f002f0b6100d2004fef000c23c000006cf060000090200648c042a72f002f0b6100fdda4fef000c23c000006cf06074200648c0487800012f002f0b6100fdbe4fef000c23c000006cf06058200648c02f002f0b6100c832504f23c000006cf06042200648c0220548c12f012f002f0b6100d8904fef000c23c000006cf06024200648c0220548c12f012f002f0b6100ec964fef000c23c000006cf0600642b900006c204ab900006cf056c04400488048c04cdf08e04e75
 *   got:     48e707043a2f00223c2f001e2e2f00142a6f00184a8766109bcd2e390000000042b900000000601623c70000000030390000000067084279000000009bcd23c700000000200753806d0000e40c80000000076c0000dad040303b00064efb0004000c00240044005e007a009000ae300648c02f002f0d6100000023c000000000504f600000b0300648c0320548c12f012f002f0d6100000023c0000000004fef000c60000090300648c042a72f002f0d6100000023c0000000004fef000c6074300648c0487800012f002f0d6100000023c0000000004fef000c6058300648c02f002f0d6100000023c000000000504f6042300648c0320548c12f012f002f0d6100000023c0000000004fef000c6024300648c0320548c12f012f002f0d6100000023c0000000004fef000c600642b9000000004ab90000000056c04400488048c04cdf20e04e75
 *   summary: 328 got vs 328 ref, size-exact, first divergence at byte 3 -- the operation id and the panel pointer land in different registers. The seven-entry jump table has the same shape and the same bound check derived from op-1. The pending-operation latch on the zero request, the reinit flag that nulls the panel, all seven dispatch arms with their argument counts (including the two that differ only in a 0 or 1 constant), the out-of-range clear and the SNE booleanise of the result match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long  NEWGRID2_PendingOperationId;
extern long  NEWGRID2_LastDispatchResult;
extern long  NEWGRID_GridOperationId;
extern short ESQDISP_PendingGridReinitFlag;

extern long NEWGRID_HandleGridSelection(char *panel, long sel);
extern long NEWGRID_ProcessAltEntryState(char *panel, long sel, long lines);
extern long NEWGRID2_HandleGridState(char *panel, long sel, long ctx);
extern long NEWGRID_ProcessSecondaryState(char *panel, long sel);
extern long NEWGRID_ProcessScheduleState(char *panel, long sel, long extra);
extern long NEWGRID_ProcessShowtimesWorkflow(char *panel, long sel, long extra);

long NEWGRID2_DispatchGridOperation(long op, char *panel, short sel, short extra)
{
    if (op == 0) {
        panel = 0;
        op = NEWGRID2_PendingOperationId;
        NEWGRID2_PendingOperationId = 0;
    } else {
        NEWGRID2_PendingOperationId = op;
        if (ESQDISP_PendingGridReinitFlag != 0) {
            ESQDISP_PendingGridReinitFlag = 0;
            panel = 0;
        }
    }

    NEWGRID_GridOperationId = op;

    switch (op) {
    case 1:
        NEWGRID2_LastDispatchResult =
            NEWGRID_HandleGridSelection(panel, (long)sel);
        break;
    case 2:
        NEWGRID2_LastDispatchResult =
            NEWGRID_ProcessAltEntryState(panel, (long)sel, (long)extra);
        break;
    case 3:
        NEWGRID2_LastDispatchResult =
            NEWGRID2_HandleGridState(panel, (long)sel, 0);
        break;
    case 4:
        NEWGRID2_LastDispatchResult =
            NEWGRID2_HandleGridState(panel, (long)sel, 1);
        break;
    case 5:
        NEWGRID2_LastDispatchResult =
            NEWGRID_ProcessSecondaryState(panel, (long)sel);
        break;
    case 6:
        NEWGRID2_LastDispatchResult =
            NEWGRID_ProcessScheduleState(panel, (long)sel, (long)extra);
        break;
    case 7:
        NEWGRID2_LastDispatchResult =
            NEWGRID_ProcessShowtimesWorkflow(panel, (long)sel, (long)extra);
        break;
    default:
        NEWGRID_GridOperationId = 0;
        break;
    }

    return NEWGRID2_LastDispatchResult != 0;
}
