#include <exec/types.h>
#include <hardware/intbits.h>

enum {
    INTERRUPT_STRUCT_SIZE = 22,
    INTERRUPT_FREE_LINE = 57
};

extern void *AbsExecBase;
extern LONG Global_REF_INTERRUPT_STRUCT_INTB_VERTB;
extern const char Global_STR_CLEANUP_C_1[];

/* base-first _LVO ABI. RemIntServer(execBase; D0=intNumber, A1=interrupt). */
void _LVORemIntServer(void *execBase, LONG intNumber, void *interrupt);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void CLEANUP_ClearVertbInterruptServer(void)
{
    _LVORemIntServer(AbsExecBase, INTB_VERTB, (void *)Global_REF_INTERRUPT_STRUCT_INTB_VERTB);

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_1,
        INTERRUPT_FREE_LINE,
        (void *)Global_REF_INTERRUPT_STRUCT_INTB_VERTB,
        INTERRUPT_STRUCT_SIZE
    );
}
