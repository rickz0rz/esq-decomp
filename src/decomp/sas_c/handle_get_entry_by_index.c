#include <exec/types.h>
typedef struct {
    LONG Flags;
    LONG Value;
} HandleEntry;

extern LONG Global_DosIoErr;
extern LONG Global_AppErrorCode;
extern LONG Global_HandleTableCount;
extern HandleEntry Global_HandleTableBase[];

HandleEntry *HANDLE_GetEntryByIndex(LONG handleIndex)
{
    Global_DosIoErr = 0;

    if (handleIndex < 0) {
        Global_AppErrorCode = 9;
        return (HandleEntry *)0;
    }

    if (handleIndex >= Global_HandleTableCount) {
        Global_AppErrorCode = 9;
        return (HandleEntry *)0;
    }

    if (Global_HandleTableBase[handleIndex].Flags == 0) {
        Global_AppErrorCode = 9;
        return (HandleEntry *)0;
    }

    return &Global_HandleTableBase[handleIndex];
}
