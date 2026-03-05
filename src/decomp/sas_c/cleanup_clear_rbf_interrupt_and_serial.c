typedef long LONG;

extern LONG WDISP_SerialIoRequestPtr;
extern LONG WDISP_SerialMessagePortPtr;
extern LONG Global_REF_INTB_RBF_INTERRUPT;
extern LONG Global_REF_INTB_RBF_64K_BUFFER;
extern LONG Global_REF_INTERRUPT_STRUCT_INTB_RBF;
extern char Global_STR_CLEANUP_C_3[];
extern char Global_STR_CLEANUP_C_4[];

void _LVOCloseDevice(void);
void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(void *port);
void GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(void *ptr);
void _LVOSetIntVector(void);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void CLEANUP_ClearRbfInterruptAndSerial(void)
{
    *((volatile unsigned short *)0xDFF09A) = 0x0800; /* INTENA */

    _LVOCloseDevice();
    GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport((void *)WDISP_SerialMessagePortPtr);
    GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField((void *)WDISP_SerialIoRequestPtr);

    _LVOSetIntVector();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_3,
        113,
        (void *)Global_REF_INTB_RBF_64K_BUFFER,
        64000
    );

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_4,
        118,
        (void *)Global_REF_INTERRUPT_STRUCT_INTB_RBF,
        22
    );
}
