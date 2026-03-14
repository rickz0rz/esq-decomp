#include <exec/types.h>
extern LONG Global_DosIoErr;

extern void *HANDLE_GetEntryByIndex(LONG handleIndex);
extern LONG DOS_SeekWithErrorState(LONG fileHandle, LONG offset, LONG mode);

LONG DOS_SeekByIndex(LONG handleIndex, LONG offset, LONG mode)
{
    LONG seekResult;
    LONG *entry;

    entry = (LONG *)HANDLE_GetEntryByIndex(handleIndex);
    if (entry == 0) {
        return -1;
    }

    seekResult = DOS_SeekWithErrorState(entry[1], offset, mode);
    if (Global_DosIoErr != 0) {
        return -1;
    }

    return seekResult;
}
