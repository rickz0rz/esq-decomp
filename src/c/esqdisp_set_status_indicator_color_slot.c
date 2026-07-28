/* RESTORES: _ESQDISP_SetStatusIndicatorColorSlot
 * MODULE:   modules/groups/a/n/esqdisp_p1_esqdisp_setstatusindicatorcolorslot.s
 * STATUS:   behavioural
 *
 * Paint one of the two status indicator swatches, with a write-back cache so an
 * unchanged colour costs nothing. Slots 0 and 1 only; anything else returns.
 *
 * Three distinct behaviours share the entry point:
 *   - deferred-apply flag set: just record the colour in the cache and return,
 *     unless the colour is -1 (meaning "no change"), which returns immediately.
 *   - colour == -1 with the flag clear: take the colour FROM the cache and reset
 *     the cache entry to -1, i.e. replay a deferred colour once.
 *   - otherwise: skip if the cache already holds this colour, else store and draw.
 *
 * Colours 6 and 7 are not literal pens -- they are resolved by sampling the
 * pixel at (655,55), so the swatch picks up whatever is already on screen there.
 *
 * The draw temporarily retargets the shared rastport at the 696x400 bitmap and
 * restores both the bitmap pointer and the original FgPen afterwards, so the
 * caller sees no change. FgPen is read signed (MOVE.B 25(A0) / EXT.W / EXT.L).
 *
 * LIBRARY BASE: esq-graphics-leaf.h, the NON-volatile base -- every call is a
 * library call. See esq-graphics-leaf.h; tools/a6_audit.py enforces it.
 *
 * SASC-MISMATCH: layout-difference
 *   summary: 304 bytes against 294, spread across EIGHTEEN small regions with no
 *            single dominant cause -- the code generator ordered the block
 *            differently rather than choosing different idioms. Per AGENTS.md
 *            rule 3 this delta is NOT itemised and is recorded as a
 *            known-unknown rather than guessed at: the A5 frame class and the
 *            repeated cache-index recomputation are both visible in it, but they
 *            do not add up to +10 on their own and attributing the remainder
 *            would be invention.
 *   tried:   the cache is indexed as an array (ESQDISP_StatusIndicatorColorCache
 *            [slot]) rather than hoisted, which is what the original does -- it
 *            recomputes LEA/ADDA per access. Hoisting a pointer made it worse.
 *   scope:   this is the one file in the graphics-leaf batch whose delta is not
 *            attributed. Worth revisiting with casm.py if it ever matters.
 *   retest:  unknown -- start with a compiler that reserves A5 and re-measure
 *            before theorising further.
 */

#include "esq-graphics-leaf.h"

extern unsigned char ESQDISP_StatusIndicatorDeferredApplyFlag;
extern long          ESQDISP_StatusIndicatorColorCache[];
extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap    Global_REF_696_400_BITMAP;

void ESQDISP_SetStatusIndicatorColorSlot(long color, long slot)
{
    struct BitMap *savedBitMap;
    long savedPen;
    long x1, y1;

    if (slot != 0 && slot != 1)
        return;

    if (ESQDISP_StatusIndicatorDeferredApplyFlag) {
        if (color == -1)
            return;
        ESQDISP_StatusIndicatorColorCache[slot] = color;
        return;
    }

    if (color == -1) {
        color = ESQDISP_StatusIndicatorColorCache[slot];
        ESQDISP_StatusIndicatorColorCache[slot] = -1;
    }

    if (ESQDISP_StatusIndicatorColorCache[slot] == color)
        return;

    ESQDISP_StatusIndicatorColorCache[slot] = color;

    x1 = 0x28f;
    if (slot == 1)
        y1 = 40;
    else
        y1 = 57;

    savedPen    = Global_REF_RASTPORT_1->FgPen;
    savedBitMap = Global_REF_RASTPORT_1->BitMap;
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;

    if (color == 7 || color == 6)
        color = ReadPixel(Global_REF_RASTPORT_1, 655L, 55L);

    SetAPen(Global_REF_RASTPORT_1, color);
    RectFill(Global_REF_RASTPORT_1, x1, y1, x1 + 6, y1 + 4);
    SetAPen(Global_REF_RASTPORT_1, savedPen);

    Global_REF_RASTPORT_1->BitMap = savedBitMap;
}
