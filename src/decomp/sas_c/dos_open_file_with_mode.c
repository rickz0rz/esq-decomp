#include <exec/types.h>
extern void *Global_REF_DOS_LIBRARY_2;
extern LONG _LVOOpen(void *dosBase, const char *name, LONG mode);

LONG DOS_OpenFileWithMode(const char *name, LONG mode)
{
    return _LVOOpen(Global_REF_DOS_LIBRARY_2, name, mode);
}
