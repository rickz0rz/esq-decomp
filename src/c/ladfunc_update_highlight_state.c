/* RESTORES: LADFUNC_UpdateHighlightState
 * MODULE:   modules/groups/a/w/ladfunc.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     48e70110700033c00000a34433c00000a34610390000061b724eb00167447e00702ebe806c3c2007e58041f900009fc4d1c02650426b000430390000a3083213b2406e1a322b0002b2406d124aab0006670c70013740000433c00000a344528760be4cdf08804e75
 *   got:     48e70104700033c00000000033c000000000103900000000724eb00167447e00702ebe806c3c2007e58041f900000000d1c02a50426d00043039000000003215b2406e1a322d0002b2406d124aad0006670c70013b40000433c000000000528760be4cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct LadfuncRect { short start; short end; short active; long data; };
extern struct LadfuncRect *LADFUNC_EntryPtrTable[];
extern short WDISP_HighlightActive, WDISP_HighlightIndex;
extern short CLOCK_HalfHourSlotIndex;
extern unsigned char ED_DiagTextModeChar;

void LADFUNC_UpdateHighlightState(void)
{
    long i;

    WDISP_HighlightIndex = WDISP_HighlightActive = 0;
    if (ED_DiagTextModeChar == 78)
        return;
    for (i = 0; i < 46; i++) {
        struct LadfuncRect *r = LADFUNC_EntryPtrTable[i];
        r->active = 0;
        if (r->start > CLOCK_HalfHourSlotIndex)
            continue;
        if (r->end < CLOCK_HalfHourSlotIndex)
            continue;
        if (r->data == 0)
            continue;
        r->active = 1;
        WDISP_HighlightActive = 1;
    }
}
