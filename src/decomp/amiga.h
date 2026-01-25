#pragma once

#include <stdint.h>

/* Forward declarations for Exec structures used by cleanup helpers. */
struct ExecBase;
struct Interrupt;

/* Exec vectors that we treat as C-callable functions. */
void RemIntServer(uint8_t interrupt, struct Interrupt *isr);

/* Memory bookkeeping helper exported from the original assembly. */
void DEALLOCATE_MEMORY(const char *tag, uint16_t line, void *address, uint32_t size);

/* Exec global base exported by the runtime. */
extern struct ExecBase *AbsExecBase;

/* Global data symbols referenced by the cleanup code path. */
extern struct Interrupt *GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB;
extern const char GLOB_STR_CLEANUP_C_1[];

/* Allocation statistics maintained by DEALLOCATE_MEMORY. */
extern uint32_t GLOB_BYTES_ALLOCATED;
extern uint32_t GLOB_DEALLOCATIONS;

/* Interrupt vector bit used when removing the vertical blank server. */
enum
{
    INTB_VERTB = 5
};

/* Struct_Interrupt_Size from structs.s; repeated here for clarity. */
enum
{
    Struct_Interrupt_Size = 22
};
