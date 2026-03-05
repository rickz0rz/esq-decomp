typedef unsigned long ULONG;
typedef unsigned char UBYTE;

typedef struct StructWithOwner StructWithOwner;
typedef struct MsgPort MSGPORT;

extern StructWithOwner *STRUCT_AllocWithOwner(void *owner, ULONG size);
extern void IOSTDREQ_CleanupSignalAndMsgport(MSGPORT *port);
extern UBYTE *STRING_CopyPadNul(UBYTE *dst, const UBYTE *src, ULONG maxLen);

StructWithOwner *GROUP_AG_JMPTBL_STRUCT_AllocWithOwner(void *owner, ULONG size)
{
    return STRUCT_AllocWithOwner(owner, size);
}

void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(MSGPORT *port)
{
    IOSTDREQ_CleanupSignalAndMsgport(port);
}

UBYTE *GROUP_AG_JMPTBL_STRING_CopyPadNul(UBYTE *dst, const UBYTE *src, ULONG maxLen)
{
    return STRING_CopyPadNul(dst, src, maxLen);
}
