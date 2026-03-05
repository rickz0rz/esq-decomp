typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern const char Global_STR_INPUTDEVICE[];
extern const char Global_STR_CONSOLEDEVICE[];
extern const char Global_STR_INPUT_DEVICE[];
extern const char Global_STR_CONSOLE_DEVICE[];
extern const char Global_STR_KYBD_C[];

extern void *AbsExecBase;
extern void *Global_REF_INPUTDEVICE_MSGPORT;
extern void *Global_REF_CONSOLEDEVICE_MSGPORT;
extern void *Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE;
extern void *Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE;
extern void *Global_REF_DATA_INPUT_BUFFER;
extern LONG INPUTDEVICE_LibraryBaseFromConsoleIo;
extern LONG ED_StateRingWriteIndex;
extern LONG ED_StateRingIndex;

extern const LONG INPUTDEVICE_HandlerUserDataLong;

extern LONG Struct_IOStdReq__io_Command;
extern LONG Struct_IOStdReq__io_Data;

extern void GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(void);
extern void *GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(const char *name, LONG sigBit);
extern void *GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(void *msgPort);
extern LONG _LVOOpenDevice(void *execBase, const char *name, LONG unit, void *ioReq, LONG flags);
extern LONG _LVODoIO(void *execBase, void *ioReq);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit(void);

void KYBD_InitializeInputDevices(void)
{
    UBYTE *inputBuf;
    UBYTE *consoleIo;

    GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths();

    Global_REF_INPUTDEVICE_MSGPORT = GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(Global_STR_INPUTDEVICE, 0);
    Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE = GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(Global_REF_INPUTDEVICE_MSGPORT);

    Global_REF_CONSOLEDEVICE_MSGPORT = GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(Global_STR_CONSOLEDEVICE, 0);
    Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE = GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(Global_REF_CONSOLEDEVICE_MSGPORT);

    _LVOOpenDevice(AbsExecBase, Global_STR_INPUT_DEVICE, 0, Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE, 0);
    _LVOOpenDevice(AbsExecBase, Global_STR_CONSOLE_DEVICE, -1, Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE, 0);

    consoleIo = (UBYTE *)Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE;
    INPUTDEVICE_LibraryBaseFromConsoleIo = *(LONG *)(consoleIo + 20);

    inputBuf = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(Global_STR_KYBD_C, 121, 22, 1);
    Global_REF_DATA_INPUT_BUFFER = inputBuf;

    *(LONG *)(inputBuf + 14) = INPUTDEVICE_HandlerUserDataLong;
    *(LONG *)(inputBuf + 18) = (LONG)GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit;
    *(UBYTE *)(inputBuf + 9) = 0x33;

    *(UWORD *)((UBYTE *)Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE + Struct_IOStdReq__io_Command) = 9;
    *(LONG *)((UBYTE *)Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE + Struct_IOStdReq__io_Data) = (LONG)Global_REF_DATA_INPUT_BUFFER;

    _LVODoIO(AbsExecBase, Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE);

    ED_StateRingWriteIndex = 0;
    ED_StateRingIndex = 0;
}
