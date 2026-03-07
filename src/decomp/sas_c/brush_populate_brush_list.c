typedef unsigned char UBYTE;
typedef long LONG;

enum {
    BRUSH_DESCRIPTOR_NEXT_OFFSET = 234,
    BRUSH_DESCRIPTOR_NODE_SIZE = 238,
    BRUSH_NODE_NEXT_OFFSET = 368
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
    BRUSH_LoadInProgressFlag = 1;
    _LVOPermit();

    *out_head_ptr = (void *)0;
    tail = (UBYTE *)0;
    cur = (UBYTE *)descriptor;
    while (cur != (UBYTE *)0) {
        UBYTE *next_desc;
        void *loaded;

        loaded = BRUSH_LoadBrushAsset((void *)cur);
        next_desc = *(UBYTE **)(cur + BRUSH_DESCRIPTOR_NEXT_OFFSET);
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_BRUSH_C_8,
            845,
            (void *)cur,
            BRUSH_DESCRIPTOR_NODE_SIZE
        );
        cur = next_desc;

        if (loaded == (void *)0) {
            continue;
        }

        if (*out_head_ptr == (void *)0) {
            *out_head_ptr = loaded;
        } else {
            *(void **)(tail + BRUSH_NODE_NEXT_OFFSET) = loaded;
        }
        tail = (UBYTE *)loaded;
    }

    PARSEINI_ParsedDescriptorListHead = (void *)0;
    BRUSH_NormalizeBrushNames(out_head_ptr);

    _LVOForbid();
    BRUSH_LoadInProgressFlag = 0;
    _LVOPermit();
}
