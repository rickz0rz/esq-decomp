#include <exec/io.h>
#include <exec/types.h>

extern void *AbsExecBase;
extern void _LVOFreeMem(void *execBase, void *memory, ULONG size);

void IOSTDREQ_Free(struct IOStdReq *req)
{
    req->io_Message.mn_Node.ln_Type = (UBYTE)-1;
    req->io_Device = (struct Device *)-1;
    req->io_Unit   = (struct Unit *)-1;

    _LVOFreeMem(AbsExecBase, req, sizeof(struct IOStdReq));
}