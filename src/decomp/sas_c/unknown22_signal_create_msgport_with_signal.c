typedef signed long LONG;
typedef unsigned long ULONG;
typedef signed char BYTE;
typedef unsigned char UBYTE;

struct Node {
    struct Node *ln_Succ;
    struct Node *ln_Pred;
    char *ln_Name;
    BYTE ln_Type;
    BYTE ln_Pri;
};

struct List {
    struct Node *lh_Head;
    struct Node *lh_Tail;
    struct Node *lh_TailPred;
    UBYTE lh_Type;
    UBYTE l_pad;
};

struct MsgPort {
    struct Node mp_Node;
    UBYTE mp_Flags;
    UBYTE mp_SigBit;
    void *mp_SigTask;
    struct List mp_MsgList;
};

extern void *AbsExecBase;
extern LONG _LVOAllocSignal(void *execBase, LONG signalNum);
extern void _LVOFreeSignal(void *execBase, LONG signalNum);
extern void *_LVOAllocMem(void *execBase, ULONG size, ULONG flags);
extern void *_LVOFindTask(void *execBase, void *name);
extern void _LVOAddPort(void *execBase, struct MsgPort *port);

struct MsgPort *SIGNAL_CreateMsgPortWithSignal(char *name, LONG pri)
{
    LONG sigNum;
    struct MsgPort *port;

    sigNum = _LVOAllocSignal(AbsExecBase, -1);
    if ((BYTE)sigNum == (BYTE)-1) {
        return (struct MsgPort *)0;
    }

    port = (struct MsgPort *)_LVOAllocMem(AbsExecBase, 34UL, 0x10001UL);
    if (!port) {
        _LVOFreeSignal(AbsExecBase, (UBYTE)sigNum);
        return (struct MsgPort *)0;
    }

    port->mp_Node.ln_Name = name;
    port->mp_Node.ln_Pri = (BYTE)pri;
    port->mp_Node.ln_Type = 4;
    port->mp_Flags = 0;
    port->mp_SigBit = (UBYTE)sigNum;
    port->mp_SigTask = _LVOFindTask(AbsExecBase, (void *)0);

    if (name) {
        _LVOAddPort(AbsExecBase, port);
    } else {
        port->mp_MsgList.lh_Head = (struct Node *)&port->mp_MsgList.lh_Tail;
        port->mp_MsgList.lh_Tail = (struct Node *)0;
        port->mp_MsgList.lh_TailPred = (struct Node *)&port->mp_MsgList.lh_Head;
        port->mp_MsgList.lh_Type = 2;
    }

    return port;
}
