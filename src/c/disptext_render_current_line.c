/* RESTORES: DISPTEXT_RenderCurrentLine
 * MODULE:   modules/groups/a/i/disptextb_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: index-rematerialisation
 *   ref:     4e55fff448e73f10266d00082e2d000c2c2d00106100f91c700023c000001b4c2239000081484a816f0001043239000080ce3439000080ccb242640000f274003401e58241f90000807c2248d3c24a91670000dc74003401e582d1c22b50fffa76003601d68341f9000080d0d1c3780038104a846f0000b841f9000080f8d1c2224b20102c79000028584eaefeaa224b70004eaefe9e206dfffa1a304800423048004a79000081546752487800132f084eba008a504f4a806742487800142f2dfffa4eba0078504f4a8067307000103900007fe57200123900007fe42f2dfffa2f012f002f062f072f0b4eba00564fef0018700423c000001b4c601c224b200722062c79000028584eaeff10224b2004206dfffa4eaeffc4206dfffa118548003039000080ce524033c0000080ce4cdf08fc4e5d4e75
 *   got:     48e70f162c2f00282e2f00242a6f00206100000042b9000000002039000000004a806f000116303900000000323900000000b041640001044840424048402200e58141f9000000002248d3c14a91670000ea4840424048402200e581d1c126504840424048402200d28141f900000000d1c17a003a104a856f0000c04840424048402200e58141f900000000d1c1224d20102c79000000004eaefeaa224d2c790000000070004eaefe9e1833580042335800303900000000674e487800132f0b61000000504f4a80673e487800142f0b61000000504f4a80672e700010390000000072001239000000002f0b2f012f002f062f072f0d610000004fef0018700423c0000000006020224d200722062c79000000004eaeff10224d204b20052c79000000004eaeffc417845800303900000000524033c0000000004cdf68f04e75
 *   summary: 320 got vs 310 ref, ten bytes over. The original holds the line index in a data register and rebuilds the scaled offset with MOVEQ #0 / MOVE.W / ASL.L per table; 6.51 reloads the index from memory each time and zero-extends with MOVE.W / SWAP / CLR.W / SWAP, which is two bytes longer at five sites, offset by a shorter frame. The three parallel tables (pointer, length, pen) are indexed the same way, the temporary NUL over the line end and its restore, the two control-marker probes with the inset draw, and the plain Move/Text arm all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics.h"

extern long  DISPTEXT_ControlMarkerXOffsetPx;
extern long  DISPTEXT_LineWidthPx;
extern unsigned short DISPTEXT_CurrentLineIndex;
extern unsigned short DISPTEXT_TargetLineIndex;
extern char *DISPTEXT_LinePtrTable[];
extern unsigned short DISPTEXT_LineLengthTable[];
extern long  DISPTEXT_LinePenTable[];
extern short DISPTEXT_ControlMarkersEnabledFlag;
extern unsigned char DISPTEXT_InsetNibblePrimary;
extern unsigned char DISPTEXT_InsetNibbleSecondary;

extern void  DISPTEXT_FinalizeLineTable(void);
extern char *STR_FindCharPtr(char *s, long c);
extern void  TLIBA1_DrawTextWithInsetSegments(
                struct RastPort *rp, long x, long y, long secondary,
                long primary, char *text);

void DISPTEXT_RenderCurrentLine(struct RastPort *rp, long x, long y)
{
    char *text;
    long  len;
    char  saved;

    DISPTEXT_FinalizeLineTable();
    DISPTEXT_ControlMarkerXOffsetPx = 0;
    if (DISPTEXT_LineWidthPx <= 0)
        return;
    if (DISPTEXT_CurrentLineIndex >= DISPTEXT_TargetLineIndex)
        return;
    if (DISPTEXT_LinePtrTable[DISPTEXT_CurrentLineIndex] == 0)
        return;

    text = DISPTEXT_LinePtrTable[DISPTEXT_CurrentLineIndex];
    len = DISPTEXT_LineLengthTable[DISPTEXT_CurrentLineIndex];
    if (len <= 0)
        return;

    SetAPen(rp, DISPTEXT_LinePenTable[DISPTEXT_CurrentLineIndex]);
    SetDrMd(rp, 0);

    saved = text[len];
    text[len] = 0;

    if (DISPTEXT_ControlMarkersEnabledFlag != 0
        && STR_FindCharPtr(text, 19) != 0
        && STR_FindCharPtr(text, 20) != 0) {
        TLIBA1_DrawTextWithInsetSegments(rp, x, y,
            (long)DISPTEXT_InsetNibbleSecondary,
            (long)DISPTEXT_InsetNibblePrimary, text);
        DISPTEXT_ControlMarkerXOffsetPx = 4;
    } else {
        Move(rp, x, y);
        Text(rp, text, len);
    }

    text[len] = saved;
    DISPTEXT_CurrentLineIndex++;
}
