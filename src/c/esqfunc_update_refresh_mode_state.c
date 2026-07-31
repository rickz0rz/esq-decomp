/* RESTORES: ESQFUNC_UpdateRefreshModeState
 * MODULE:   modules/groups/a/n/esqfunc_p3.s
 * STATUS:   behavioural
 *
 * Latches a refresh request and, when the message pump is suspended, resets the
 * banner geometry on the way through.
 *
 * The FIRST parameter is unused. The original reads only 12(A5) and never
 * touches 8(A5). It is kept in the signature because dropping it would shift
 * what every caller passes.
 *
 * The two flags are cleared from ONE register (MOVEQ #0,D0 then two MOVE.L
 * stores), which is the chained-assignment idiom in AGENTS.md. The store order
 * is RefreshStateFlag first, so the source order is
 * `MessagePumpSuspendFlag = RefreshStateFlag = 0;`.
 *
 * The two banner constants are word stores of 0x90 and 0x230, written as
 * literals in the original.
 *
 * Note the mode-selector arms are 0 and 2, not 0 and 1, and the extra
 * RefreshStateFlag clear happens only on the mode-2 path and only when the
 * last request was zero.
 *
 * 108 ref vs 100 got. Both MOVE.W #1 / #$90 / #$230 constant stores, the
 * TST.L guard, the chained zero of the two flags, the mode-2 store, the
 * TST.L on the last request and the final MOVE.L D7 store all match exactly.
 *
 * SASC-MISMATCH: zero-through-register-vs-clr
 *   ref:     7000 23c00000a2d4     MOVEQ #0,D0 / MOVE.L D0,state   (8 bytes)
 *   got:     42b900000000          CLR.L state                     (6 bytes)
 *   summary: for the mode-0 arm the original builds zero in a register and
 *            stores it; 6.51 emits CLR.L. Same store, 2 bytes cheaper. Note
 *            this is NOT the chained-assignment case -- the two flag clears
 *            above it DO share one MOVEQ in both, and both match. Here the
 *            zero has no second use and the original still routes it through
 *            D0.
 *   tried:   nothing from the source side; a plain `= 0` is what the original
 *            compiled from, and the same spelling gives CLR.L here and the
 *            chained MOVEQ pair two statements earlier.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: link-frame-vs-none
 *   ref:     4e550000 ... 4e5d     LINK.W A5,#0 / UNLK
 *   got:     (nothing)
 *   summary: a ZERO-sized frame -- it holds nothing and exists only because the
 *            original addresses its parameter through A5. 6 bytes.
 *   scope:   program-wide, and the clearest sighting of the reserved-A5
 *            property there is. docs/compiler-version.md, "The A3/A5 divergence
 *            has a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void ESQSHARED4_ComputeBannerRowBlitGeometry(void);

extern short ESQFUNC_WeatherSliceWidthInitGate;
extern long  NEWGRID_MessagePumpSuspendFlag;
extern long  NEWGRID_RefreshStateFlag;
extern long  NEWGRID_ModeSelectorState;
extern long  NEWGRID_LastRefreshRequest;
extern short ESQPARS2_BannerRowWidthBytes;
extern short ESQPARS2_BannerCopyBlockSpanBytes;

void ESQFUNC_UpdateRefreshModeState(long unused, long request)
{
    ESQFUNC_WeatherSliceWidthInitGate = 1;

    if (NEWGRID_MessagePumpSuspendFlag) {
        NEWGRID_MessagePumpSuspendFlag = NEWGRID_RefreshStateFlag = 0;
        ESQPARS2_BannerRowWidthBytes = 0x90;
        ESQPARS2_BannerCopyBlockSpanBytes = 0x230;
        ESQSHARED4_ComputeBannerRowBlitGeometry();
    }

    if (request == 0) {
        NEWGRID_ModeSelectorState = 0;
    } else {
        NEWGRID_ModeSelectorState = 2;
        if (NEWGRID_LastRefreshRequest == 0)
            NEWGRID_RefreshStateFlag = 0;
    }

    NEWGRID_LastRefreshRequest = request;
}
