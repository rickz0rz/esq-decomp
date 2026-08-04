/* RESTORES: ESQDISP_PollInputModeAndRefreshSelection
 * MODULE:   modules/groups/a/n/esqdispb_p0_p1_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: frame-local-vs-register
 *   ref:     4e55fff82f0733fcffff0000bf182b7c00bfd0eefffa7e04206dffface101039000053dbb007670852b9000053dc6008700023c0000053dc0cb900000005000053dc6f22200713c0000053db720023c1000053dc4a00660a2f014eba15d6584f60044eba16042e1f4e5d4e75
 *   got:     48e7030433fcffff000000002a7c00bfd0ee700010152e007204ce812007123900000000b200660a720023c100000000600652b9000000000cb900000005000000006f2013c0000000007c0023c6000000004a00660a2f0661000000584f6004610000004cdf20c04e754e71
 *   summary: the original parks the CIA-B port address in a frame local (LINK.W A5,#-8, store, reload) and masks with AND.B into a preloaded D7; 6.51 keeps the address in an address register and masks with AND.L. Same 108 bytes, same reads, same two calls.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short         Global_RefreshTickCounter;
extern char          ESQDISP_LatchedInputModeBit;
extern long          ESQDISP_InputModeDebounceCount;

extern void TEXTDISP_SetRastForMode(long mode);
extern void TEXTDISP_ResetSelectionAndRefresh(void);

void ESQDISP_PollInputModeAndRefreshSelection(void)
{
    unsigned char *port;
    register long  bit;
    long           zero;

    Global_RefreshTickCounter = -1;
    port = (unsigned char *)0xbfd0ee;
    bit = 4 & *port;

    if (ESQDISP_LatchedInputModeBit == (char)bit)
        ESQDISP_InputModeDebounceCount = 0;
    else
        ESQDISP_InputModeDebounceCount++;

    if (ESQDISP_InputModeDebounceCount > 5) {
        ESQDISP_LatchedInputModeBit = (char)bit;
        zero = 0;
        ESQDISP_InputModeDebounceCount = zero;
        if ((char)bit == 0)
            TEXTDISP_SetRastForMode(zero);
        else
            TEXTDISP_ResetSelectionAndRefresh();
    }
}
