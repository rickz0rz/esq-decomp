typedef unsigned long ULONG;

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
