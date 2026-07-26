/* RESTORES: DISKIO_ResetCtrlInputStateIfIdle
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: os-library-call
 *   ref:     4a790000a2dc662e2c7800044eaeff88700033c00000a33233c00000a32e33c00000a32c4eaeff82700033c00000bf1833c000005e8e4e75
 *   got:     303900000000662a61000000700033c00000000033c00000000033c00000000061000000700033c00000000033c0000000004e75
 *   summary: The original calls an AmigaOS library function through an explicit base register (MOVEA.L base,A6 / JSR _LVOxxx(A6)). Reproducing that from C needs the SAS/C #pragma libcall machinery and the matching library base; without it sc emits an ordinary external call. Recorded rather than guessed at.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short Global_UIBusyFlag;
extern short CTRL_BufferedByteCount, CTRL_HPreviousSample, CTRL_H;
extern short Global_RefreshTickCounter, ESQPARS2_ReadModeFlags;
extern void  Disable(void);
extern void  Enable(void);
void DISKIO_ResetCtrlInputStateIfIdle(void)
{
    if (Global_UIBusyFlag != 0)
        return;
    Disable();
    CTRL_H = CTRL_HPreviousSample = CTRL_BufferedByteCount = 0;
    Enable();
    ESQPARS2_ReadModeFlags = Global_RefreshTickCounter = 0;
}
