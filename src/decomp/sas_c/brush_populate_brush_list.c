typedef unsigned char UBYTE;
typedef long LONG;

enum {
    BRUSH_FALSE = 0,
    BRUSH_TRUE = 1,
    BRUSH_NULL = 0,
    BRUSH_DESCRIPTOR_NEXT_OFFSET = 234,
    BRUSH_DESCRIPTOR_NODE_SIZE = 238,
    BRUSH_NODE_NEXT_OFFSET = 368,
    BRUSH_DESC_FREE_LINE = 845
};

extern void *AbsExecBase;
extern const UBYTE Global_STR_BRUSH_C_8[];
extern LONG BRUSH_LoadInProgressFlag;
extern void *PARSEINI_ParsedDescriptorListHead;

void _LVOForbid(void);
void _LVOPermit(void);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);
void *BRUSH_LoadBrushAsset(void *descriptor);
void BRUSH_NormalizeBrushNames(void **head_ptr);

void BRUSH_PopulateBrushList(void *descriptorList, void **outHeadPtr)
{
    UBYTE *descriptorCursor;
    UBYTE *listTail;

    (void)AbsExecBase;
    _LVOForbid();
    BRUSH_LoadInProgressFlag = BRUSH_TRUE;
    _LVOPermit();

    *outHeadPtr = (void *)BRUSH_NULL;
    listTail = (UBYTE *)BRUSH_NULL;
    descriptorCursor = (UBYTE *)descriptorList;
    while (descriptorCursor != (UBYTE *)BRUSH_NULL) {
        UBYTE *next_desc;
        void *loadedBrush;

        loadedBrush = BRUSH_LoadBrushAsset((void *)descriptorCursor);
        next_desc = *(UBYTE **)(descriptorCursor + BRUSH_DESCRIPTOR_NEXT_OFFSET);
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_BRUSH_C_8,
            BRUSH_DESC_FREE_LINE,
            (void *)descriptorCursor,
            BRUSH_DESCRIPTOR_NODE_SIZE
        );
        descriptorCursor = next_desc;

        if (loadedBrush == (void *)BRUSH_NULL) {
            continue;
        }

        if (*outHeadPtr == (void *)BRUSH_NULL) {
            *outHeadPtr = loadedBrush;
        } else {
            *(void **)(listTail + BRUSH_NODE_NEXT_OFFSET) = loadedBrush;
        }
        listTail = (UBYTE *)loadedBrush;
    }

    PARSEINI_ParsedDescriptorListHead = (void *)BRUSH_NULL;
    BRUSH_NormalizeBrushNames(outHeadPtr);

    _LVOForbid();
    BRUSH_LoadInProgressFlag = BRUSH_FALSE;
    _LVOPermit();
}
