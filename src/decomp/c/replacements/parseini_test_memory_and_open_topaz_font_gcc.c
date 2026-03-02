#include "esq_types.h"

extern void *Global_HANDLE_TOPAZ_FONT;
extern s32 DesiredMemoryAvailability;

void _LVOCloseFont(void *font) __attribute__((noinline));
void _LVOForbid(void) __attribute__((noinline));
void *_LVOAllocMem(s32 bytes, s32 flags) __attribute__((noinline));
void _LVOFreeMem(void *mem, s32 bytes) __attribute__((noinline));
void _LVOPermit(void) __attribute__((noinline));
void *_LVOOpenDiskFont(void *text_attr) __attribute__((noinline));

s32 PARSEINI_TestMemoryAndOpenTopazFont(void **slot, void *text_attr) __attribute__((noinline, used));

s32 PARSEINI_TestMemoryAndOpenTopazFont(void **slot, void *text_attr)
{
    s32 status = 0;
    void *mem;

    if (*slot == 0) {
        return status;
    }

    if (*slot != Global_HANDLE_TOPAZ_FONT) {
        _LVOCloseFont(*slot);
    }

    _LVOForbid();
    mem = _LVOAllocMem(DesiredMemoryAvailability, 1);
    if (mem != 0) {
        _LVOFreeMem(mem, DesiredMemoryAvailability);
    }
    _LVOPermit();

    *slot = _LVOOpenDiskFont(text_attr);
    if (*slot == 0) {
        *slot = Global_HANDLE_TOPAZ_FONT;
    } else {
        status = 1;
    }

    return status;
}
