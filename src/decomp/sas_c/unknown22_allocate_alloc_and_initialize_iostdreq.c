typedef unsigned long ULONG;
typedef signed long LONG;
typedef unsigned char UBYTE;

struct Node {
    struct Node *ln_Succ;
    struct Node *ln_Pred;
    char *ln_Name;
    UBYTE ln_Type;
    signed char ln_Pri;
};

struct Message {
    struct Node mn_Node;
    void *mn_ReplyPort;
    unsigned short mn_Length;
};

struct IOStdReq {
    struct Message io_Message;
    UBYTE pad[48 - sizeof(struct Message)];
};

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
