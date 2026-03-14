#include <exec/types.h>
enum {
    CUSTOM_INTENA = 0xDFF09A,
    INTENA_RBF_DISABLE_MASK = 0x0800,
    RBF_BUFFER_SIZE = 64000,
    INTERRUPT_STRUCT_SIZE = 22,
    RBF_BUFFER_FREE_LINE = 113,
    RBF_VECTOR_FREE_LINE = 118
};

extern LONG WDISP_SerialIoRequestPtr;
extern LONG WDISP_SerialMessagePortPtr;
extern LONG Global_REF_INTB_RBF_INTERRUPT;
extern LONG Global_REF_INTB_RBF_64K_BUFFER;
extern LONG Global_REF_INTERRUPT_STRUCT_INTB_RBF;
extern const char Global_STR_CLEANUP_C_3[];
extern const char Global_STR_CLEANUP_C_4[];

void _LVOCloseDevice(void);
void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(void *port);
void GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(void *ptr);
void _LVOSetIntVector(void);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void CLEANUP_ClearRbfInterruptAndSerial(void)
{
    *((volatile unsigned short *)CUSTOM_INTENA) = INTENA_RBF_DISABLE_MASK; /* INTENA */

    _LVOCloseDevice();
    GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport((void *)WDISP_SerialMessagePortPtr);
    GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField((void *)WDISP_SerialIoRequestPtr);

    _LVOSetIntVector();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_3,
        RBF_BUFFER_FREE_LINE,
        (void *)Global_REF_INTB_RBF_64K_BUFFER,
        RBF_BUFFER_SIZE
    );

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_4,
        RBF_VECTOR_FREE_LINE,
        (void *)Global_REF_INTERRUPT_STRUCT_INTB_RBF,
        INTERRUPT_STRUCT_SIZE
    );
}
