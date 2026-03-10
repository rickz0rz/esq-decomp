typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG COI_GetAnimFieldPointerByMode(void *entry, LONG slot, LONG mode);
extern char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern void LADFUNC_GetPackedPenLowNibble(void);
extern char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern LONG COI_TestEntryWithinTimeWindow(UBYTE *entry, void *time_ctx, WORD slot, LONG max_offset, LONG fallback_delta);
extern void CLEANUP_FormatClockFormatEntry(LONG slotIndex, char *out);
extern LONG ESQDISP_ComputeScheduleOffsetForRow(WORD row, UBYTE slot);
extern char *ESQ_FindSubstringCaseFold(char *haystack, char *needle);
extern LONG DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *title, LONG index);
extern void LADFUNC_GetPackedPenHighNibble(void);

char *TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(void *entry, LONG slot, LONG mode){return (char *)COI_GetAnimFieldPointerByMode(entry, slot, mode);}
char *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode){return ESQDISP_GetEntryAuxPointerByMode(index, mode);}
void TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(void){LADFUNC_GetPackedPenLowNibble();}
char *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode){return ESQDISP_GetEntryPointerByMode(index, mode);}
LONG TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(UBYTE *entry, void *time_ctx, WORD slot, LONG max_offset, LONG fallback_delta){return COI_TestEntryWithinTimeWindow(entry, time_ctx, slot, max_offset, fallback_delta);}
void TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry(LONG slotIndex, char *out){CLEANUP_FormatClockFormatEntry(slotIndex, out);}
LONG TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(WORD row, UBYTE slot){return ESQDISP_ComputeScheduleOffsetForRow(row, slot);}
char *TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(char *haystack, char *needle){return ESQ_FindSubstringCaseFold(haystack, needle);}
LONG TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *title, LONG index){return DISPLIB_FindPreviousValidEntryIndex(entry, title, index);}
void TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(void){LADFUNC_GetPackedPenHighNibble();}
