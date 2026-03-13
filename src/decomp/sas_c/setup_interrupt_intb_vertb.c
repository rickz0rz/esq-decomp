#include <proto/exec.h>
#include <exec/interrupts.h>

extern struct Interrupt *Global_REF_INTERRUPT_STRUCT_INTB_VERTB;
extern const char Global_STR_ESQFUNC_C_1[];
extern const char Global_STR_VERTICAL_BLANK_INT[];
extern void ESQ_VerticalBlankInterruptUserData(void);

extern struct Interrupt *MEMORY_AllocateMemory(ULONG bytes, ULONG flags);
extern void ESQ_TickGlobalCounters(void);

#ifndef MEMF_PUBLIC
#define MEMF_PUBLIC 1UL
#endif
#ifndef INTB_VERTB
#define INTB_VERTB 5
#endif

void SETUP_INTERRUPT_INTB_VERTB(void)
{
    struct Interrupt *intr;

    intr = MEMORY_AllocateMemory(22, MEMF_PUBLIC);
    Global_REF_INTERRUPT_STRUCT_INTB_VERTB = intr;

    intr->is_Node.ln_Type = 2;
    intr->is_Node.ln_Pri = 0;
    intr->is_Node.ln_Name = (char *)Global_STR_VERTICAL_BLANK_INT;
    intr->is_Data = (APTR)ESQ_VerticalBlankInterruptUserData;
    intr->is_Code = (VOID (*)())ESQ_TickGlobalCounters;

    AddIntVector(INTB_VERTB, intr);
}
