/* RESTORES: IOSTDREQ_Free, IOSTDREQ_CleanupSignalAndMsgport,
 *           DOS_OpenNewFileIfMissing, DOS_DeleteAndRecreateFile
 * MODULE:   modules/submodules/unknown21.s
 * STATUS:   behavioural
 *
 * SAS/C library code: DeleteStdIO, DeletePort, and two ways of creating a file.
 * Four functions, one module, so they move together.
 *
 * THE TWO FREE PATHS POISON BEFORE RELEASING, exactly as STRUCT_FreeWithSizeField
 * does: type byte to 0xFF and the long at +20 to -1, with IOSTDREQ_Free also
 * poisoning +24. `MOVEA.W #$ffff,A0` sign-extends to a full -1, which is why one
 * instruction serves both stores there. These are use-after-free tripwires and
 * they are reproduced.
 *
 * THE SIZES ARE THE LITERALS 48 AND 34 -- IOStdReq and MsgPort -- matching the
 * allocations in lib_allocate_alloc_and_init_iostdreq.c and
 * lib_signal_create_msgport_with_signal.c. FreeMem must be given the size it was
 * allocated with, so these four literals have to agree across the two files.
 *
 * A PORT IS ONLY REMOVED FROM THE PUBLIC LIST IF IT HAS A NAME. `TST.L 10(A3)`
 * is ln_Name, and it mirrors the creator, which only calls AddPort when the port
 * was named. Calling RemPort on a port that was never added corrupts the public
 * list.
 *
 * THE TWO FILE CREATORS DIFFER ONLY IN WHAT THEY DO WHEN THE FILE EXISTS.
 * DOS_DeleteAndRecreateFile deletes it and opens a new one;
 * DOS_OpenNewFileIfMissing unlocks and REFUSES, returning -1.
 *
 * SO -1 IS AMBIGUOUS FROM DOS_OpenNewFileIfMissing. It means both "the file was
 * already there" and "the open failed", and only the second sets
 * Global_DosIoErr. A caller that wants to tell them apart has to check that
 * global, which the function clears on entry for exactly this reason.
 *
 * THE EXISTENCE TEST IS A LOCK, NOT AN OPEN, and the lock is released before
 * either path continues -- so nothing is left holding the file when Open runs.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     CLR.L Global_DosIoErr(A4)
 *   got:     an absolute reference through the enclosing array
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-dos.h"
#include "esq-exec.h"
#include "esq-neardata.h"
#include <exec/io.h>
#include <exec/ports.h>

extern void SIGNAL_PollAndDispatch(void);

#define ACCESS_READ_MODE  (-2L)
#define MODE_NEWFILE_MODE 1006L

void IOSTDREQ_Free(struct IOStdReq *io)
{
    io->io_Message.mn_Node.ln_Type = 0xff;
    *(long *)((char *)io + 20) = -1;
    *(long *)((char *)io + 24) = -1;

    FreeMem((APTR)io, 48L);
}

void IOSTDREQ_CleanupSignalAndMsgport(struct MsgPort *port)
{
    if (port->mp_Node.ln_Name != 0)     /* only if it was published */
        RemPort(port);

    port->mp_Node.ln_Type = 0xff;
    *(long *)((char *)port + 20) = -1;

    FreeSignal((long)port->mp_SigBit);
    FreeMem((APTR)port, 34L);
}

long DOS_OpenNewFileIfMissing(char *name)
{
    long lock, fh;

    if (Global_SignalCallbackPtr_A4 != 0)
        SIGNAL_PollAndDispatch();

    Global_DosIoErr_A4 = 0;

    lock = (long)Lock((STRPTR)name, ACCESS_READ_MODE);
    if (lock != 0) {
        UnLock((BPTR)lock);
        return -1;                      /* it already exists -- see the header */
    }

    fh = (long)Open((STRPTR)name, MODE_NEWFILE_MODE);
    if (fh == 0) {
        Global_DosIoErr_A4 = IoErr();
        Global_AppErrorCode_A4 = 2;
        return -1;
    }

    return fh;
}

long DOS_DeleteAndRecreateFile(char *name)
{
    long lock, fh;

    if (Global_SignalCallbackPtr_A4 != 0)
        SIGNAL_PollAndDispatch();

    Global_DosIoErr_A4 = 0;

    lock = (long)Lock((STRPTR)name, ACCESS_READ_MODE);
    if (lock != 0) {
        UnLock((BPTR)lock);             /* released BEFORE the delete */
        DeleteFile((STRPTR)name);
    }

    fh = (long)Open((STRPTR)name, MODE_NEWFILE_MODE);
    if (fh == 0) {
        Global_DosIoErr_A4 = IoErr();
        Global_AppErrorCode_A4 = 2;
        return -1;
    }

    return fh;
}
