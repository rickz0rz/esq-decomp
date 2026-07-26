/* RESTORES: DISKIO_ResetCtrlInputStateIfIdle
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     4a790000a2dc662e2c7800044eaeff88700033c00000a33233c00000a32e33c00000a32c4eaeff82700033c00000bf1833c000005e8e4e75
 *   got:     2f0e303900000000662e2c7800044eaeff88700033c00000000033c00000000033c0000000004eaeff82700033c00000000033c0000000002c5f4e75
 *   summary: The OS call itself now matches exactly -- SAS/C's #pragma libcall emits the same MOVEA.L base,A6 / JSR _LVOxxx(A6) the original uses, with identical LVO offsets. The remaining gap is A6 handling: SAS/C treats A6 as callee-saved and adds it to the MOVEM save/restore masks (48e73002 / 4cdf400c) where the original treats A6 as scratch and does not save it (48e73000 / 4cdf000c), and it orders the base load before the argument setup. Not an option: CONSTLIBBASE, NOCONSTLIBBASE, SAVEDS and NOSAVEDS all leave it. This is now a single narrow code-generator difference rather than an unknown, and it affects every OS-calling function in the program.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <proto/exec.h>
extern short Global_UIBusyFlag;
extern short CTRL_BufferedByteCount, CTRL_HPreviousSample, CTRL_H;
extern short Global_RefreshTickCounter, ESQPARS2_ReadModeFlags;
void DISKIO_ResetCtrlInputStateIfIdle(void)
{
    if (Global_UIBusyFlag != 0)
        return;
    Disable();
    CTRL_H = CTRL_HPreviousSample = CTRL_BufferedByteCount = 0;
    Enable();
    ESQPARS2_ReadModeFlags = Global_RefreshTickCounter = 0;
}
