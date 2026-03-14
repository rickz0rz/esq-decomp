#include <exec/types.h>
extern LONG ESQ_ReturnWithStackCode(LONG code);

LONG UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode(LONG code)
{
    return ESQ_ReturnWithStackCode(code);
}
