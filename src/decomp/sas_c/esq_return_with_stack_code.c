#include <exec/types.h>
extern LONG ESQ_ShutdownAndReturn(LONG exit_code);

LONG ESQ_ReturnWithStackCode(LONG exit_code)
{
    return ESQ_ShutdownAndReturn(exit_code);
}
