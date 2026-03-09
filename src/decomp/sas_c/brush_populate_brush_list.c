typedef unsigned char UBYTE;
typedef long LONG;

enum {
    BRUSH_FALSE = 0,
    BRUSH_TRUE = 1,
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

typedef struct BRUSH_DescriptorNode {
    UBYTE pad0[BRUSH_DESCRIPTOR_NEXT_OFFSET];
    struct BRUSH_DescriptorNode *next;
} BRUSH_DescriptorNode;

typedef struct BRUSH_Node {
    UBYTE pad0[BRUSH_NODE_NEXT_OFFSET];
    struct BRUSH_Node *next;
} BRUSH_Node;

void BRUSH_PopulateBrushList(void *descriptorList, void **outHeadPtr)
{
    BRUSH_DescriptorNode *descriptorCursor;
    BRUSH_Node *listTail;

    (void)AbsExecBase;
    _LVOForbid();
    BRUSH_LoadInProgressFlag = BRUSH_TRUE;
    _LVOPermit();

    *outHeadPtr = (void *)0;
    listTail = (BRUSH_Node *)0;
    descriptorCursor = (BRUSH_DescriptorNode *)descriptorList;
    while (descriptorCursor != (BRUSH_DescriptorNode *)0) {
        BRUSH_DescriptorNode *next_desc;
        BRUSH_Node *loadedBrush;

        loadedBrush = (BRUSH_Node *)BRUSH_LoadBrushAsset((void *)descriptorCursor);
        next_desc = descriptorCursor->next;
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_BRUSH_C_8,
            BRUSH_DESC_FREE_LINE,
            (void *)descriptorCursor,
            BRUSH_DESCRIPTOR_NODE_SIZE
        );
        descriptorCursor = next_desc;

        if (loadedBrush == (BRUSH_Node *)0) {
            continue;
        }

        if (*outHeadPtr == (void *)0) {
            *outHeadPtr = (void *)loadedBrush;
        } else {
            listTail->next = loadedBrush;
        }
        listTail = loadedBrush;
    }

    PARSEINI_ParsedDescriptorListHead = (void *)0;
    BRUSH_NormalizeBrushNames(outHeadPtr);

    _LVOForbid();
    BRUSH_LoadInProgressFlag = BRUSH_FALSE;
    _LVOPermit();
}
