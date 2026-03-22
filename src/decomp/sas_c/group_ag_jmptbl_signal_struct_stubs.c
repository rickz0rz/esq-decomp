#include <exec/ports.h>
#include <exec/types.h>

typedef struct StructWithOwner StructWithOwner;

extern struct MsgPort *SIGNAL_CreateMsgPortWithSignal(char *name, LONG pri);
extern void STRUCT_FreeWithSizeField(StructWithOwner *s);

struct MsgPort *GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal(char *name, LONG pri)
{
    return SIGNAL_CreateMsgPortWithSignal(name, pri);
}

void GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(StructWithOwner *s)
{
    STRUCT_FreeWithSizeField(s);
}
