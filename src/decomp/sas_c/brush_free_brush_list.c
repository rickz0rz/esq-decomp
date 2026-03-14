#include <exec/types.h>

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

extern const char Global_STR_BRUSH_C_5[];
extern const char Global_STR_BRUSH_C_6[];
extern const char Global_STR_BRUSH_C_7[];

void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(const char *tag, LONG line, void *raster, LONG width, LONG height);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *tag, LONG line, void *ptr, LONG bytes);

typedef struct BRUSH_AuxNode {
    UBYTE pad0[BRUSH_AUX_NEXT_OFFSET];
    struct BRUSH_AuxNode *next;
} BRUSH_AuxNode;

typedef struct BRUSH_Node {
    UBYTE pad0[BRUSH_NODE_RASTER_TABLE_OFFSET];
    void *rasterTable[8];
    UWORD width176;
    UWORD height178;
    UBYTE pad180[4];
    UBYTE frameCount184;
    UBYTE pad185[179];
    BRUSH_AuxNode *auxList364;
    struct BRUSH_Node *next368;
} BRUSH_Node;

void BRUSH_FreeBrushList(void **headPtr, LONG freeAll)
{
    BRUSH_Node *node;

    node = (BRUSH_Node *)*headPtr;
    while (node != (BRUSH_Node *)BRUSH_FALSE) {
        LONG frameIndex;
        BRUSH_Node *nextNode;
        BRUSH_AuxNode *auxNode;

        nextNode = node->next368;
        frameIndex = BRUSH_FALSE;
        while (frameIndex < (LONG)node->frameCount184) {
            void *raster;
            LONG width;
            LONG height;

            raster = node->rasterTable[frameIndex];
            width = (LONG)node->width176;
            height = (LONG)node->height178;
            GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(Global_STR_BRUSH_C_5, BRUSH_FREE_RASTER_LINE, raster, width, height);
            frameIndex++;
        }

        auxNode = node->auxList364;
        while (auxNode != (BRUSH_AuxNode *)BRUSH_FALSE) {
            BRUSH_AuxNode *nextAuxNode;

            nextAuxNode = auxNode->next;
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
