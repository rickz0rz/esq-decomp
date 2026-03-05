typedef signed short WORD;
typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct MsgLike {
    UBYTE pad0[20];
    LONG field20;
    LONG field24;
    LONG field28;
} MsgLike;

extern MsgLike *GCOMMAND_ActiveHighlightMsgPtr;
extern LONG GCOMMAND_ActiveMsgSavedField20;
extern LONG GCOMMAND_ActiveMsgSavedField24;
extern LONG GCOMMAND_ActiveMsgSavedField28;
extern UBYTE GCOMMAND_HighlightMessageSlotTable[];
extern UBYTE ESQPARS2_BannerQueueBuffer[];

void GCOMMAND_ResetHighlightMessages(void)
{
    LONG i;

    if (GCOMMAND_ActiveHighlightMsgPtr != (MsgLike *)0) {
        GCOMMAND_ActiveHighlightMsgPtr->field20 = GCOMMAND_ActiveMsgSavedField20;
        GCOMMAND_ActiveHighlightMsgPtr->field24 = GCOMMAND_ActiveMsgSavedField24;
        GCOMMAND_ActiveHighlightMsgPtr->field28 = GCOMMAND_ActiveMsgSavedField28;
    }

    for (i = 0; i < 4; ++i) {
        WORD *countdown = (WORD *)(GCOMMAND_HighlightMessageSlotTable + (i * 160L) + 52L);
        UBYTE *trigger = GCOMMAND_HighlightMessageSlotTable + (i * 160L) + 54L;
        *countdown = 0;
        *trigger = 0;
    }

    for (i = 0; i <= 98; ++i) {
        ESQPARS2_BannerQueueBuffer[i] = 0;
    }
}
