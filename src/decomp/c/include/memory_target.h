#ifndef MEMORY_TARGET_H
#define MEMORY_TARGET_H

#include "esq_types.h"

/*
 * Minimal declarations for target 002 C equivalence trials.
 * Keep symbol names aligned with assembly labels.
 */
extern u32 Global_MEM_BYTES_ALLOCATED;
extern u32 Global_MEM_ALLOC_COUNT;
extern u32 Global_MEM_DEALLOC_COUNT;

/*
 * Amiga ExecBase is stored at absolute address 4 (AbsExecBase in assembly).
 */
#define AbsExecBasePtr (*(void * volatile *)4)

/*
 * vbcc-style inline library call for exec AllocMem (LVO -198).
 * Parameters are forced into A6/D0/D1 to mirror assembly call ABI.
 */
void *DECOMP_AllocMem_Exec(
    __reg("a6") void *exec_base,
    __reg("d0") u32 byte_size,
    __reg("d1") u32 attributes) = "\tjsr\t-198(a6)";

#endif
