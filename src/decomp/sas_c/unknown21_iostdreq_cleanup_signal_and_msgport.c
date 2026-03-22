#include <exec/ports.h>
#include <exec/types.h>

extern void *AbsExecBase;
extern void _LVOFreeSignal(void *execBase, LONG signalNum);
extern void _LVOFreeMem(void *execBase, void *memory, ULONG size);
extern void _LVORemPort(void *execBase, void *port);

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

/*
typedef struct MSGPORT_Tag {
    char pad0[8];
    signed char field8;
    char pad9;
    void *field10;
    unsigned char sigBit;
    char pad16[4];
    LONG field20;
    char pad24[10];
} MSGPORT;

extern void *AbsExecBase;
extern void _LVORemPort(void *execBase, void *port);
extern void _LVOFreeSignal(void *execBase, LONG signalNum);
extern void _LVOFreeMem(void *execBase, void *memory, ULONG size);

void IOSTDREQ_CleanupSignalAndMsgport(MSGPORT *port)
{
    if (port->field10 != 0) {
        _LVORemPort(AbsExecBase, port);
    }

    port->field8 = (signed char)-1;
    port->field20 = -1;
    _LVOFreeSignal(AbsExecBase, (LONG)port->sigBit);
    _LVOFreeMem(AbsExecBase, port, 34UL);
}*/
