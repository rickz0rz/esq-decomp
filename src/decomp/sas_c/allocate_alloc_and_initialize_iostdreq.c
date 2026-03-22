#include <exec/io.h>
#include <exec/memory.h>
#include <exec/nodes.h>
#include <exec/ports.h>

#define MEMF_PUBLIC_CLEAR (MEMF_PUBLIC | MEMF_CLEAR)

extern void *AbsExecBase;
extern void *_LVOAllocMem(void *execBase, ULONG size, ULONG flags);

struct IOStdReq *ALLOCATE_AllocAndInitializeIOStdReq(struct MsgPort *replyPort)
{
    struct IOStdReq *req;

    if (!replyPort) {
        return (struct IOStdReq *)0;
    }

    req = (struct IOStdReq *)_LVOAllocMem(AbsExecBase, sizeof(struct IOStdReq), MEMF_PUBLIC_CLEAR);
    if (!req) {
        return (struct IOStdReq *)0;
    }

    req->io_Message.mn_Node.ln_Type = NT_MESSAGE;
    req->io_Message.mn_Node.ln_Pri = 0;
    req->io_Message.mn_ReplyPort = replyPort;

    return req;
}
