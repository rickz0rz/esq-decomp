#include <exec/types.h>

enum {
    CUSTOM_INTENA = 0xDFF09A,
    INTENA_AUD1_DISABLE_MASK = 0x0100,
    INTERRUPT_STRUCT_SIZE = 22,
    INTERRUPT_FREE_LINE = 74
};

extern LONG Global_REF_INTB_AUD1_INTERRUPT;
extern LONG Global_REF_INTERRUPT_STRUCT_INTB_AUD1;
extern const char Global_STR_CLEANUP_C_2[];

void _LVOSetIntVector(void);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void CLEANUP_ClearAud1InterruptVector(void)
{
    *((volatile unsigned short *)CUSTOM_INTENA) = INTENA_AUD1_DISABLE_MASK; /* INTENA */
    _LVOSetIntVector();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_2,
        INTERRUPT_FREE_LINE,
        (void *)Global_REF_INTERRUPT_STRUCT_INTB_AUD1,
        INTERRUPT_STRUCT_SIZE
    );
}
