#include <exec/types.h>
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
extern void ESQ_InvokeGcommandInit(void);

void KYBD_InitializeInputDevices(void)
{
    const LONG SIGBIT_DEFAULT = 0;
    const LONG UNIT_INPUTDEVICE = 0;
    const LONG UNIT_CONSOLE = -1;
    const LONG OPEN_FLAGS_NONE = 0;
    const LONG CONSOLE_IO_LIBBASE_OFFSET = 20;
    const LONG INPUTBUF_ALLOC_LINE = 121;
    const LONG INPUTBUF_SIZE = 22;
    const LONG MEMF_PUBLIC = 1;
    const LONG INPUTBUF_HANDLER_DATA_OFFSET = 14;
    const LONG INPUTBUF_HANDLER_FN_OFFSET = 18;
    const LONG INPUTBUF_FLAGS_OFFSET = 9;
    const UBYTE INPUTBUF_FLAGS_VALUE = 0x33;
    const UWORD IOREQ_CMD_ADDHANDLER = 9;
    const LONG INDEX_RESET = 0;
    UBYTE *inputBuf;
    UBYTE *consoleIo;

    GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths();

    Global_REF_INPUTDEVICE_MSGPORT =
        GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(Global_STR_INPUTDEVICE, SIGBIT_DEFAULT);
    Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE = GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(Global_REF_INPUTDEVICE_MSGPORT);

    Global_REF_CONSOLEDEVICE_MSGPORT =
        GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal(Global_STR_CONSOLEDEVICE, SIGBIT_DEFAULT);
    Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE = GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq(Global_REF_CONSOLEDEVICE_MSGPORT);

    _LVOOpenDevice(
        AbsExecBase, Global_STR_INPUT_DEVICE, UNIT_INPUTDEVICE, Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE, OPEN_FLAGS_NONE);
    _LVOOpenDevice(
        AbsExecBase, Global_STR_CONSOLE_DEVICE, UNIT_CONSOLE, Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE, OPEN_FLAGS_NONE);

    consoleIo = (UBYTE *)Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE;
    INPUTDEVICE_LibraryBaseFromConsoleIo = *(LONG *)(consoleIo + CONSOLE_IO_LIBBASE_OFFSET);

    inputBuf = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_KYBD_C, INPUTBUF_ALLOC_LINE, INPUTBUF_SIZE, MEMF_PUBLIC);
    Global_REF_DATA_INPUT_BUFFER = inputBuf;

    *(LONG *)(inputBuf + INPUTBUF_HANDLER_DATA_OFFSET) = INPUTDEVICE_HandlerUserDataLong;
    *(LONG *)(inputBuf + INPUTBUF_HANDLER_FN_OFFSET) = (LONG)ESQ_InvokeGcommandInit;
    *(UBYTE *)(inputBuf + INPUTBUF_FLAGS_OFFSET) = INPUTBUF_FLAGS_VALUE;

    *(UWORD *)((UBYTE *)Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE + Struct_IOStdReq__io_Command) = IOREQ_CMD_ADDHANDLER;
    *(LONG *)((UBYTE *)Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE + Struct_IOStdReq__io_Data) = (LONG)Global_REF_DATA_INPUT_BUFFER;

    _LVODoIO(AbsExecBase, Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE);

    ED_StateRingWriteIndex = INDEX_RESET;
    ED_StateRingIndex = INDEX_RESET;
}
