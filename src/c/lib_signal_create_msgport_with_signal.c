/* RESTORES: _SIGNAL_CreateMsgPortWithSignal
 * MODULE:   modules/submodules/unknown22_signal_createmsgportwithsignal.s
 * STATUS:   behavioural
 *
 * SAS/C library code: CreatePort. Allocates a signal and a MsgPort, binds them
 * to the current task, and either publishes the port by name or initialises its
 * message list in place.
 *
 * THE SIGNAL TEST IS ON A BYTE. `CMPI.B #-1,D6` -- AllocSignal returns -1 as a
 * LONG when none is free, and the original compares only the low byte. Both
 * agree for -1, so `(BYTE)sig == -1` says what the original says.
 *
 * THE SIGNAL IS FREED IF THE PORT ALLOCATION FAILS. Leaving that out leaks a
 * signal bit per failure, and a task has only 32.
 *
 * A NAMED PORT IS PUBLISHED, AN UNNAMED ONE IS NOT. AddPort() both publishes the
 * port and initialises its list; the else arm has to do the list by hand because
 * it deliberately does NOT publish. Calling AddPort unconditionally would put an
 * anonymous port into the public list where anything could find it.
 *
 * THE HAND-BUILT LIST IS NewList PLUS THE TYPE BYTE:
 *
 *     lh_Head     = &lh_Tail     (port+20 = port+24)
 *     lh_Tail     = 0            (port+24)
 *     lh_TailPred = &lh_Head     (port+28 = port+20)
 *     lh_Type     = NT_MSGPORT   (port+32 = 2)
 *
 * It is written out rather than calling NewList() because NewList does not set
 * lh_Type, and the original does.
 *
 * THE SIZE IS THE LITERAL 34, which is sizeof(struct MsgPort) on this ABI. The
 * literal is kept for the same reason as in the IOStdReq allocator beside it.
 *
 * FindTask(0) RETURNS THE CURRENT TASK -- the original zeroes A1 with
 * `SUBA.L A1,A1` for exactly that.
 */
#include "esq-exec.h"
#include <exec/memory.h>
#include <exec/ports.h>

struct MsgPort *SIGNAL_CreateMsgPortWithSignal(char *name, long pri)
{
    struct MsgPort *port;
    long sig;

    sig = AllocSignal(-1L);
    if ((BYTE)sig == -1)
        return 0;

    port = (struct MsgPort *)AllocMem(34L, MEMF_PUBLIC | MEMF_CLEAR);
    if (port == 0) {
        FreeSignal(sig);
        return 0;
    }

    port->mp_Node.ln_Name = (char *)name;
    port->mp_Node.ln_Pri = (BYTE)pri;
    port->mp_Node.ln_Type = NT_MSGPORT;
    port->mp_Flags = 0;                  /* redundant under MEMF_CLEAR */
    port->mp_SigBit = (UBYTE)sig;
    port->mp_SigTask = (struct Task *)FindTask(0);

    if (name != 0) {
        AddPort(port);
    } else {
        /* NewList plus the type byte, which NewList does not set. */
        port->mp_MsgList.lh_Head     = (struct Node *)&port->mp_MsgList.lh_Tail;
        port->mp_MsgList.lh_Tail     = 0;
        port->mp_MsgList.lh_TailPred = (struct Node *)&port->mp_MsgList.lh_Head;
        port->mp_MsgList.lh_Type     = NT_MSGPORT;
    }

    return port;
}
