typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef long LONG;

enum {
    BRUSH_FALSE = 0,
    BRUSH_FREE_ALL_ENABLED = 1,
    BRUSH_RASTER_PTR_STRIDE_SHIFT = 2,
    BRUSH_NODE_FRAME_COUNT_OFFSET = 184,
    BRUSH_NODE_WIDTH_OFFSET = 176,
    BRUSH_NODE_HEIGHT_OFFSET = 178,
    BRUSH_NODE_RASTER_TABLE_OFFSET = 0x90,
    BRUSH_NODE_AUX_LIST_OFFSET = 364,
    BRUSH_NODE_NEXT_OFFSET = 368,
    BRUSH_NODE_SIZE = 372,
    BRUSH_AUX_NEXT_OFFSET = 8,
    BRUSH_AUX_NODE_SIZE = 12,
    BRUSH_FREE_RASTER_LINE = 549,
    BRUSH_FREE_AUX_LINE = 561,
    BRUSH_FREE_NODE_LINE = 567
};

extern const UBYTE Global_STR_BRUSH_C_5[];
extern const UBYTE Global_STR_BRUSH_C_6[];
extern const UBYTE Global_STR_BRUSH_C_7[];

void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(const void *tag, LONG line, void *raster, LONG width, LONG height);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);

void BRUSH_FreeBrushList(void **headPtr, LONG freeAll)
{
    UBYTE *node;

    node = (UBYTE *)*headPtr;
    while (node != (UBYTE *)BRUSH_FALSE) {
        LONG frameIndex;
        UBYTE *nextNode;
        UBYTE *auxNode;

        nextNode = *(UBYTE **)(node + BRUSH_NODE_NEXT_OFFSET);
        frameIndex = BRUSH_FALSE;
        while (frameIndex < (LONG)*(UBYTE *)(node + BRUSH_NODE_FRAME_COUNT_OFFSET)) {
            void *raster;
            LONG width;
            LONG height;

            raster = *(void **)(node + BRUSH_NODE_RASTER_TABLE_OFFSET + ((ULONG)frameIndex << BRUSH_RASTER_PTR_STRIDE_SHIFT));
            width = (LONG)*(UWORD *)(node + BRUSH_NODE_WIDTH_OFFSET);
            height = (LONG)*(UWORD *)(node + BRUSH_NODE_HEIGHT_OFFSET);
            GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(Global_STR_BRUSH_C_5, BRUSH_FREE_RASTER_LINE, raster, width, height);
            frameIndex++;
        }

        auxNode = *(UBYTE **)(node + BRUSH_NODE_AUX_LIST_OFFSET);
        while (auxNode != (UBYTE *)BRUSH_FALSE) {
            UBYTE *nextAuxNode;

            nextAuxNode = *(UBYTE **)(auxNode + BRUSH_AUX_NEXT_OFFSET);
            GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
                Global_STR_BRUSH_C_6, BRUSH_FREE_AUX_LINE, (void *)auxNode, BRUSH_AUX_NODE_SIZE);
            auxNode = nextAuxNode;
        }

        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_BRUSH_C_7, BRUSH_FREE_NODE_LINE, (void *)node, BRUSH_NODE_SIZE);
        node = nextNode;
        if (freeAll != BRUSH_FREE_ALL_ENABLED) {
            break;
        }
    }

    *headPtr = (void *)node;
}
