#include <exec/types.h>
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
}
