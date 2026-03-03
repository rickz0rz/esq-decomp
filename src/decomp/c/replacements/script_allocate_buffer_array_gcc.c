#include "esq_types.h"

extern u8 Global_STR_SCRIPT_C_1;

void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(const void *tag_name, s32 width, s32 height, s32 flags) __attribute__((noinline));

void SCRIPT_AllocateBufferArray(void **out_ptrs, s16 byte_size, s16 count) __attribute__((noinline, used));

void SCRIPT_AllocateBufferArray(void **out_ptrs, s16 byte_size, s16 count)
{
    s16 i;
    for (i = 0; i < count; ++i) {
        out_ptrs[(s32)i] = SCRIPT_JMPTBL_MEMORY_AllocateMemory(&Global_STR_SCRIPT_C_1, 394, (s32)byte_size, 0x10001);
    }
}
