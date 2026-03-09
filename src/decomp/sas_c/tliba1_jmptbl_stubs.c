extern void COI_GetAnimFieldPointerByMode(void);
extern void ESQDISP_GetEntryAuxPointerByMode(void);
extern void LADFUNC_GetPackedPenLowNibble(void);
extern void ESQDISP_GetEntryPointerByMode(void);
extern void COI_TestEntryWithinTimeWindow(void);
extern void CLEANUP_FormatClockFormatEntry(void);
extern void ESQDISP_ComputeScheduleOffsetForRow(void);
extern char *ESQ_FindSubstringCaseFold(char *haystack, char *needle);
extern void DISPLIB_FindPreviousValidEntryIndex(void);
extern void LADFUNC_GetPackedPenHighNibble(void);

void TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(void){COI_GetAnimFieldPointerByMode();}
void TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(void){ESQDISP_GetEntryAuxPointerByMode();}
void TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(void){LADFUNC_GetPackedPenLowNibble();}
void TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(void){ESQDISP_GetEntryPointerByMode();}
void TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(void){COI_TestEntryWithinTimeWindow();}
void TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry(void){CLEANUP_FormatClockFormatEntry();}
void TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(void){ESQDISP_ComputeScheduleOffsetForRow();}
char *TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(char *haystack, char *needle){return ESQ_FindSubstringCaseFold(haystack, needle);}
void TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(void){DISPLIB_FindPreviousValidEntryIndex();}
void TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(void){LADFUNC_GetPackedPenHighNibble();}
