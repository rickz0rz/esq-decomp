#include <exec/types.h>
extern void *Global_REF_DOS_LIBRARY_2;
extern WORD DISKIO_Pc1MountAssignFlag;
extern const char DISKIO_CMD_MOUNT_PC1[];
extern const char DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT[];

extern LONG _LVOExecute(void *dosBase, const char *command, LONG in, LONG out);

void DISKIO_EnsurePc1MountedAndGfxAssigned(void)
{
    if (DISKIO_Pc1MountAssignFlag != 0) {
        return;
    }

    DISKIO_Pc1MountAssignFlag = 1;
    _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_MOUNT_PC1, 0, 0);
    _LVOExecute(Global_REF_DOS_LIBRARY_2, DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT, 0, 0);
}
