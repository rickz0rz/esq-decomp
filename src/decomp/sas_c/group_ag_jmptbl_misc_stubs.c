#include <exec/ports.h>
#include <exec/types.h>

typedef struct StructWithOwner StructWithOwner;

extern StructWithOwner *STRUCT_AllocWithOwner(void *owner, ULONG size);
extern void IOSTDREQ_CleanupSignalAndMsgport(struct MsgPort *port);
extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen);

StructWithOwner *GROUP_AG_JMPTBL_STRUCT_AllocWithOwner(void *owner, ULONG size)
{
    return STRUCT_AllocWithOwner(owner, size);
}

void GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(struct MsgPort *port)
{
    IOSTDREQ_CleanupSignalAndMsgport(port);
}

char *GROUP_AG_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen)
{
    return STRING_CopyPadNul(dst, src, maxLen);
}
