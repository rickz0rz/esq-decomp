/* RESTORES: DOS_ReadByIndex, LIST_InitHeader, _MEM_Move
 * MODULE:   modules/submodules/unknown34.s
 * STATUS:   behavioural
 *
 * SAS/C library code: a read through a handle index, exec's NewList, and memmove.
 * Three unrelated functions that happen to share a module.
 *
 * DOS_ReadByIndex is the twin of DOS_WriteByIndex without the append seek. It
 * returns -1 for an invalid index AND for an io error, with the byte count
 * captured before the error test.
 *
 * LIST_InitHeader IS NewList, and the pointer arithmetic is the whole of it:
 *
 *     lh_Head     = &lh_Tail       (list+0 = list+4)
 *     lh_Tail     = 0
 *     lh_TailPred = &lh_Head       (list+8 = list+0)
 *
 * The original writes lh_Head by storing the list pointer and then adding 4 to
 * the stored value in place, which is the same address by a different route.
 *
 * _MEM_Move IS memmove AND ITS ARGUMENTS ARE SOURCE FIRST. `MOVE.B (A0)+,(A1)+`
 * copies A0 to A1, and A0 comes from 4(A7). Reading it as memcpy's (dst, src)
 * order copies backwards.
 *
 * IT CHOOSES THE DIRECTION FROM AN UNSIGNED COMPARE. `CMPA.L A0,A1 / BCS` takes
 * the forward loop when the destination is BELOW the source, and copies from the
 * top down otherwise. That is what makes it memmove rather than memcpy, and
 * getting the comparison backwards corrupts exactly the overlapping case it
 * exists to handle.
 *
 * A NON-POSITIVE LENGTH COPIES NOTHING. `BLE` is a SIGNED test, so a negative
 * length is a no-op rather than four billion bytes.
 *
 * IT IS WRITTEN OUT RATHER THAN CALLING memmove, which is a real call into
 * sc.lib and this build does not link sc.lib.
 */
#include "esq-neardata.h"

#ifndef ESQ_HANDLEENTRY_DEFINED
#define ESQ_HANDLEENTRY_DEFINED
struct HandleEntry {
    long  flags;        /* +0 */
    long  fh;           /* +4 */
};
#endif

extern struct HandleEntry *HANDLE_GetEntryByIndex(long index);
extern long DOS_ReadWithErrorState(long fh, char *buf, long len);

long DOS_ReadByIndex(long index, char *buf, long len)
{
    struct HandleEntry *e = HANDLE_GetEntryByIndex(index);
    long n;

    if (e == 0)
        return -1;

    n = DOS_ReadWithErrorState(e->fh, buf, len);

    if (Global_DosIoErr_A4 != 0)
        return -1;

    return n;
}

void LIST_InitHeader(long *list)
{
    list[0] = (long)&list[1];       /* lh_Head     = &lh_Tail     */
    list[1] = 0;                    /* lh_Tail     = 0            */
    list[2] = (long)&list[0];       /* lh_TailPred = &lh_Head     */
}

void MEM_Move(char *src, char *dst, long n)
{
    if (n <= 0)
        return;

    if ((unsigned long)dst < (unsigned long)src) {
        do {
            *dst++ = *src++;
        } while (--n != 0);
    } else {
        src += n;
        dst += n;
        do {
            *--dst = *--src;
        } while (--n != 0);
    }
}
