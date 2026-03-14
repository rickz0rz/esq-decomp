#include <exec/io.h>

extern void *AbsExecBase;
extern void *_LVOAllocMem(void *execBase, ULONG size, ULONG flags);

struct IOStdReq *ALLOCATE_AllocAndInitializeIOStdReq(void *replyPort)
{
    struct IOStdReq *req;

    if (!replyPort) {
        return (struct IOStdReq *)0;
    }

    req = (struct IOStdReq *)_LVOAllocMem(AbsExecBase, 48UL, 0x10001UL);
    if (!req) {
        return (struct IOStdReq *)0;
    }

    req->io_Message.mn_Node.ln_Type = 5;
    req->io_Message.mn_Node.ln_Pri = 0;
    req->io_Message.mn_ReplyPort = replyPort;

    return req;
}
