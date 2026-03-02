#include "esq_types.h"

/*
 * Target 599 GCC trial function.
 * Allocate a free handle-table entry and open backing DOS handle per mode bits.
 */
extern u32 Global_HandleTableCount;
extern u8 Global_HandleTableBase[];
extern u32 Global_HandleTableFlags;
extern u32 Global_AppErrorCode;
extern u32 Global_DosIoErr;

s32 DOS_OpenWithErrorState(const u8 *name, s32 mode) __attribute__((noinline));
s32 DOS_OpenNewFileIfMissing(const u8 *name, s32 err_code) __attribute__((noinline));
s32 DOS_DeleteAndRecreateFile(const u8 *name, s32 err_code) __attribute__((noinline));
s32 DOS_CloseWithSignalCheck(s32 handle) __attribute__((noinline));

s32 HANDLE_OpenEntryWithFlags(const u8 *name, u32 flags, s32 aux)
    __attribute__((noinline, used));

s32 HANDLE_OpenEntryWithFlags(const u8 *name, u32 flags, s32 aux)
{
    s32 slot = 3;
    s32 open_handle;
    s32 create_err_code;
    u32 mode_bits;
    u8 did_create_path = 0;
    u32 old_app_error = Global_AppErrorCode;

    Global_DosIoErr = 0;

    while ((u32)slot < Global_HandleTableCount) {
        u8 *entry = Global_HandleTableBase + ((u32)slot << 3);
        if (*(u32 *)(entry + 0) == 0) {
            break;
        }
        slot++;
    }

    if ((u32)slot == Global_HandleTableCount) {
        Global_AppErrorCode = 24;
        return -1;
    }

    if (aux != 0 || ((flags >> 2) & 1u) == 0u) {
        create_err_code = 0x3ec;
    } else {
        create_err_code = 0x3ee;
    }

    flags ^= (Global_HandleTableFlags & 0x8000u);

    if ((flags & (1u << 3)) != 0u) {
        flags = (flags & ~3u) | 2u;
    }

    mode_bits = flags & 3u;
    if (mode_bits != 0u && mode_bits != 1u && mode_bits != 2u) {
        Global_AppErrorCode = 22;
        return -1;
    }

    mode_bits = flags + 1u;

    if ((flags & 0x300u) != 0u) {
        if ((flags & (1u << 10)) != 0u) {
            did_create_path = 1;
            open_handle = DOS_OpenNewFileIfMissing(name, create_err_code);
        } else {
            if ((flags & (1u << 9)) == 0u) {
                open_handle = DOS_OpenWithErrorState(name, 1005);
                if (open_handle < 0) {
                    flags |= (1u << 9);
                }
            }

            if ((flags & (1u << 9)) != 0u) {
                did_create_path = 1;
                Global_AppErrorCode = old_app_error;
                open_handle = DOS_DeleteAndRecreateFile(name, create_err_code);
            }
        }

        if (did_create_path != 0 && (flags & 240u) != 0u && open_handle >= 0) {
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
        u8 *entry = Global_HandleTableBase + ((u32)slot << 3);
        *(u32 *)(entry + 0) = mode_bits;
        *(s32 *)(entry + 4) = open_handle;
    }

    return slot;
}
