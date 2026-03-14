#include <exec/types.h>
extern const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);

const char *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode){return ESQDISP_GetEntryPointerByMode(index, mode);}
