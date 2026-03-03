#include "esq_types.h"

/*
 * Target 701 GCC trial function.
 * Convert descriptor list into loaded brush list, normalize names, and toggle load-in-progress flag.
 */
extern void *AbsExecBase;
extern u8 Global_STR_BRUSH_C_8[];
extern s32 BRUSH_LoadInProgressFlag;
extern void *PARSEINI_ParsedDescriptorListHead;

void _LVOForbid(void) __attribute__((noinline));
void _LVOPermit(void) __attribute__((noinline));
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, s32 line, void *ptr, s32 bytes) __attribute__((noinline));
void *BRUSH_LoadBrushAsset(void *descriptor) __attribute__((noinline));
void BRUSH_NormalizeBrushNames(void **head_ptr) __attribute__((noinline));

void BRUSH_PopulateBrushList(void *descriptor, void **out_head_ptr) __attribute__((noinline, used));

void BRUSH_PopulateBrushList(void *descriptor, void **out_head_ptr)
{
    u8 *cur;
    u8 *tail;

    (void)AbsExecBase;
    _LVOForbid();
    BRUSH_LoadInProgressFlag = 1;
    _LVOPermit();

    *out_head_ptr = 0;
    tail = 0;
    cur = (u8 *)descriptor;
    while (cur != 0) {
        u8 *next_desc;
        void *loaded;

        loaded = BRUSH_LoadBrushAsset(cur);
        next_desc = *(u8 **)(cur + 234);
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_8, 845, cur, 238);
        cur = next_desc;

        if (loaded == 0) {
            continue;
        }

        if (*out_head_ptr == 0) {
            *out_head_ptr = loaded;
        } else {
            *(void **)(tail + 368) = loaded;
        }
        tail = (u8 *)loaded;
    }

    PARSEINI_ParsedDescriptorListHead = 0;
    BRUSH_NormalizeBrushNames(out_head_ptr);

    _LVOForbid();
    BRUSH_LoadInProgressFlag = 0;
    _LVOPermit();
}
