#include <exec/types.h>
enum {
    INTERRUPT_STRUCT_SIZE = 22,
    INTERRUPT_FREE_LINE = 57
};

extern LONG Global_REF_INTERRUPT_STRUCT_INTB_VERTB;
extern const char Global_STR_CLEANUP_C_1[];

void _LVORemIntServer(void);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void CLEANUP_ClearVertbInterruptServer(void)
{
    _LVORemIntServer();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_1,
        INTERRUPT_FREE_LINE,
        (void *)Global_REF_INTERRUPT_STRUCT_INTB_VERTB,
        INTERRUPT_STRUCT_SIZE
    );
}
