/* RESTORES: ESQIFF_NoOpFrame
 * MODULE:   modules/groups/a/n/esqiff.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: omitted-frame
 *   ref:     4e5500004e5d4e75
 *   got:     4e754e71
 *   summary: 2 got vs 8 ref. The original opens LINK.W A5,#0 and closes UNLK before the RTS on a function with no locals and no arguments; 6.51 omits the frame entirely and emits the RTS alone. There is no C source that asks for an empty frame, so the six-byte difference is not reachable. The block is the one the disassembly documented and left unlabelled after ESQIFF_QueueIffBrushLoad.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
void ESQIFF_NoOpFrame(void)
{
}
