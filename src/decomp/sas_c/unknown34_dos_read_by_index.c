typedef long LONG;
typedef unsigned long ULONG;

extern LONG Global_DosIoErr;

extern void *HANDLE_GetEntryByIndex(LONG handleIndex);
extern LONG DOS_ReadWithErrorState(LONG fileHandle, void *buffer, LONG length);

LONG DOS_ReadByIndex(LONG handleIndex, void *buffer, LONG length)
{
    LONG bytesRead;
    LONG *entry;

    entry = (LONG *)HANDLE_GetEntryByIndex(handleIndex);
    if (entry == 0) {
        return -1;
    }

    bytesRead = DOS_ReadWithErrorState(entry[1], buffer, length);
    if (Global_DosIoErr != 0) {
        return -1;
    }

    return bytesRead;
}
