/* RESTORES: _HANDLE_OpenEntryWithFlags
 * MODULE:   modules/submodules/unknown10_handle_openentrywithflags.s
 * STATUS:   behavioural
 *
 * SAS/C library code: the slot allocator and DOS open behind fopen. It finds a
 * free handle-table slot, opens the file in whichever way the flags call for,
 * and records the result. It returns the SLOT INDEX, or -1.
 *
 * THE STORED FLAG IS `flags + 1`, AND THAT IS THE WHOLE REASON A FREE SLOT IS
 * DETECTABLE. `MOVE.L D7,D6 / ADDQ.L #1,D6` before the store, so the value in
 * the table is never zero for a real handle even when the caller's flags are
 * zero -- and zero is what every free-slot test in this layer looks for.
 * Storing the flags unbiased would make a slot opened with flags 0 read as free
 * and be handed out twice.
 *
 * THE SEARCH STARTS AT SLOT 3. Slots 0, 1 and 2 are the standard streams, which
 * are borrowed rather than opened -- see the bit-4 "do not close" test in
 * HANDLE_CloseByIndex.
 *
 * RUNNING OUT OF SLOTS IS ERROR 24 AND A BAD ACCESS MODE IS ERROR 22, both
 * returning -1 without touching the table.
 *
 * THE ACCESS BITS ARE NORMALISED BEFORE THEY ARE VALIDATED. Bit 15 is toggled
 * against Global_HandleTableFlags -- a global buffering default -- and if bit 3
 * is set the low two bits are forced to 2. Only then are the low two bits
 * checked, and only 0, 1 and 2 are accepted.
 *
 * THERE ARE FOUR WAYS IT CAN OPEN, and the order matters:
 *
 *   no 0x300 bits      a plain MODE_READWRITE open
 *   bit 10 set         open-if-missing, and mark the file as recreated
 *   bit 9 clear        try a plain open first, and SET bit 9 if that failed
 *   bit 9 set (or now  delete and recreate, restoring the saved error code
 *   set by the above)  first so the failed attempt does not leak its errno
 *
 * THE SAVED ERROR CODE IS RESTORED BEFORE THE RECREATE, not after. The original
 * copies Global_AppErrorCode into a local on entry and writes it back at that
 * one point, so a failed probing open leaves no trace.
 *
 * A RECREATED FILE IS REOPENED IF ANY OF BITS 4..7 IS SET. `MOVEQ #120,D1 /
 * ADD.L D1,D1` is 240, not 120 -- reading the MOVEQ alone halves the mask. The
 * file is closed and reopened read/write so the caller gets a handle with the
 * access it asked for rather than the create mode.
 *
 * THE FINAL TEST IS ON Global_DosIoErr, NOT ON THE HANDLE. A negative handle
 * with the global clear still stores.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     LEA Global_HandleTableBase(A4),A0
 *   got:     an absolute address through the enclosing array
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-neardata.h"

#ifndef ESQ_HANDLEENTRY_DEFINED
#define ESQ_HANDLEENTRY_DEFINED
struct HandleEntry {
    long  flags;        /* +0, stored as the caller's flags PLUS ONE */
    long  fh;           /* +4 */
};
#endif

extern long DOS_OpenWithErrorState(char *name, long mode);
extern long DOS_OpenNewFileIfMissing(char *name);
extern long DOS_DeleteAndRecreateFile(char *name);
extern long DOS_CloseWithSignalCheck(long fh);

long HANDLE_OpenEntryWithFlags(char *path, long flags, long extra)
{
    struct HandleEntry *table =
        (struct HandleEntry *)Global_HandleTableBase_A4_ADDR;
    long savedError;
    long slot;
    long fh = 0;
    long recreated = 0;

    Global_DosIoErr_A4 = 0;
    savedError = Global_AppErrorCode_A4;

    for (slot = 3; slot < Global_HandleTableCount_A4; slot++) {
        if (table[slot].flags == 0)
            break;
    }
    if (slot == Global_HandleTableCount_A4) {
        Global_AppErrorCode_A4 = 24;        /* no free slot */
        return -1;
    }

    /* MODE_OLDFILE unless `extra` is non-zero with bit 2 clear. */
    {
        long createMode = (extra == 0 || (extra & 4)) ? 1004L : 1006L;

        /* Normalise before validating. */
        flags ^= (0x8000L & Global_HandleTableFlags_A4);
        if (flags & 8)
            flags = (flags & ~3L) | 2L;

        {
            long access = flags & 3;

            if (access != 0 && access != 1 && access != 2) {
                Global_AppErrorCode_A4 = 22;
                return -1;
            }
        }

        if ((flags & 0x300) == 0) {
            fh = DOS_OpenWithErrorState(path, 1005L);
        } else if (flags & 0x400) {
            recreated = 1;
            fh = DOS_OpenNewFileIfMissing(path);
        } else {
            if (!(flags & 0x200)) {
                fh = DOS_OpenWithErrorState(path, 1005L);
                if (fh < 0)
                    flags |= 0x200;         /* fall through to recreate */
            }
            if (flags & 0x200) {
                recreated = 1;
                Global_AppErrorCode_A4 = savedError;  /* BEFORE the recreate */
                fh = DOS_DeleteAndRecreateFile(path);
            }
        }
        (void)createMode;   /* the callees hardcode their own mode -- see header */
    }

    /* 240, not 120: MOVEQ #120 then ADD.L D1,D1. */
    if (recreated && (flags & 240) != 0 && fh >= 0) {
        DOS_CloseWithSignalCheck(fh);
        fh = DOS_OpenWithErrorState(path, 1005L);
    }

    if (Global_DosIoErr_A4 != 0)
        return -1;

    table[slot].flags = flags + 1;          /* PLUS ONE -- see the header */
    table[slot].fh = fh;

    return slot;
}
