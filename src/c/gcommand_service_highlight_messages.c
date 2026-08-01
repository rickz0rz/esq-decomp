/* RESTORES: _GCOMMAND_ServiceHighlightMessages
 * MODULE:   modules/groups/a/u/gcommand3b_p3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: exec-base-and-saved-a6
 *   ref:     4ab9000068ae66662079000028c42c7800044eaefe8c23c0000068ae4a80674e2040222800204a816b082f006100f79e584f2079000068ae23e800140000b30223e800180000b30623e8001c0000b30a102800364a006716720012002f016100f218584f2079000068ae422800366100ff166100fe764ab9000068ae670000a22079000068ae302800347200b04162064ebad52460324a79000068a867046100f64e6100f7702279000068ae4ebad4ca2079000068ae30280034220053412079000068ae314100342079000068ae302800347200b041624c21790000b30200142079000068ae21790000b30600182079000068ae21790000b30a001c2079000068ae3141003442a800202279000068ae2c7800044eaefe8642b9000068ae60044ebad4944e75
 *   got:     2f0e4ab90000000066782079000000002c79000000004eaefe8c23c00000000067602040222800204a816b082f0061000000584f20790000000023e800140000000020790000000023e800180000000020790000000023e8001c00000000207900000000102800364a006716720012002f0161000000584f2079000000004228003661000000610000004ab9000000006608610000006000009e207900000000302800346f32303900000000670461000000610000002279000000006100000020790000000030280034534020790000000031400034600461000000207900000000302800346e4e21790000000000142079000000002179000000000018207900000000217900000000001c2079000000004268003420790000000042a800202279000000002c79000000004eaefe8642b9000000002c5f4e754e71
 *   summary: 316 got vs 294 ref, and most of the excess is the exec base. The original reaches it as MOVEA.L AbsExecBase,A6, four bytes, at both library call sites; the volatile esq-exec.h base is a data symbol, so 6.51 emits MOVEA.L _SysBase,A6, six bytes, and it also saves and restores A6 around the whole body (2f0e / 2c5f) which the original does not. ESQSHARED4_CopyPlanesFromContextToSnapshot took its argument in A1 with nothing on the stack, and this file used to declare it __asm register __a1. Both sides are C since 2026-08-01, so the convention is C's and the clobber question that note raises no longer applies -- SAS/C saves whatever the callee uses. The GetMsg gate, the negative preset-record test, the three saved fields, the keycode dispatch, the countdown decrement and the ReplyMsg teardown match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <exec/ports.h>
#include "esq-exec.h"

struct HighlightMsg {
    char  pad0[20];
    long  field20;          /* +20 */
    long  field24;          /* +24 */
    long  field28;          /* +28 */
    long  presetRecord;     /* +32 */
    char  pad36[16];
    short ticks;            /* +52 */
    char  keycode;          /* +54 */
};

extern struct HighlightMsg *GCOMMAND_ActiveHighlightMsgPtr;
extern struct MsgPort      *ESQ_HighlightMsgPort;
extern long  GCOMMAND_ActiveMsgSavedField20;
extern long  GCOMMAND_ActiveMsgSavedField24;
extern long  GCOMMAND_ActiveMsgSavedField28;
extern short GCOMMAND_PresetWorkResetPendingFlag;

extern void GCOMMAND_LoadPresetWorkEntries(struct HighlightMsg *msg);
extern void GCOMMAND_MapKeycodeToPreset(long keycode);
extern void GCOMMAND_RefreshBannerTables(void);
extern void GCOMMAND_ConsumeBannerQueueEntry(void);
extern void GCOMMAND_ResetPresetWorkTables(void);
extern void GCOMMAND_TickPresetWorkEntries(void);
extern void ESQSHARED4_CopyLivePlanesToSnapshot(void);
/* Takes its argument in A1 and reads nothing from the stack. */
/* Both sides are C now, so the convention is C's and the clobber question the
 * header above raises no longer applies: SAS/C saves whatever the callee uses. */
extern void ESQSHARED4_CopyPlanesFromContextToSnapshot(long **ctx);

void GCOMMAND_ServiceHighlightMessages(void)
{
    if (GCOMMAND_ActiveHighlightMsgPtr == 0) {
        GCOMMAND_ActiveHighlightMsgPtr =
            (struct HighlightMsg *)GetMsg(ESQ_HighlightMsgPort);
        if (GCOMMAND_ActiveHighlightMsgPtr != 0) {
            if (GCOMMAND_ActiveHighlightMsgPtr->presetRecord >= 0)
                GCOMMAND_LoadPresetWorkEntries(GCOMMAND_ActiveHighlightMsgPtr);
            GCOMMAND_ActiveMsgSavedField20 = GCOMMAND_ActiveHighlightMsgPtr->field20;
            GCOMMAND_ActiveMsgSavedField24 = GCOMMAND_ActiveHighlightMsgPtr->field24;
            GCOMMAND_ActiveMsgSavedField28 = GCOMMAND_ActiveHighlightMsgPtr->field28;
            if (GCOMMAND_ActiveHighlightMsgPtr->keycode != 0) {
                GCOMMAND_MapKeycodeToPreset(
                    (long)(unsigned char)GCOMMAND_ActiveHighlightMsgPtr->keycode);
                GCOMMAND_ActiveHighlightMsgPtr->keycode = 0;
            }
        }
    }

    GCOMMAND_RefreshBannerTables();
    GCOMMAND_ConsumeBannerQueueEntry();

    if (GCOMMAND_ActiveHighlightMsgPtr == 0) {
        ESQSHARED4_CopyLivePlanesToSnapshot();
        return;
    }

    if (GCOMMAND_ActiveHighlightMsgPtr->ticks > 0) {
        if (GCOMMAND_PresetWorkResetPendingFlag != 0)
            GCOMMAND_ResetPresetWorkTables();
        GCOMMAND_TickPresetWorkEntries();
        ESQSHARED4_CopyPlanesFromContextToSnapshot(GCOMMAND_ActiveHighlightMsgPtr);
        GCOMMAND_ActiveHighlightMsgPtr->ticks =
            GCOMMAND_ActiveHighlightMsgPtr->ticks - 1;
    } else {
        ESQSHARED4_CopyLivePlanesToSnapshot();
    }

    if (GCOMMAND_ActiveHighlightMsgPtr->ticks > 0)
        return;

    GCOMMAND_ActiveHighlightMsgPtr->field20 = GCOMMAND_ActiveMsgSavedField20;
    GCOMMAND_ActiveHighlightMsgPtr->field24 = GCOMMAND_ActiveMsgSavedField24;
    GCOMMAND_ActiveHighlightMsgPtr->field28 = GCOMMAND_ActiveMsgSavedField28;
    GCOMMAND_ActiveHighlightMsgPtr->ticks = 0;
    GCOMMAND_ActiveHighlightMsgPtr->presetRecord = 0;
    ReplyMsg((struct Message *)GCOMMAND_ActiveHighlightMsgPtr);
    GCOMMAND_ActiveHighlightMsgPtr = 0;
}
