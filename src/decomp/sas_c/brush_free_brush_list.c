typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef long LONG;

extern UBYTE Global_STR_BRUSH_C_5[];
extern UBYTE Global_STR_BRUSH_C_6[];
extern UBYTE Global_STR_BRUSH_C_7[];

void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(const void *tag, LONG line, void *raster, LONG width, LONG height);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);

void BRUSH_FreeBrushList(void **head_ptr, LONG free_all)
{
    UBYTE *node;

    node = (UBYTE *)*head_ptr;
    while (node != (UBYTE *)0) {
        LONG i;
        UBYTE *next;
        UBYTE *aux;

        next = *(UBYTE **)(node + 368);
        i = 0;
        while (i < (LONG)*(UBYTE *)(node + 184)) {
            void *raster;
            LONG width;
            LONG height;

            raster = *(void **)(node + 0x90 + ((ULONG)i << 2));
            width = (LONG)*(UWORD *)(node + 176);
            height = (LONG)*(UWORD *)(node + 178);
            GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(Global_STR_BRUSH_C_5, 549, raster, width, height);
            i++;
        }

        aux = *(UBYTE **)(node + 364);
        while (aux != (UBYTE *)0) {
            UBYTE *aux_next;

            aux_next = *(UBYTE **)(aux + 8);
            GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_6, 561, (void *)aux, 12);
            aux = aux_next;
        }

        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_7, 567, (void *)node, 372);
        node = next;
        if (free_all != 1) {
            break;
        }
    }

    *head_ptr = (void *)node;
}
