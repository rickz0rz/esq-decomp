#include <exec/ports.h>
#include <exec/memory.h>

#define MEMF_PUBLIC_CLEAR (MEMF_PUBLIC | MEMF_CLEAR)

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

    port = (struct MsgPort *)_LVOAllocMem(AbsExecBase, sizeof(struct MsgPort), MEMF_PUBLIC_CLEAR);
    if (!port) {
        _LVOFreeSignal(AbsExecBase, (UBYTE)sigNum);
        return (struct MsgPort *)0;
    }

    port->mp_Node.ln_Name = name;
    port->mp_Node.ln_Pri = (BYTE)pri;
    port->mp_Node.ln_Type = NT_MSGPORT;
    port->mp_Flags = 0;
    port->mp_SigBit = (UBYTE)sigNum;
    port->mp_SigTask = _LVOFindTask(AbsExecBase, (void *)0);

    if (name) {
        _LVOAddPort(AbsExecBase, port);
    } else {
        port->mp_MsgList.lh_Head = (struct Node *)&port->mp_MsgList.lh_Tail;
        port->mp_MsgList.lh_Tail = (struct Node *)0;
        port->mp_MsgList.lh_TailPred = (struct Node *)&port->mp_MsgList.lh_Head;
        port->mp_MsgList.lh_Type = NT_MESSAGE;
    }

    return port;
}
