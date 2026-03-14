#include <exec/types.h>
typedef struct StructWithOwner StructWithOwner;
typedef struct MsgPort MSGPORT;

extern StructWithOwner *STRUCT_AllocWithOwner(void *owner, ULONG size);
extern void IOSTDREQ_CleanupSignalAndMsgport(MSGPORT *port);
extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen);

StructWithOwner *GROUP_AG_JMPTBL_STRUCT_AllocWithOwner(void *owner, ULONG size)
{
    return STRUCT_AllocWithOwner(owner, size);
}

void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(MSGPORT *port)
{
    IOSTDREQ_CleanupSignalAndMsgport(port);
}

char *GROUP_AG_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen)
{
    return STRING_CopyPadNul(dst, src, maxLen);
}
