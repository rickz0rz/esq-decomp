#include <exec/types.h>
typedef struct MsgPort MsgPort;
typedef struct StructWithOwner StructWithOwner;

extern MsgPort *SIGNAL_CreateMsgPortWithSignal(char *name, LONG pri);
extern void STRUCT_FreeWithSizeField(StructWithOwner *s);

MsgPort *GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal(char *name, LONG pri)
{
    return SIGNAL_CreateMsgPortWithSignal(name, pri);
}

void GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(StructWithOwner *s)
{
    STRUCT_FreeWithSizeField(s);
}
