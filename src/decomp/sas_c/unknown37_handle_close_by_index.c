typedef signed long LONG;

typedef struct {
    LONG Flags;
    LONG Handle;
} HandleEntry;

extern LONG Global_DosIoErr;

extern HandleEntry *HANDLE_GetEntryByIndex(LONG handleIndex);
extern LONG DOS_CloseWithSignalCheck(LONG handle);

LONG HANDLE_CloseByIndex(LONG handleIndex)
{
    HandleEntry *entry;

    entry = HANDLE_GetEntryByIndex(handleIndex);
    if (entry == (HandleEntry *)0) {
        return -1;
    }

    if ((((unsigned char *)entry)[3] & (1u << 4)) != 0) {
        entry->Flags = 0;
        return 0;
    }

    DOS_CloseWithSignalCheck(entry->Handle);
    entry->Flags = 0;
    if (Global_DosIoErr != 0) {
        return -1;
    }

    return 0;
}
