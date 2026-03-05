typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct HighlightMsg {
    UBYTE pad0[20];
    LONG saved20;
    LONG saved24;
    LONG saved28;
    LONG presetRecordPtr;
    UBYTE pad1[16];
    WORD countdown;
    UBYTE trigger;
} HighlightMsg;

extern void *AbsExecBase;
extern void *ESQ_HighlightMsgPort;

extern HighlightMsg *GCOMMAND_ActiveHighlightMsgPtr;
extern LONG GCOMMAND_ActiveMsgSavedField20;
extern LONG GCOMMAND_ActiveMsgSavedField24;
extern LONG GCOMMAND_ActiveMsgSavedField28;
extern WORD GCOMMAND_PresetWorkResetPendingFlag;

extern void GCOMMAND_LoadPresetWorkEntries(void *record);
extern void GCOMMAND_MapKeycodeToPreset(LONG keycode);
extern void GCOMMAND_RefreshBannerTables(void);
extern void GCOMMAND_ConsumeBannerQueueEntry(void);
extern void GCOMMAND_ResetPresetWorkTables(void);
extern void GCOMMAND_TickPresetWorkEntries(void);
extern void ESQSHARED4_CopyPlanesFromContextToSnapshot(void *context);
extern void ESQSHARED4_CopyLivePlanesToSnapshot(void);

extern LONG _LVOGetMsg(void *execBase, void *port);
extern void _LVOReplyMsg(void *execBase, void *msg);

void GCOMMAND_ServiceHighlightMessages(void)
{
    HighlightMsg *msg;

    if (GCOMMAND_ActiveHighlightMsgPtr == (HighlightMsg *)0) {
        msg = (HighlightMsg *)_LVOGetMsg(AbsExecBase, ESQ_HighlightMsgPort);
        GCOMMAND_ActiveHighlightMsgPtr = msg;
        if (msg != (HighlightMsg *)0) {
            if (msg->presetRecordPtr >= 0) {
                GCOMMAND_LoadPresetWorkEntries(msg);
            }

            GCOMMAND_ActiveMsgSavedField20 = msg->saved20;
            GCOMMAND_ActiveMsgSavedField24 = msg->saved24;
            GCOMMAND_ActiveMsgSavedField28 = msg->saved28;

            if (msg->trigger != 0) {
                GCOMMAND_MapKeycodeToPreset((LONG)msg->trigger);
                msg->trigger = 0;
            }
        }
    }

    GCOMMAND_RefreshBannerTables();
    GCOMMAND_ConsumeBannerQueueEntry();

    msg = GCOMMAND_ActiveHighlightMsgPtr;
    if (msg == (HighlightMsg *)0) {
        ESQSHARED4_CopyLivePlanesToSnapshot();
        return;
    }

    if (msg->countdown <= 0) {
        ESQSHARED4_CopyLivePlanesToSnapshot();
    } else {
        if (GCOMMAND_PresetWorkResetPendingFlag != 0) {
            GCOMMAND_ResetPresetWorkTables();
        }
        GCOMMAND_TickPresetWorkEntries();
        ESQSHARED4_CopyPlanesFromContextToSnapshot(msg);
        msg->countdown = (WORD)(msg->countdown - 1);
    }

    if (msg->countdown > 0) {
        return;
    }

    msg->saved20 = GCOMMAND_ActiveMsgSavedField20;
    msg->saved24 = GCOMMAND_ActiveMsgSavedField24;
    msg->saved28 = GCOMMAND_ActiveMsgSavedField28;
    msg->countdown = 0;
    msg->presetRecordPtr = 0;

    _LVOReplyMsg(AbsExecBase, msg);
    GCOMMAND_ActiveHighlightMsgPtr = (HighlightMsg *)0;
}
