#include "esq_types.h"

extern void *Global_REF_DOS_LIBRARY_2;

void *_LVOLock(const char *path, s32 mode) __attribute__((noinline));
void _LVOUnLock(void *lock) __attribute__((noinline));

s32 SCRIPT_CheckPathExists(const char *path) __attribute__((noinline, used));

s32 SCRIPT_CheckPathExists(const char *path)
{
    void *lock = _LVOLock(path, -2);
    if (lock == 0) {
        return 0;
    }
    _LVOUnLock(lock);
    return 1;
}
