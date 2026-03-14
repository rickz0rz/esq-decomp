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

/*
typedef unsigned long ULONG;
typedef signed long LONG;

typedef struct IOSTDREQ_Tag {
    char pad0[8];
    signed char field8;
    char pad9[11];
    void *field20;
    void *field24;
    char pad28[20];
} IOSTDREQ;

extern void *AbsExecBase;
extern void _LVOFreeMem(void *execBase, void *memory, ULONG size);

void IOSTDREQ_Free(IOSTDREQ *req)
{
    req->field8 = (signed char)-1;
    req->field20 = (void *)(unsigned long)0xFFFFFFFFUL;
    req->field24 = (void *)(unsigned long)0xFFFFFFFFUL;
    _LVOFreeMem(AbsExecBase, req, 48UL);
}
*/