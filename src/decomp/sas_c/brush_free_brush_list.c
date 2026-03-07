typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef long LONG;

enum {
    BRUSH_FALSE = 0,
    BRUSH_FREE_ALL_ENABLED = 1,
    BRUSH_NODE_FRAME_COUNT_OFFSET = 184,
    BRUSH_NODE_WIDTH_OFFSET = 176,
    BRUSH_NODE_HEIGHT_OFFSET = 178,
    BRUSH_NODE_RASTER_TABLE_OFFSET = 0x90,
    BRUSH_NODE_AUX_LIST_OFFSET = 364,
    BRUSH_NODE_NEXT_OFFSET = 368,
    BRUSH_NODE_SIZE = 372,
    BRUSH_AUX_NEXT_OFFSET = 8,
    BRUSH_AUX_NODE_SIZE = 12
};

extern const UBYTE Global_STR_BRUSH_C_5[];
extern const UBYTE Global_STR_BRUSH_C_6[];
extern const UBYTE Global_STR_BRUSH_C_7[];

void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(const void *tag, LONG line, void *raster, LONG width, LONG height);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);

void BRUSH_FreeBrushList(void **head_ptr, LONG free_all)
{
    UBYTE *node;

    node = (UBYTE *)*head_ptr;
    while (node != (UBYTE *)BRUSH_FALSE) {
        LONG i;
        UBYTE *next;
        UBYTE *aux;

        next = *(UBYTE **)(node + BRUSH_NODE_NEXT_OFFSET);
        i = BRUSH_FALSE;
        while (i < (LONG)*(UBYTE *)(node + BRUSH_NODE_FRAME_COUNT_OFFSET)) {
            void *raster;
            LONG width;
            LONG height;

            raster = *(void **)(node + BRUSH_NODE_RASTER_TABLE_OFFSET + ((ULONG)i << 2));
            width = (LONG)*(UWORD *)(node + BRUSH_NODE_WIDTH_OFFSET);
            height = (LONG)*(UWORD *)(node + BRUSH_NODE_HEIGHT_OFFSET);
            GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(Global_STR_BRUSH_C_5, 549, raster, width, height);
            i++;
        }

        aux = *(UBYTE **)(node + BRUSH_NODE_AUX_LIST_OFFSET);
        while (aux != (UBYTE *)BRUSH_FALSE) {
            UBYTE *aux_next;

            aux_next = *(UBYTE **)(aux + BRUSH_AUX_NEXT_OFFSET);
            GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_6, 561, (void *)aux, BRUSH_AUX_NODE_SIZE);
            aux = aux_next;
        }

        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_7, 567, (void *)node, BRUSH_NODE_SIZE);
        node = next;
        if (free_all != BRUSH_FREE_ALL_ENABLED) {
            break;
        }
    }

    *head_ptr = (void *)node;
}
