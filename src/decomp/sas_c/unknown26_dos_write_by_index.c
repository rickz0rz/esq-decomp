#include <exec/types.h>
extern LONG Global_DosIoErr;

extern void *HANDLE_GetEntryByIndex(LONG handleIndex);
extern LONG DOS_SeekByIndex(LONG handleIndex, LONG offset, LONG mode);
extern LONG DOS_WriteWithErrorState(LONG fileHandle, void *buffer, LONG length);

LONG DOS_WriteByIndex(LONG handleIndex, void *buffer, LONG length)
{
    LONG bytesWritten;
    LONG *entry;
    UBYTE *entryBytes;

    entry = (LONG *)HANDLE_GetEntryByIndex(handleIndex);
    if (entry == 0) {
        return -1;
    }

    entryBytes = (UBYTE *)entry;
    if ((entryBytes[3] & 0x08) != 0) {
        DOS_SeekByIndex(handleIndex, 0, 2);
    }

    bytesWritten = DOS_WriteWithErrorState(entry[1], buffer, length);
    if (Global_DosIoErr != 0) {
        return -1;
    }

    return bytesWritten;
}
