#include "esq_types.h"

extern u8 Global_STR_SCRIPT_C_2;

void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const void *tag_name, s32 width, void *ptr, s32 size) __attribute__((noinline));

void SCRIPT_DeallocateBufferArray(void **out_ptrs, s16 byte_size, s16 count) __attribute__((noinline, used));

void SCRIPT_DeallocateBufferArray(void **out_ptrs, s16 byte_size, s16 count)
{
    s16 i;
    for (i = 0; i < count; ++i) {
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_SCRIPT_C_2, 405, out_ptrs[(s32)i], (s32)byte_size);
        out_ptrs[(s32)i] = (void *)0;
    }
}
