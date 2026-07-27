/* RESTORES: NEWGRID_ClearHighlightArea
 * MODULE:   modules/groups/b/a/newgrid.s
 * STATUS:   behavioural
 *
 * Drops any queued highlight messages and repaints the grid area in pen 7. The
 * message reset runs inside Disable()/Enable() because the queue is written from
 * an interrupt; the repaint does not, and is skipped entirely if a refresh is
 * already pending.
 *
 * 82 bytes in the original, 78 emitted plus one alignment NOP. The -4 is one
 * class. Both large constants -- 695 and 267 -- come out as MOVE.L immediates
 * matching the original, which is what the constant rule predicts since neither
 * is 2n or ~n for an n in MOVEQ range.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     2c780004 twice     AbsExecBase reloaded before Enable
 *   got:     one load, A6 kept live
 *   summary: -4. Same class as cleanup_clear_rbf_interrupt_and_serial.c.
 *
 * SASC-MISMATCH: a6-in-save-mask
 *   summary: A6 added to the MOVEM mask. Same four bytes, no cost.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the one cross-unit call.
 */
#include <proto/exec.h>
#include <proto/graphics.h>

extern void GCOMMAND_ResetHighlightMessages(void);

extern struct RastPort *NEWGRID_MainRastPortPtr;
extern long NEWGRID_RefreshStateFlag;

void NEWGRID_ClearHighlightArea(void)
{
    Disable();
    GCOMMAND_ResetHighlightMessages();
    Enable();

    if (NEWGRID_RefreshStateFlag)
        return;

    SetAPen(NEWGRID_MainRastPortPtr, 7L);
    RectFill(NEWGRID_MainRastPortPtr, 0L, 68L, 695L, 267L);
}
