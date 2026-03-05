typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern ULONG Global_HandleTableCount;
extern UBYTE Global_HandleTableBase[];
extern ULONG Global_HandleTableFlags;
extern ULONG Global_AppErrorCode;
extern ULONG Global_DosIoErr;

extern LONG DOS_OpenWithErrorState(const UBYTE *name, LONG mode);
extern LONG DOS_OpenNewFileIfMissing(const UBYTE *name, LONG err_code);
extern LONG DOS_DeleteAndRecreateFile(const UBYTE *name, LONG err_code);
extern LONG DOS_CloseWithSignalCheck(LONG handle);

LONG HANDLE_OpenEntryWithFlags(const UBYTE *name, ULONG flags, LONG aux)
{
    LONG slot = 3;
    LONG open_handle;
    LONG create_err_code;
    ULONG mode_bits;
    UBYTE did_create_path = 0;
    ULONG old_app_error = Global_AppErrorCode;

    Global_DosIoErr = 0;

    while ((ULONG)slot < Global_HandleTableCount) {
        UBYTE *entry = Global_HandleTableBase + ((ULONG)slot << 3);
        if (*(ULONG *)(entry + 0) == 0) {
            break;
        }
        slot++;
    }

    if ((ULONG)slot == Global_HandleTableCount) {
        Global_AppErrorCode = 24;
        return -1;
    }

    if (aux != 0 || ((flags >> 2) & 1UL) == 0UL) {
        create_err_code = 0x3ec;
    } else {
        create_err_code = 0x3ee;
    }

    flags ^= (Global_HandleTableFlags & 0x8000UL);

    if ((flags & (1UL << 3)) != 0UL) {
        flags = (flags & ~3UL) | 2UL;
    }

    mode_bits = flags & 3UL;
    if (mode_bits != 0UL && mode_bits != 1UL && mode_bits != 2UL) {
        Global_AppErrorCode = 22;
        return -1;
    }

    mode_bits = flags + 1UL;

    if ((flags & 0x300UL) != 0UL) {
        if ((flags & (1UL << 10)) != 0UL) {
            did_create_path = 1;
            open_handle = DOS_OpenNewFileIfMissing(name, create_err_code);
        } else {
            if ((flags & (1UL << 9)) == 0UL) {
                open_handle = DOS_OpenWithErrorState(name, 1005);
                if (open_handle < 0) {
                    flags |= (1UL << 9);
                }
            }

            if ((flags & (1UL << 9)) != 0UL) {
                did_create_path = 1;
                Global_AppErrorCode = old_app_error;
                open_handle = DOS_DeleteAndRecreateFile(name, create_err_code);
            }
        }

        if (did_create_path != 0 && (flags & 240UL) != 0UL && open_handle >= 0) {
            (void)DOS_CloseWithSignalCheck(open_handle);
            open_handle = DOS_OpenWithErrorState(name, 1005);
        }
    } else {
        open_handle = DOS_OpenWithErrorState(name, 1005);
    }

    if (Global_DosIoErr != 0) {
        return -1;
    }

    {
        UBYTE *entry = Global_HandleTableBase + ((ULONG)slot << 3);
        *(ULONG *)(entry + 0) = mode_bits;
        *(LONG *)(entry + 4) = open_handle;
    }

    return slot;
}
