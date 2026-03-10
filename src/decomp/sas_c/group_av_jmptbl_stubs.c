typedef signed long LONG;

typedef struct GCOMMAND_CtrlPacket {
    unsigned char pad0[4];
    unsigned char type4;
} GCOMMAND_CtrlPacket;

extern void *ALLOCATE_AllocAndInitializeIOStdReq(void *replyPort);
extern void *SIGNAL_CreateMsgPortWithSignal(const char *name, LONG pri);
extern void DISKIO_ProbeDrivesAndAssignPaths(void);
extern void ESQ_InvokeGcommandInit(const GCOMMAND_CtrlPacket *cmdPtr, void *unusedA1);
extern LONG EXEC_CallVector_48(void *a0, void *a1, LONG d1, void *a2);

void *GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(void *replyPort)
{
    return ALLOCATE_AllocAndInitializeIOStdReq(replyPort);
}

void *GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(const char *name, LONG pri)
{
    return SIGNAL_CreateMsgPortWithSignal(name, pri);
}

void GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(void)
{
    DISKIO_ProbeDrivesAndAssignPaths();
}

void GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit(const GCOMMAND_CtrlPacket *cmdPtr, void *unusedA1)
{
    ESQ_InvokeGcommandInit(cmdPtr, unusedA1);
}

LONG GROUP_AV_JMPTBL_EXEC_CallVector_48(void *a0, void *a1, LONG d1, void *a2)
{
    return EXEC_CallVector_48(a0, a1, d1, a2);
}
