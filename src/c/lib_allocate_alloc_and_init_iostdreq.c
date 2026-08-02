/* RESTORES: _ALLOCATE_AllocAndInitializeIOStdReq
 * MODULE:   modules/submodules/unknown22_allocate_allocandinitializeiostdreq.s
 * STATUS:   behavioural
 *
 * SAS/C library code: CreateStdIO. Allocates a 48-byte IOStdReq, marks it as a
 * message and points it at the reply port it was given.
 *
 * A NULL REPLY PORT IS REJECTED BEFORE THE ALLOCATION. An IOStdReq with no reply
 * port cannot be replied to, so the function refuses rather than hand back one
 * that will hang the caller on WaitPort.
 *
 * THE SIZE IS THE LITERAL 48, and the original says why in a comment: MOVEQ
 * cannot take the symbolic Struct_IOStdReq_Size. sizeof(struct IOStdReq) is 48
 * on this ABI, so the two agree; the literal is kept so the restoration cannot
 * silently follow a header that disagrees with the original's allocation.
 *
 * MEMF_CLEAR is set, so the explicit ln_Pri clear that follows is redundant in
 * the original too. It is kept.
 */
#include "esq-exec.h"
#include <exec/memory.h>
#include <exec/io.h>

struct IOStdReq *ALLOCATE_AllocAndInitializeIOStdReq(struct MsgPort *replyPort)
{
    struct IOStdReq *io;

    if (replyPort == 0)
        return 0;

    io = (struct IOStdReq *)AllocMem(48L, MEMF_PUBLIC | MEMF_CLEAR);
    if (io != 0) {
        io->io_Message.mn_Node.ln_Type = NT_MESSAGE;
        io->io_Message.mn_Node.ln_Pri = 0;      /* redundant under MEMF_CLEAR */
        io->io_Message.mn_ReplyPort = replyPort;
    }

    return io;
}
