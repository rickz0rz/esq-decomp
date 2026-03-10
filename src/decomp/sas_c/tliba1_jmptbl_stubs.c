typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern const char *COI_GetAnimFieldPointerByMode(const void *entry, LONG slot, LONG mode);
extern const char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern LONG LADFUNC_GetPackedPenLowNibble(UBYTE packed);
extern const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern LONG COI_TestEntryWithinTimeWindow(const UBYTE *entry, const void *time_ctx, WORD slot, LONG max_offset, LONG fallback_delta);
extern void CLEANUP_FormatClockFormatEntry(LONG slotIndex, char *out);
extern LONG ESQDISP_ComputeScheduleOffsetForRow(WORD row, UBYTE slot);
extern char *ESQ_FindSubstringCaseFold(const char *haystack, const char *needle);
extern LONG DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *title, LONG index);
extern LONG LADFUNC_GetPackedPenHighNibble(UBYTE packed);

const char *TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(const void *entry, LONG slot, LONG mode){return COI_GetAnimFieldPointerByMode(entry, slot, mode);}
const char *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode){return ESQDISP_GetEntryAuxPointerByMode(index, mode);}
LONG TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(LONG v){return LADFUNC_GetPackedPenLowNibble((UBYTE)v);}
const char *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode){return ESQDISP_GetEntryPointerByMode(index, mode);}
LONG TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(const UBYTE *entry, const void *time_ctx, WORD slot, LONG max_offset, LONG fallback_delta){return COI_TestEntryWithinTimeWindow(entry, time_ctx, slot, max_offset, fallback_delta);}
void TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry(LONG slotIndex, char *out){CLEANUP_FormatClockFormatEntry(slotIndex, out);}
LONG TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(WORD row, UBYTE slot){return ESQDISP_ComputeScheduleOffsetForRow(row, slot);}
char *TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(const char *haystack, const char *needle){return ESQ_FindSubstringCaseFold(haystack, needle);}
LONG TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *title, LONG index){return DISPLIB_FindPreviousValidEntryIndex(entry, title, index);}
LONG TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(LONG v){return LADFUNC_GetPackedPenHighNibble((UBYTE)v);}
