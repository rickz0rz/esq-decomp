typedef long LONG;

extern LONG Global_REF_INTB_AUD1_INTERRUPT;
extern LONG Global_REF_INTERRUPT_STRUCT_INTB_AUD1;
extern char Global_STR_CLEANUP_C_2[];

void _LVOSetIntVector(void);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void CLEANUP_ClearAud1InterruptVector(void)
{
    *((volatile unsigned short *)0xDFF09A) = 0x0100; /* INTENA */
    _LVOSetIntVector();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_2,
        74,
        (void *)Global_REF_INTERRUPT_STRUCT_INTB_AUD1,
        22
    );
}
