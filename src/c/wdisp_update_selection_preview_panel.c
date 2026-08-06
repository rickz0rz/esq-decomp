/* RESTORES: WDISP_UpdateSelectionPreviewPanel
 * MODULE:   modules/groups/b/a/wdisp_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: dead-reload-block
 *   ref:     4e55fffc48e72030266d0008246d000c7008b0b900007af06612700023c000007af023c000007af46000010441ea003c224870072c79000028584eaeff162079000087022b680004fffc216b000400044ab900007af066442f39000001ac2f0a4eba011a504f48c023c000007af44a806708700723c000007af04ab9000001ac67402079000001ac41e800e82f084eba00c22e8a4eba00f8584f60267007b0b900007af0661c2f39000001ac2f0a4eba00cc504f48c023c000007af472ff254100204ab900007af4665842a74879000001ac4eba0096504f70004a80673432390000a3c27430b242672812390000a3284a01671e32390000d5d47401b2426e124ab900006dd8660a487800024eba004a584f700823c000007af070ff23c000007af4207900008702216dfffc00044ab900007af456c04400488048c04cdf0c044e5d4e750000
 *   got:     48e70136266f001c2a6f00187008b0b9000000006620700023c00000000023c0000000004ab90000000056c04400488048c06000010841eb003c22482c790000000070074eaeff1620790000000024680004216d000400044ab900000000663e2f39000000002f0b61000000504f48c023c0000000006708700723c000000000203900000000673c2040d0fc00e82f08610000002e8b61000000584f60267007b0b900000000661c2f39000000002f0b61000000504f48c023c00000000072ff274100204ab900000000665842a748790000000061000000504f7e004a8767343039000000007230b04167281039000000004a00671e3039000000007201b0416e124ab900000000660a4878000261000000584f700823c00000000070ff23c000000000207900000000214a00044ab90000000056c04400488048c04cdf6c804e754e71
 *   summary: 324 got vs 326 ref, two bytes short, and the unreachable reload block survives. That block is guarded by a register MOVEQ #0 has just loaded, so the zero is held in a local rather than written as a literal; a literal folds all four weather tests and the queue call away. The state-8 early exit that skips the bitmap restore, the rastport bitmap swap and restore, both render arms selected by state 0 and state 7, the preset expansion at +0xe8, the brush-list free and the SNE booleanise of the result match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/gfx.h>
#include "esq-graphics.h"

struct GridPanel {
    char            pad0[32];
    long            visibleLines;   /* +32 */
    char            pad36[24];
    struct RastPort rp;             /* +60 */
};

struct PreviewCtx {
    char           pad0[4];
    struct BitMap *bitmap;          /* +4 */
};

extern struct RastPort *Global_REF_RASTPORT_1;
extern long  TLIBA1_PreviewSlotRefreshState;
extern long  TLIBA1_PreviewSlotRenderResult;
extern char *WDISP_WeatherStatusBrushListHead;
extern short WDISP_WeatherStatusDigitChar;
extern char  WDISP_WeatherStatusCountdown;
extern short WDISP_WeatherCycleOffsetCount;
extern long  P_TYPE_WeatherBrushRefreshPendingFlag;

extern short ESQIFF_RenderWeatherStatusBrushSlice(
                 struct GridPanel *panel, char *brush);
extern void  GCOMMAND_ExpandPresetBlock(char *block);
extern void  NEWGRID_ResetRowTable(struct GridPanel *panel);
extern void  BRUSH_FreeBrushList(char **head, long flags);
extern void  ESQIFF_QueueIffBrushLoad(long mode);

long WDISP_UpdateSelectionPreviewPanel(struct PreviewCtx *ctx,
                                       struct GridPanel *panel)
{
    struct BitMap *saved;
    long reloadEnabled;

    if (TLIBA1_PreviewSlotRefreshState == 8) {
        TLIBA1_PreviewSlotRefreshState = TLIBA1_PreviewSlotRenderResult = 0;
        return TLIBA1_PreviewSlotRenderResult != 0;
    }

    SetRast(&panel->rp, 7);

    saved = Global_REF_RASTPORT_1->BitMap;
    Global_REF_RASTPORT_1->BitMap = ctx->bitmap;

    if (TLIBA1_PreviewSlotRefreshState == 0) {
        TLIBA1_PreviewSlotRenderResult =
            ESQIFF_RenderWeatherStatusBrushSlice(panel,
                WDISP_WeatherStatusBrushListHead);
        if (TLIBA1_PreviewSlotRenderResult != 0)
            TLIBA1_PreviewSlotRefreshState = 7;
        if (WDISP_WeatherStatusBrushListHead != 0) {
            GCOMMAND_ExpandPresetBlock(
                WDISP_WeatherStatusBrushListHead + 0xe8);
            NEWGRID_ResetRowTable(panel);
        }
    } else if (TLIBA1_PreviewSlotRefreshState == 7) {
        TLIBA1_PreviewSlotRenderResult =
            ESQIFF_RenderWeatherStatusBrushSlice(panel,
                WDISP_WeatherStatusBrushListHead);
        panel->visibleLines = -1;
    }

    if (TLIBA1_PreviewSlotRenderResult == 0) {
        BRUSH_FreeBrushList(&WDISP_WeatherStatusBrushListHead, 0);

        /* Zero held in a local, not written as a literal: the original tests it
         * and emits the reload block below, which is unreachable there as well. */
        reloadEnabled = 0;
        if (reloadEnabled) {
            if (WDISP_WeatherStatusDigitChar != '0'
                && WDISP_WeatherStatusCountdown != 0
                && WDISP_WeatherCycleOffsetCount <= 1
                && P_TYPE_WeatherBrushRefreshPendingFlag == 0)
                ESQIFF_QueueIffBrushLoad(2);
        }

        TLIBA1_PreviewSlotRefreshState = 8;
        TLIBA1_PreviewSlotRenderResult = -1;
    }

    Global_REF_RASTPORT_1->BitMap = saved;
    return TLIBA1_PreviewSlotRenderResult != 0;
}
