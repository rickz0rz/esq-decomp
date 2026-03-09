typedef signed long LONG;

extern char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);

char *GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode)
{
    return ESQDISP_GetEntryPointerByMode(index, mode);
}
