#include "esq_types.h"

/*
 * Target 697 GCC trial function.
 * Free a brush-node chain; optionally continue through entire list.
 */
extern u8 Global_STR_BRUSH_C_5[];
extern u8 Global_STR_BRUSH_C_6[];
extern u8 Global_STR_BRUSH_C_7[];

void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(const void *tag, s32 line, void *raster, s32 width, s32 height) __attribute__((noinline));
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, s32 line, void *ptr, s32 bytes) __attribute__((noinline));

void BRUSH_FreeBrushList(void **head_ptr, s32 free_all) __attribute__((noinline, used));

void BRUSH_FreeBrushList(void **head_ptr, s32 free_all)
{
    u8 *node;

    node = (u8 *)*head_ptr;
    while (node != 0) {
        s32 i;
        u8 *next;
        u8 *aux;

        next = *(u8 **)(node + 368);
        i = 0;
        while (i < (s32)*(u8 *)(node + 184)) {
            void *raster;
            s32 width;
            s32 height;

            raster = *(void **)(node + 0x90 + ((u32)i << 2));
            width = (s32)*(u16 *)(node + 176);
            height = (s32)*(u16 *)(node + 178);
            GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(Global_STR_BRUSH_C_5, 549, raster, width, height);
            i++;
        }

        aux = *(u8 **)(node + 364);
        while (aux != 0) {
            u8 *aux_next;

            aux_next = *(u8 **)(aux + 8);
            GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_6, 561, aux, 12);
            aux = aux_next;
        }

        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_7, 567, node, 372);
        node = next;
        if (free_all != 1) {
            break;
        }
    }

    *head_ptr = node;
}
