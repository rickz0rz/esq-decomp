#include <exec/ports.h>
#include <exec/types.h>

extern void *AbsExecBase;
extern void _LVOFreeSignal(void *execBase, LONG signalNum);
extern void _LVOFreeMem(void *execBase, void *memory, ULONG size);
extern void _LVORemPort(void *execBase, struct MsgPort *port);

void IOSTDREQ_CleanupSignalAndMsgport(struct MsgPort *port)
{
    if (port->mp_Node.ln_Name != NULL) {
        _LVORemPort(AbsExecBase, port);
    }

    port->mp_Node.ln_Type = (signed char)-1;     // field8
    port->mp_MsgList.lh_Head = (struct Node *)-1; // field20

    _LVOFreeSignal(AbsExecBase, (LONG)port->mp_SigBit);
    _LVOFreeMem(AbsExecBase, port, sizeof(struct MsgPort));
}
