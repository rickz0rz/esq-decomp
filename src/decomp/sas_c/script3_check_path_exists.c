#include <exec/types.h>
extern void *Global_REF_DOS_LIBRARY_2;
extern LONG _LVOLock(void *dosBase, const char *path, LONG mode);
extern void _LVOUnLock(void *dosBase, LONG lockHandle);

LONG SCRIPT_CheckPathExists(const char *path)
{
    LONG lockHandle;

    lockHandle = _LVOLock(Global_REF_DOS_LIBRARY_2, path, -2);
    if (lockHandle == 0) {
        return 0;
    }

    _LVOUnLock(Global_REF_DOS_LIBRARY_2, lockHandle);
    return 1;
}
