/* RESTORES: _ESQIFF_PlayNextExternalAssetFrame
 * MODULE:   modules/groups/a/n/esqiffbb_p0_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: global-reload-per-test
 *   ref:     4e55fff848e703003e2d000a6100f9b64a4767084ab900005a8466104a476600016e4ab900005a88670001643039000087bc32390000a8bcb04164224a47661e4a790000a91066166100f9484ebac80e487800024ebae910584f600001444ebac7fc4878000142a7487800044eba02ee23c0000086fe204041e8000a224870022c79000028584eaeff164ebac94c4fef000c4a476708207900005a846006207900005a882b48fffa4eba02d07001be4066183039000028f85540670a3039000028f8574066044eba0318200748c02f006100fb22584f4a4766544a790000a910664c2079000086fe41e8000a224870002c79000028584eaefe9e6100fa4a33f90000a8bc0000c75848780002487800014eba026e504f2079000086fe41e8000a224870012c79000028584eaefe9e2079000086fe41e8000a224870012c79000028584eaefeaa2c7800044eaeff7c4a47671a53b9000001b42f3900005a844eba0256584f23c000005a84601853b9000001b82f3900005a884eba023c584f23c000005a882c7800044eaeff7660126100f8024ebac6c8487800024ebae7ca584f3c390000a82642790000a8266100f80833c60000a8264a47670c487800016100fdb8584f600842a76100fdae584f
 *   got:     48e703063e2f0016610000004a4767084ab90000000066104a47660001704ab90000000067000166303900000000323900000000b04164224a47661e303900000000661661000000610000004878000261000000584f60000146610000004878000142a7487800046100000023c0000000002040d0fc000a22482c790000000070024eaeff16610000004fef000c4a4767082a790000000060062a7900000000610000002007534066183039000000005540670a3039000000005740660461000000300748c02f0061000000584f4a476656303900000000664e207900000000d0fc000a22482c790000000070004eaefe9e6100000030390000000033c000000000487800024878000161000000504f207900000000d0fc000a22482c790000000070014eaefe9e207900000000d0fc000a22482c790000000070014eaefeaa2c79000000004eaeff7c4a47671a53b9000000002f39000000006100000023c000000000584f601853b9000000002f39000000006100000023c000000000584f2c79000000004eaeff76601261000000610000004878000261000000584f3c39000000004279000000006100000033c6000000004a47670c4878000161000000584f600842a761000000584f4cdf60c04e754e71
 *   summary: 468 got vs 462 ref, six bytes over. 6.51 reloads the comma flag and the mode word for the second half of the two-term guards where the original still holds the condition codes. The four-way entry gate that falls back to a palette restore when the selected brush list is empty, the state-table comparison that short-circuits the render, the view-mode context build with its rastport at +10, the mode-1 deferred-tick assertion on countdown 2 or 3, the channel banner block whose SetAPen runs on both paths, the Forbid-bracketed pop of the correct brush list and the capture-flag save around the rise transition all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics.h"
#include "esq-exec.h"

extern char *WDISP_DisplayContextBase;
extern char *ESQIFF_GAdsBrushListHead;
extern char *ESQIFF_LogoBrushListHead;
extern long  ESQIFF_GAdsBrushListCount;
extern long  ESQIFF_LogoBrushListCount;
extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern unsigned short ESQIFF_ExternalAssetStateTable;
extern short ESQIFF_ExternalAssetPathCommaFlag;
extern short TEXTDISP_DeferredActionCountdown;
extern short TEXTDISP_CurrentMatchIndex;
extern short WDISP_AccumulatorCaptureActive;

extern void  ESQIFF_RunCopperDropTransition(void);
extern void  ESQIFF_RunCopperRiseTransition(void);
extern void  ESQIFF_RestoreBasePaletteTriples(void);
extern void  GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void  ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(long mode);
extern char *ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(long mode,
                 long a, long b);
extern void  ESQDISP_ProcessGridMessagesIfIdle(void);
extern void  ESQIFF_JMPTBL_ESQ_NoOp(void);
extern void  ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled(void);
extern void  ESQIFF_ShowExternalAssetWithCopperFx(long mode);
extern void  ESQIFF_SetApenToBrightestPaletteIndex(void);
extern void  ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner(long a, long b);
extern char *ESQIFF_JMPTBL_BRUSH_PopBrushHead(char *head);
extern void  ESQIFF_ServiceExternalAssetSourceState(long mode);

void ESQIFF_PlayNextExternalAssetFrame(short mode)
{
    char *head;
    short savedCapture;

    ESQIFF_RunCopperDropTransition();

    if ((mode != 0 && ESQIFF_GAdsBrushListHead != 0)
        || (mode == 0 && ESQIFF_LogoBrushListHead != 0)) {

        if (TEXTDISP_PrimaryGroupEntryCount < ESQIFF_ExternalAssetStateTable
            && mode == 0 && ESQIFF_ExternalAssetPathCommaFlag == 0) {
            ESQIFF_RestoreBasePaletteTriples();
            GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight();
            ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(2);
        } else {
            GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight();
            WDISP_DisplayContextBase =
                ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(4, 0, 1);
            SetRast((struct RastPort *)(WDISP_DisplayContextBase + 10), 2);
            ESQDISP_ProcessGridMessagesIfIdle();

            if (mode != 0)
                head = ESQIFF_GAdsBrushListHead;
            else
                head = ESQIFF_LogoBrushListHead;

            ESQIFF_JMPTBL_ESQ_NoOp();

            if (mode == 1 && (TEXTDISP_DeferredActionCountdown == 2
                              || TEXTDISP_DeferredActionCountdown == 3))
                ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled();

            ESQIFF_ShowExternalAssetWithCopperFx((long)mode);

            if (mode == 0 && ESQIFF_ExternalAssetPathCommaFlag == 0) {
                SetDrMd((struct RastPort *)(WDISP_DisplayContextBase + 10), 0);
                ESQIFF_SetApenToBrightestPaletteIndex();
                TEXTDISP_CurrentMatchIndex = ESQIFF_ExternalAssetStateTable;
                ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner(1, 2);
                SetDrMd((struct RastPort *)(WDISP_DisplayContextBase + 10), 1);
            }
            SetAPen((struct RastPort *)(WDISP_DisplayContextBase + 10), 1);

            Forbid();
            if (mode != 0) {
                ESQIFF_GAdsBrushListCount--;
                ESQIFF_GAdsBrushListHead =
                    ESQIFF_JMPTBL_BRUSH_PopBrushHead(ESQIFF_GAdsBrushListHead);
            } else {
                ESQIFF_LogoBrushListCount--;
                ESQIFF_LogoBrushListHead =
                    ESQIFF_JMPTBL_BRUSH_PopBrushHead(ESQIFF_LogoBrushListHead);
            }
            Permit();
        }
    } else {
        ESQIFF_RestoreBasePaletteTriples();
        GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight();
        ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(2);
    }

    savedCapture = WDISP_AccumulatorCaptureActive;
    WDISP_AccumulatorCaptureActive = 0;
    ESQIFF_RunCopperRiseTransition();
    WDISP_AccumulatorCaptureActive = savedCapture;

    if (mode != 0)
        ESQIFF_ServiceExternalAssetSourceState(1);
    else
        ESQIFF_ServiceExternalAssetSourceState(0);
}
