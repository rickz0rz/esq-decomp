/* RESTORES: ED_DrawMenuSelectionHighlight
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 *
 * Paints the menu selection bar: a pen-2 fill down to the selected row, and then,
 * when an edit cursor is set, a pen-6 band over the cursor's own row. Rows are 30
 * pixels apart, the list starts at y=68, and the bar spans x 40..640.
 *
 * 132 bytes in the original against 136. Written with the row arithmetic in
 * explicit locals: as a single inline expression SAS/C spilled to a 12-byte frame
 * (9efc000c, SUBA.W #12,A7) that the original does not have, costing 148. The
 * original keeps everything in D2/D3/D7, and naming the intermediates is what
 * reproduces that.
 *
 * SASC-MISMATCH: multiply-helper-vs-inline
 *   ref:     721e4eba5f6e         MOVEQ #30,D1 / JSR MATH_Mulu32(PC)
 *   got:     e9809087d080         ASL.L #4,D0 / SUB.L D7,D0 / ADD.L D0,D0
 *   summary: the original calls the 32-bit multiply helper for row * 30; SAS/C
 *            reduces it to (x<<4 - x) << 1. Six bytes either way, 2 sites.
 *   scope:   the multiply class in docs/compiler-version.md. Note this is the
 *            32-bit case, which is the only one where the original uses the
 *            helper -- the file records that the broader "every multiply calls
 *            the helper" claim was wrong.
 *
 * SASC-MISMATCH: constant-materialisation-640
 *   ref:     243c00000280         MOVE.L #640,D2                (6 bytes)
 *   got:     7450e78a             MOVEQ #80,D2 / LSL.L #3,D2    (4 bytes)
 *   summary: the RectFill right edge, 2 sites. A third independent confirmation
 *            of the rule in docs/compiler-version.md: 640 is neither 2n nor ~n
 *            for n in MOVEQ range, so the original spends six bytes, while 6.51
 *            shifts by three -- and the original never shifts by more than one.
 *
 * SASC-MISMATCH: unattributed-delta
 *   summary: the two 640 sites save 4 bytes and the multiply sites are size-
 *            neutral, yet the total is +4, so roughly 8 bytes are unexplained.
 *            They are spread across the register allocation: SAS/C saves a wider
 *            MOVEM set (3702 against 3100, which also moves the argument offset
 *            from 16 to 28) and orders the GfxBase load differently. Recorded as
 *            a known-unknown rather than guessed -- see the accounting rule in
 *            AGENTS.md. Re-derive before promoting this file.
 */
#include <proto/graphics.h>

extern struct RastPort *Global_REF_RASTPORT_1;
extern long ED_EditCursorOffset;

void ED_DrawMenuSelectionHighlight(long row)
{
    register long y;

    SetAPen(Global_REF_RASTPORT_1, 2L);
    y = row * 30 + 67;
    RectFill(Global_REF_RASTPORT_1, 40L, 68L, 640L, y);

    if (ED_EditCursorOffset > -1) {
        register long t;
        SetAPen(Global_REF_RASTPORT_1, 6L);
        t = ED_EditCursorOffset * 30;
        y = t + 97;
        RectFill(Global_REF_RASTPORT_1, 40L, t + 68, 640L, y);
    }
}
