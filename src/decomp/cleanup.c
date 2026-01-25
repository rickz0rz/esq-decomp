#include "amiga.h"

/*
 * CLEAR_INTERRUPT_INTB_VERTB (cleanup.s)
 *
 * Tears down the vertical blank interrupt handler when shutting down.
 * The assembly sequence forwards the bookkeeping tag and line number to
 * DEALLOCATE_MEMORY for logging, then frees the Interrupt structure.
 */
void CLEANUP_ClearInterruptVertb(void)
{
    struct Interrupt *interrupt = GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB;

    RemIntServer(INTB_VERTB, interrupt);
    DEALLOCATE_MEMORY(GLOB_STR_CLEANUP_C_1, 57, interrupt, Struct_Interrupt_Size);
}
