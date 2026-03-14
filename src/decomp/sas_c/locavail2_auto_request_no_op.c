#include <exec/types.h>
extern UBYTE Global_REF_LONG_FILE_SCRATCH;

long LOCAVAIL2_AutoRequestNoOp(void)
{
    (void)Global_REF_LONG_FILE_SCRATCH;
    return 0;
}
