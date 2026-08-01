/* RESTORES: DOS_WriteByIndex
 * MODULE:   modules/submodules/unknown26.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Writes through a handle INDEX rather than a file handle.
 *
 * IT SEEKS TO THE END FIRST IF BIT 3 OF THE FLAGS IS SET. That is the append
 * mode: `BTST #3,3(A2)` tests the LOW BYTE of the flags long, so it is
 * `flags & 8`, and the seek is `DOS_SeekByIndex(index, 0, 2)`. Dropping it would
 * make every append-mode write land at the current position instead.
 *
 * THE SEEK'S RESULT IS DISCARDED and its failure is not checked here -- the
 * following write's own io-error test is what catches a broken handle.
 *
 * IT RETURNS -1 FOR AN INVALID INDEX AND FOR AN IO ERROR, with the byte count
 * captured before the error test, exactly as DOS_SeekByIndex does.
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
extern long DOS_SeekByIndex(long index, long pos, long mode);
extern long DOS_WriteWithErrorState(long fh, char *buf, long len);

long DOS_WriteByIndex(long index, char *buf, long len)
{
    struct HandleEntry *e = HANDLE_GetEntryByIndex(index);
    long written;

    if (e == 0)
        return -1;

    if (e->flags & 8)                       /* append mode: seek to the end */
        DOS_SeekByIndex(index, 0, 2);

    written = DOS_WriteWithErrorState(e->fh, buf, len);

    if (Global_DosIoErr_A4 != 0)
        return -1;

    return written;
}
