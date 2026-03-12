typedef long LONG;
typedef unsigned short UWORD;

typedef struct IOStdReqApprox {
    char pad0[28];
    UWORD io_Command;
    char pad30[10];
    void *io_Data;
} IOSTDREQ;

extern void *AbsExecBase;
extern IOSTDREQ *Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE;
extern void *Global_REF_DATA_INPUT_BUFFER;
extern IOSTDREQ *Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE;
extern void *Global_REF_INPUTDEVICE_MSGPORT;
extern void *Global_REF_CONSOLEDEVICE_MSGPORT;
extern const char Global_STR_CLEANUP_C_5[];

LONG _LVODoIO(void *execBase, void *ioReq);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
LONG _LVOCloseDevice(void *execBase, void *ioReq);
void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(void *port);
void GROUP_AB_JMPTBL_IOSTDREQ_Free(void *req);

void CLEANUP_ShutdownInputDevices(void)
{
    Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE->io_Command = 10;
    Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE->io_Data = Global_REF_DATA_INPUT_BUFFER;
    _LVODoIO(AbsExecBase, Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE);

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_5,
        127,
        Global_REF_DATA_INPUT_BUFFER,
        20
    );

    _LVOCloseDevice(AbsExecBase, Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE);
    _LVOCloseDevice(AbsExecBase, Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE);

    GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(Global_REF_INPUTDEVICE_MSGPORT);
    GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(Global_REF_CONSOLEDEVICE_MSGPORT);

    GROUP_AB_JMPTBL_IOSTDREQ_Free(Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE);
    GROUP_AB_JMPTBL_IOSTDREQ_Free(Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE);
}
