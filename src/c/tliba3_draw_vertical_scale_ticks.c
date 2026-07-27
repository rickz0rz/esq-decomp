/* RESTORES: TLIBA3_DrawVerticalScaleTicks
 * MODULE:   modules/groups/b/a/tliba3.s
 * STATUS:   behavioural
 *
 * 254 bytes in the original, 240 emitted, 16 differing regions.
 *
 * Reproduces: the full-height rule drawn first, the tick loop whose bound is
 * re-read from rp->BitMap->Rows on every iteration rather than hoisted, the
 * three-way tick logic (long tick plus a printed label every tenth row except
 * row zero, short tick every fifth, nothing otherwise), the label x offset held
 * in a register from the start, and the inlined-strlen Text call.
 *
 * Both modulo tests go through MATH_DivS32 taking the remainder from D1 -- the
 * same divide-helper-result-sharing shape recorded in
 * textdisp_format_entry_time.c and datetime_format_pair_to_stream.c. This is the
 * third sighting.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffa4                   LINK.W A5,#-92
 *   got:     9efc0054                   SUBA.W #84,A7
 *   summary: The A5-frame class; the 84-byte label buffer moves to A7-relative,
 *            which is most of the 16 regions and the whole -14.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */
#include <proto/graphics.h>
#include <string.h>

extern void WDISP_SPrintf(char *buf, char *fmt, long v);
extern char TLIBA1_FMT_PCT_03LD_VerticalScaleTick[];

void TLIBA3_DrawVerticalScaleTicks(struct RastPort *rp, long x)
{
    char buf[84];
    register long xLabel;
    register long i;

    xLabel = x + 25;

    Move(rp, x, 0L);
    Draw(rp, x, (long)rp->BitMap->Rows - 1);

    for (i = 0; i < (long)rp->BitMap->Rows - 1; i++) {
        if (i % 10 == 0 && i != 0) {
            Move(rp, x, i);
            Draw(rp, x + 20, i);
            Move(rp, xLabel, i);
            WDISP_SPrintf(buf, TLIBA1_FMT_PCT_03LD_VerticalScaleTick, i);
            Text(rp, buf, (long)strlen(buf));
        } else if (i % 5 == 0) {
            Move(rp, x, i);
            Draw(rp, x + 10, i);
        }
    }
}
