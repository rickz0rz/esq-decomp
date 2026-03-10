typedef signed long LONG;

extern void ALLOCATE_AllocAndInitializeIOStdReq(void);
extern void *SIGNAL_CreateMsgPortWithSignal(const char *name, LONG pri);
extern void DISKIO_ProbeDrivesAndAssignPaths(void);
extern void ESQ_InvokeGcommandInit(void);
extern void EXEC_CallVector_48(void);

void GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(void)
{
    ALLOCATE_AllocAndInitializeIOStdReq();
}

void *GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(const char *name, LONG pri)
{
    return SIGNAL_CreateMsgPortWithSignal(name, pri);
}

void GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(void)
{
    DISKIO_ProbeDrivesAndAssignPaths();
}

void GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit(void)
{
    ESQ_InvokeGcommandInit();
}

void GROUP_AV_JMPTBL_EXEC_CallVector_48(void)
{
    EXEC_CallVector_48();
}
