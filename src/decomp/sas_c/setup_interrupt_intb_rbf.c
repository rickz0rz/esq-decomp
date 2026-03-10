#include <proto/exec.h>
#include <exec/interrupts.h>

extern struct Interrupt *Global_REF_INTERRUPT_STRUCT_INTB_RBF;
extern APTR Global_REF_INTB_RBF_64K_BUFFER;
extern APTR Global_REF_INTB_RBF_INTERRUPT;
extern const char Global_STR_ESQFUNC_C_3[];
extern const char Global_STR_ESQFUNC_C_4[];
extern const char Global_STR_RS232_RECEIVE_HANDLER[];

extern struct Interrupt *ESQIFF_JMPTBL_MEMORY_AllocateMemory(const void *fileTag, LONG line, ULONG bytes, ULONG flags);
extern LONG ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt(void);

#ifndef MEMF_PUBLIC
#define MEMF_PUBLIC 1UL
#endif
#ifndef MEMF_CLEAR
#define MEMF_CLEAR 65536UL
#endif
#ifndef INTB_RBF
#define INTB_RBF 11
#endif

void SETUP_INTERRUPT_INTB_RBF(void)
{
    struct Interrupt *intr;

    intr = ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_STR_ESQFUNC_C_3, 1195, 22, MEMF_PUBLIC);
    Global_REF_INTERRUPT_STRUCT_INTB_RBF = intr;

    Global_REF_INTB_RBF_64K_BUFFER = ESQIFF_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_ESQFUNC_C_4, 1197, 64000, MEMF_PUBLIC + MEMF_CLEAR);

    intr->is_Node.ln_Type = 2;
    intr->is_Node.ln_Pri = 0;
    intr->is_Node.ln_Name = (char *)Global_STR_RS232_RECEIVE_HANDLER;
    intr->is_Data = Global_REF_INTB_RBF_64K_BUFFER;
    intr->is_Code = (VOID (*)())ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt;

    Global_REF_INTB_RBF_INTERRUPT = SetIntVector(INTB_RBF, intr);
}
