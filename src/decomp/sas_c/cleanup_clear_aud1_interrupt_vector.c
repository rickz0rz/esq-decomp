#include <exec/types.h>
#include <hardware/intbits.h>

enum {
    CUSTOM_INTENA = 0xDFF09A,
    INTENA_AUD1_DISABLE_MASK = 0x0100,
    INTERRUPT_STRUCT_SIZE = 22,
    INTERRUPT_FREE_LINE = 74
};

extern void *AbsExecBase;
extern LONG Global_REF_INTB_AUD1_INTERRUPT;
extern LONG Global_REF_INTERRUPT_STRUCT_INTB_AUD1;
extern const char Global_STR_CLEANUP_C_2[];

/* base-first _LVO ABI. SetIntVector(execBase; D0=intNumber, A1=interrupt).
   Restores the saved old AUD1 vector captured by SetIntVector at setup time. */
void _LVOSetIntVector(void *execBase, LONG intNumber, void *interrupt);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void CLEANUP_ClearAud1InterruptVector(void)
{
    *((volatile unsigned short *)CUSTOM_INTENA) = INTENA_AUD1_DISABLE_MASK; /* INTENA */
    _LVOSetIntVector(AbsExecBase, INTB_AUD1, (void *)Global_REF_INTB_AUD1_INTERRUPT);

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_2,
        INTERRUPT_FREE_LINE,
        (void *)Global_REF_INTERRUPT_STRUCT_INTB_AUD1,
        INTERRUPT_STRUCT_SIZE
    );
}
