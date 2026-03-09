typedef signed long LONG;

extern void COI_GetAnimFieldPointerByMode(void);
extern char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern void LADFUNC_GetPackedPenLowNibble(void);
extern char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern void COI_TestEntryWithinTimeWindow(void);
extern void CLEANUP_FormatClockFormatEntry(void);
extern void ESQDISP_ComputeScheduleOffsetForRow(void);
extern char *ESQ_FindSubstringCaseFold(char *haystack, char *needle);
extern LONG DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *title, LONG index);
extern void LADFUNC_GetPackedPenHighNibble(void);

void TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(void){COI_GetAnimFieldPointerByMode();}
char *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode){return ESQDISP_GetEntryAuxPointerByMode(index, mode);}
void TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(void){LADFUNC_GetPackedPenLowNibble();}
char *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode){return ESQDISP_GetEntryPointerByMode(index, mode);}
void TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(void){COI_TestEntryWithinTimeWindow();}
void TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry(void){CLEANUP_FormatClockFormatEntry();}
void TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(void){ESQDISP_ComputeScheduleOffsetForRow();}
char *TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(char *haystack, char *needle){return ESQ_FindSubstringCaseFold(haystack, needle);}
LONG TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *title, LONG index){return DISPLIB_FindPreviousValidEntryIndex(entry, title, index);}
void TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(void){LADFUNC_GetPackedPenHighNibble();}
