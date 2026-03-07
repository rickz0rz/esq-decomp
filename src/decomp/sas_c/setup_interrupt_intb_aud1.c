#include <proto/exec.h>
#include <exec/interrupts.h>

extern struct Interrupt *Global_REF_INTERRUPT_STRUCT_INTB_AUD1;
extern APTR Global_REF_INTB_AUD1_INTERRUPT;
extern const char Global_STR_ESQFUNC_C_2[];
extern const char Global_STR_JOYSTICK_INT[];
extern UBYTE CTRL_SampleEntryScratch;

extern struct Interrupt *ESQIFF_JMPTBL_MEMORY_AllocateMemory(const void *fileTag, LONG line, ULONG bytes, ULONG flags);
extern void ESQFUNC_JMPTBL_ESQ_PollCtrlInput(void);

#ifndef MEMF_CHIP
#define MEMF_CHIP 2UL
#endif
#ifndef INTB_AUD1
#define INTB_AUD1 8
#endif

void SETUP_INTERRUPT_INTB_AUD1(void)
{
    struct Interrupt *intr;

    intr = ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_STR_ESQFUNC_C_2, 1172, 22, MEMF_CHIP);
    Global_REF_INTERRUPT_STRUCT_INTB_AUD1 = intr;

    intr->is_Node.ln_Type = 2;
    intr->is_Node.ln_Pri = 0;
    intr->is_Node.ln_Name = (char *)Global_STR_JOYSTICK_INT;
    intr->is_Data = (APTR)&CTRL_SampleEntryScratch;
    intr->is_Code = (VOID (*)())ESQFUNC_JMPTBL_ESQ_PollCtrlInput;

    Global_REF_INTB_AUD1_INTERRUPT = SetIntVector(INTB_AUD1, intr);
}
