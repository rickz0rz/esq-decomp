#include "esq_types.h"

/*
 * Target 703 GCC trial function.
 * Allocate/read packed font bytes, expand high nibbles into output, free temp buffer.
 */
extern void *Global_REF_DOS_LIBRARY_2;
extern u8 Global_STR_BRUSH_C_1[];
extern u8 Global_STR_BRUSH_C_2[];
extern u8 Global_STR_BRUSH_C_3[];
extern u8 Global_STR_BRUSH_C_4[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, s32 line, s32 bytes, u32 flags) __attribute__((noinline));
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, s32 line, void *ptr, s32 bytes) __attribute__((noinline));
s32 _LVORead(s32 fh, void *buf, s32 len) __attribute__((noinline));

/* Struct_ColorTextFont_Size in asm */
#define COLOR_TEXT_FONT_SIZE 96

s32 BRUSH_LoadColorTextFont(s32 fh, s32 byte_count, u8 *out_buf) __attribute__((noinline, used));

s32 BRUSH_LoadColorTextFont(s32 fh, s32 byte_count, u8 *out_buf)
{
    u8 *tmp;
    s32 out_i;
    s32 block_i;
    u8 *p;

    (void)Global_REF_DOS_LIBRARY_2;
    tmp = (u8 *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_BRUSH_C_1, 396, COLOR_TEXT_FONT_SIZE, 1);
    if (tmp == 0) {
        return -1;
    }

    if (byte_count > COLOR_TEXT_FONT_SIZE) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_2, 416, tmp, COLOR_TEXT_FONT_SIZE);
        return -1;
    }

    if (_LVORead(fh, tmp, byte_count) != byte_count) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_3, 431, tmp, COLOR_TEXT_FONT_SIZE);
        return -1;
    }

    out_i = 0;
    p = tmp;
    for (block_i = 0; block_i < byte_count; block_i += 3) {
        s32 inner_i;
        for (inner_i = 0; inner_i < 3; inner_i++) {
            out_buf[out_i++] = (u8)((*p >> 4) & 0x0Fu);
            p++;
        }
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_4, 445, tmp, COLOR_TEXT_FONT_SIZE);
    return 1;
}
