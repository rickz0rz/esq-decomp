/* RESTORES: DISKIO_DrawTransferErrorMessageIfDiagnostics
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * Prints the termination reason for a failed transfer, but only when the
 * diagnostics screen is up -- during normal operation a transfer failure is
 * silent here and reported elsewhere.
 *
 * The reason codes are 1-based: the original indexes a table biased by -4, which
 * is `table[reason - 1]`. Reason 0 would read the longword before the table.
 *
 * 90 bytes in the original, 88 emitted. The biased table index reproduces exactly
 * -- SAS/C folds the -1 into the LEA the same way, so `table[reason - 1]` is the
 * right source form and no pointer arithmetic is needed to get it.
 *
 * SASC-MISMATCH: a6-in-save-mask
 *   summary: +2 and +6/-6 of load placement. Fifth sighting.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     2c7900002858 twice   GfxBase reloaded before the second SetAPen
 *   got:     one load, kept live
 *   summary: -6, same as esqfunc_draw_esc_menu_version.c.
 *
 * SASC-MISMATCH: argument-pop-position
 *   ref:     LEA 16(A7),A7 right after the call
 *   got:     folded into the epilogue
 *   summary: -4 then +6. No net cost.
 */
#include <proto/graphics.h>

extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);

extern struct RastPort *Global_REF_RASTPORT_1;
extern short ED_DiagnosticsScreenActive;
extern char *CTASKS_TerminationReasonPtrTable[];

void DISKIO_DrawTransferErrorMessageIfDiagnostics(long reason)
{
    if (ED_DiagnosticsScreenActive == 0)
        return;

    SetAPen(Global_REF_RASTPORT_1, 4L);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 240L,
                                  CTASKS_TerminationReasonPtrTable[reason - 1]);
    SetAPen(Global_REF_RASTPORT_1, 1L);
}
