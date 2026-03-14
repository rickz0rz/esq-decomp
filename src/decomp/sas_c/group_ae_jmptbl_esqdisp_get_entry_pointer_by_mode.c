#include <exec/types.h>
extern const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);

const char *GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode)
{
    return ESQDISP_GetEntryPointerByMode(index, mode);
}
