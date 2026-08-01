/* RESTORES: HANDLE_CloseByIndex
 * MODULE:   modules/submodules/unknown37.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Releases a handle-table slot, closing the underlying file
 * unless the entry is marked as borrowed.
 *
 * BIT 4 OF THE FLAGS MEANS "DO NOT CLOSE". `BTST #4,3(A3)` tests the low byte of
 * the flags long, so it is `flags & 0x10`. When it is set the slot is cleared
 * and the function returns WITHOUT calling Close -- that is how the standard
 * input and output handles are released without closing the console. Closing
 * them anyway would take the shell's own streams down with the program.
 *
 * THE SLOT IS CLEARED ON BOTH PATHS, and on the closing path it is cleared
 * BEFORE the io-error test, so a failed close still frees the slot.
 *
 * THE RETURN VALUE IS 0 OR -1, and the borrowed path returns whatever the flags
 * test left in D0 -- which the original sets to 0 explicitly just before
 * returning. Both success paths are therefore 0.
 */
#include "esq-neardata.h"
#ifndef ESQ_HANDLEENTRY_DEFINED
#define ESQ_HANDLEENTRY_DEFINED
/* src/structs.s: Struct_HandleEntry_Size = 8, Struct_HandleEntry__Flags = 0.
 * The original tests flag bits with `BTST #n,3(An)` -- the LOW byte of the flags
 * long -- so bit n there is `flags & (1 << n)`. */
struct HandleEntry {
    long  flags;        /* +0 */
    long  fh;           /* +4, the DOS file handle */
};
#endif

extern struct HandleEntry *HANDLE_GetEntryByIndex(long index);
extern void DOS_CloseWithSignalCheck(long fh);

long HANDLE_CloseByIndex(long index)
{
    struct HandleEntry *e = HANDLE_GetEntryByIndex(index);

    if (e == 0)
        return -1;

    if (e->flags & 0x10) {                  /* borrowed: release, do not close */
        e->flags = 0;
        return 0;
    }

    DOS_CloseWithSignalCheck(e->fh);
    e->flags = 0;

    if (Global_DosIoErr_A4 != 0)
        return -1;

    return 0;
}
