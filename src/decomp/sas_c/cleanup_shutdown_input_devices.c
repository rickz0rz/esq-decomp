typedef long LONG;

enum {
    IOSTDREQ_COMMAND_OFFSET = 28,
    IOSTDREQ_BUFFERPTR_OFFSET = 40
};

extern LONG Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE;
extern LONG Global_REF_DATA_INPUT_BUFFER;
extern LONG Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE;
extern LONG Global_REF_INPUTDEVICE_MSGPORT;
extern LONG Global_REF_CONSOLEDEVICE_MSGPORT;
extern const char Global_STR_CLEANUP_C_5[];

void _LVODoIO(void);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
void _LVOCloseDevice(void);
void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(void *port);
void GROUP_AB_JMPTBL_IOSTDREQ_Free(void *req);

void CLEANUP_ShutdownInputDevices(void)
{
    *(unsigned short *)(Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE + IOSTDREQ_COMMAND_OFFSET) = 10;
    *(LONG *)(Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE + IOSTDREQ_BUFFERPTR_OFFSET) = Global_REF_DATA_INPUT_BUFFER;

    _LVODoIO();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_5,
        127,
        (void *)Global_REF_DATA_INPUT_BUFFER,
        20
    );

    _LVOCloseDevice();
    _LVOCloseDevice();

    GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport((void *)Global_REF_INPUTDEVICE_MSGPORT);
    GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport((void *)Global_REF_CONSOLEDEVICE_MSGPORT);

    GROUP_AB_JMPTBL_IOSTDREQ_Free((void *)Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE);
    GROUP_AB_JMPTBL_IOSTDREQ_Free((void *)Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE);
}
