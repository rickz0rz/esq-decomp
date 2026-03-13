typedef unsigned char UBYTE;
typedef long LONG;

enum {
    ESQFUNC_NULL = 0,
    ESQFUNC_PW_BRUSH_DESCRIPTOR_COUNT = 6,
    ESQFUNC_PW_BRUSH_TYPE_PRIMARY = 8,
    ESQFUNC_PW_BRUSH_TYPE_SECONDARY = 9,
    ESQFUNC_BRUSH_NODE_TYPE_OFFSET = 190
};

typedef struct ESQFUNC_BrushNode {
    UBYTE pad0[ESQFUNC_BRUSH_NODE_TYPE_OFFSET];
    UBYTE type190;
} ESQFUNC_BrushNode;

extern void *ESQFUNC_PwBrushDescriptorHead;
extern void *ESQFUNC_PwBrushListHead;
extern const char *ESQFUNC_BrushDescriptorTagStrings[];

extern void BRUSH_FreeBrushList(void **headPtr, LONG freeAll);
extern void *BRUSH_AllocBrushNode(const char *brushLabel, void *prevTail);
extern void BRUSH_PopulateBrushList(void *descriptorList, void **outHeadPtr);

void ESQFUNC_RebuildPwBrushListFromTagTable(void)
{
    LONG descriptorIndex;
    ESQFUNC_BrushNode *descriptorTail;

    descriptorTail = (ESQFUNC_BrushNode *)ESQFUNC_NULL;
    BRUSH_FreeBrushList(&ESQFUNC_PwBrushListHead, ESQFUNC_NULL);

    for (descriptorIndex = 0; descriptorIndex < ESQFUNC_PW_BRUSH_DESCRIPTOR_COUNT; ++descriptorIndex) {
        descriptorTail = (ESQFUNC_BrushNode *)BRUSH_AllocBrushNode(
            ESQFUNC_BrushDescriptorTagStrings[descriptorIndex],
            descriptorTail
        );

        if (descriptorIndex == 0) {
            descriptorTail->type190 = ESQFUNC_PW_BRUSH_TYPE_PRIMARY;
        } else {
            descriptorTail->type190 = ESQFUNC_PW_BRUSH_TYPE_SECONDARY;
        }

        if (ESQFUNC_PwBrushDescriptorHead == (void *)ESQFUNC_NULL) {
            ESQFUNC_PwBrushDescriptorHead = (void *)descriptorTail;
        }
    }

    BRUSH_PopulateBrushList(ESQFUNC_PwBrushDescriptorHead, &ESQFUNC_PwBrushListHead);
    ESQFUNC_PwBrushDescriptorHead = (void *)ESQFUNC_NULL;
}
