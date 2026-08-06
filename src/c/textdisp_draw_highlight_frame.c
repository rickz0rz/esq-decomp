/* RESTORES: TEXTDISP_DrawHighlightFrame
 * MODULE:   modules/groups/b/a/textdisp_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffe048e73f10266d0008200b670001844a2b00dc6700017c42a7487800084eba3a224878000342a7487800084eba3a6a23c0000086fe4eba53044fef001470002079000086fe3028000472ead2b90000c75034102b40ffea2b41ffe60802000267047002600270014eba6a862b40ffe6222dffeab2806d02220070003028000233fc00010000a82642790000a8282079000086fe41e8000a2b40ffee2b41ffea2b48fffc4eba527e4eba526210390000061e7259b001663a2079000086fe30100800000267047002600270012f40001c202dffea222f001c4eba6a362e0006470016200748c0487801f42f004ebad69c504f70002f002f00487800034eba399a4fef000c23c0000086fe203cfffffee4d0adffee4a806a025280e2802c0078002a060645011b202dffea53803b40fff2226dfffc70002c79000028584eaefe9e33fc00010000cc5e41eb00dc200648c0220448c1240548c2362dfff248c32f032f022f012f002f082f2dfffc4eba20f24878000342a7487800084eba391c23c0000086fe4eba04822e8b6100f60a4fef00244cdf08fc4e5d4e75
 *   got:     9efc001448e707162a6f0030200d6700017e4a2d00dc6700017642a748780008610000004878000342a7487800086100000023c000000000610000004fef0014207900000000302800047e003e007aeadab900000000301008000002670870022f400028600670012f4000282f052f2f002c610000002a00504fbe856d022e05207900000000302800027c003c0033fc000100000000427900000000207900000000d0fc000a264861000000610000001039000000007259b0016642207900000000301008000002670870022f400028600670012f4000282f2f00282f07610000003f400020064000163f40002048c0487801f42f00610000004fef001070002f002f00487800036100000023c000000000200604800000011ce28842af002c2f40003006800000011b220753812f4000283f410026224b2c790000000070004eaefe9e33fc00010000000041ed00dc302f002648c02e802f2f00282f2f00302f2f00382f082f0b610000004878000342a7487800086100000023c000000000610000002e8d610000004fef002c4cdf68e0defc00144e75
 *   summary: 408 got vs 412 ref, four bytes short. The original spills the width, the height and the rastport pointer to negative A5 displacements and reloads them across the two transition calls; 6.51 keeps one of the three in a register. All three view-mode context builds with their distinct argument triples, the column-count test on bit 2 (twice, as in the original), the clamp of the width against the scaled span, the banner-character transition gated on the 89 flag, the -284 centring divide and the six-argument formatted-text draw match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics.h"

struct DisplayContext {
    short flags;                /* +0 */
    short height;               /* +2 */
    short width;                /* +4 */
};

struct HighlightCtx {
    char pad0[220];
    char text[2];               /* +220 */
};

extern struct DisplayContext *WDISP_DisplayContextBase;
extern long  TEXTDISP_EntryTextBaseWidthPx;
extern short WDISP_AccumulatorCaptureActive;
extern short WDISP_AccumulatorFlushPending;
extern short TEXTDISP_LinePenOverrideEnabledFlag;
extern unsigned char CONFIG_LRBN_FlagChar;

extern void  TLIBA3_ClearViewModeRastPort(long mode, long flags);
extern struct DisplayContext *TLIBA3_BuildDisplayContextForViewMode(long mode,
                 long a, long b);
extern void  ESQ_SetCopperEffect_OnEnableHighlight(void);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern long __asm MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern void  ESQIFF_RunCopperDropTransition(void);
extern void  ESQIFF_RestoreBasePaletteTriples(void);
extern long  SCRIPT_BeginBannerCharTransition(long target, long rate);
extern void  TLIBA1_DrawFormattedTextBlock(struct RastPort *rp, char *text,
                 long x, long y, long right, long bottom);
extern void  ESQIFF_RunCopperRiseTransition(void);
extern void  TEXTDISP_ResetSelectionState(struct HighlightCtx *ctx);

void TEXTDISP_DrawHighlightFrame(struct HighlightCtx *ctx)
{
    struct RastPort *rp;
    long width;
    long height;
    long span;
    long cols;
    long left;
    long top;
    long right;
    short bottom;
    short bannerChar;

    if (ctx == 0)
        return;
    if (ctx->text[0] == 0)
        return;

    TLIBA3_ClearViewModeRastPort(8, 0);
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(8, 0, 3);
    ESQ_SetCopperEffect_OnEnableHighlight();

    width = (unsigned short)WDISP_DisplayContextBase->width;
    span = TEXTDISP_EntryTextBaseWidthPx - 22;
    if (WDISP_DisplayContextBase->flags & 4)
        cols = 2;
    else
        cols = 1;
    span = MATH_Mulu32(cols, span);
    if (width >= span)
        width = span;

    height = (unsigned short)WDISP_DisplayContextBase->height;
    WDISP_AccumulatorCaptureActive = 1;
    WDISP_AccumulatorFlushPending = 0;
    rp = (struct RastPort *)((char *)WDISP_DisplayContextBase + 10);

    ESQIFF_RunCopperDropTransition();
    ESQIFF_RestoreBasePaletteTriples();

    if (CONFIG_LRBN_FlagChar == 'Y') {
        if (WDISP_DisplayContextBase->flags & 4)
            cols = 2;
        else
            cols = 1;
        bannerChar = MATH_DivS32(width, cols);
        bannerChar += 22;
        SCRIPT_BeginBannerCharTransition((long)bannerChar, 500);
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 0);

    left = (0xfffffee4 + height) / 2;
    top = 0;
    right = left + 0x11b;
    bottom = width - 1;

    SetDrMd(rp, 0);
    TEXTDISP_LinePenOverrideEnabledFlag = 1;

    TLIBA1_DrawFormattedTextBlock(rp, ctx->text, left, top, right, (long)bottom);

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(8, 0, 3);
    ESQIFF_RunCopperRiseTransition();
    TEXTDISP_ResetSelectionState(ctx);
}
