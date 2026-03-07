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

void BRUSH_PopulateBrushList(void *descriptor, void **out_head_ptr)
{
    UBYTE *cur;
    UBYTE *tail;

    (void)AbsExecBase;
    _LVOForbid();
    BRUSH_LoadInProgressFlag = BRUSH_TRUE;
    _LVOPermit();

    *out_head_ptr = (void *)BRUSH_NULL;
    tail = (UBYTE *)BRUSH_NULL;
    cur = (UBYTE *)descriptor;
    while (cur != (UBYTE *)BRUSH_NULL) {
        UBYTE *next_desc;
        void *loaded;

        loaded = BRUSH_LoadBrushAsset((void *)cur);
        next_desc = *(UBYTE **)(cur + BRUSH_DESCRIPTOR_NEXT_OFFSET);
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_BRUSH_C_8,
            BRUSH_DESC_FREE_LINE,
            (void *)cur,
            BRUSH_DESCRIPTOR_NODE_SIZE
        );
        cur = next_desc;

        if (loaded == (void *)BRUSH_NULL) {
            continue;
        }

        if (*out_head_ptr == (void *)BRUSH_NULL) {
            *out_head_ptr = loaded;
        } else {
            *(void **)(tail + BRUSH_NODE_NEXT_OFFSET) = loaded;
        }
        tail = (UBYTE *)loaded;
    }

    PARSEINI_ParsedDescriptorListHead = (void *)BRUSH_NULL;
    BRUSH_NormalizeBrushNames(out_head_ptr);

    _LVOForbid();
    BRUSH_LoadInProgressFlag = BRUSH_FALSE;
    _LVOPermit();
}
