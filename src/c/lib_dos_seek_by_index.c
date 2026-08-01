/* RESTORES: DOS_SeekByIndex
 * MODULE:   modules/submodules/unknown11.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Seeks the file behind a handle INDEX rather than a file
 * handle: it looks the index up in the near-data handle table, then delegates.
 *
 * IT RETURNS -1 FOR TWO DIFFERENT FAILURES and the caller cannot tell them
 * apart: an invalid index, and a seek that set Global_DosIoErr. The successful
 * result is the old position that DOS_SeekWithErrorState returned, held in D4
 * across the error test -- so the error test happens AFTER the result is
 * captured, and a seek that legitimately returns -1 is indistinguishable from a
 * failure. That is the original's contract.
 *
 * THE IO-ERROR TEST IS ON THE GLOBAL, NOT THE RETURN VALUE. Reading the return
 * value instead would change which seeks are treated as failures.
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
extern long DOS_SeekWithErrorState(long fh, long pos, long mode);

long DOS_SeekByIndex(long index, long pos, long mode)
{
    struct HandleEntry *e = HANDLE_GetEntryByIndex(index);
    long result;

    if (e == 0)
        return -1;

    result = DOS_SeekWithErrorState(e->fh, pos, mode);

    if (Global_DosIoErr_A4 != 0)
        return -1;

    return result;
}
