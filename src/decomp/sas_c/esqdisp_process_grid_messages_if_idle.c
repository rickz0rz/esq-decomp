typedef signed short WORD;
typedef signed long LONG;

extern WORD ESQDISP_GridMessagePumpBlockFlag;
extern WORD Global_UIBusyFlag;
extern LONG NEWGRID_MessagePumpSuspendFlag;

extern void ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages(void);

void ESQDISP_ProcessGridMessagesIfIdle(void)
{
    if (ESQDISP_GridMessagePumpBlockFlag != 0) {
        return;
    }

    if (Global_UIBusyFlag != 0) {
        return;
    }

    if (NEWGRID_MessagePumpSuspendFlag != 0) {
        return;
    }

    ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages();
}
