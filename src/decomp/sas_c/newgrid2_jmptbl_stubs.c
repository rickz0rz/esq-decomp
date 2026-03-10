typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern void COI_SelectAnimFieldPointer(void);
extern void DISPTEXT_SetCurrentLineIndex(LONG lineIndex);
extern LONG DISPTEXT_LayoutAndAppendToBuffer(char *layoutCtx, const char *src);
extern LONG DISPTEXT_GetTotalLineCount(void);
extern void TLIBA_FindFirstWildcardMatchIndex(void);
extern void DISPTEXT_BuildLayoutForSource(void);
extern void BEVEL_DrawBevelFrameWithTopRight(void);
extern char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern void BEVEL_DrawVerticalBevel(void);
extern void DISPTEXT_LayoutSourceToLines(void);
extern void CLEANUP_UpdateEntryFlagBytes(void);
extern void COI_RenderClockFormatEntryVariant(void);
extern void ESQDISP_TestEntryBits0And2(void);
extern LONG DISPTEXT_ComputeVisibleLineCount(LONG maxLines);
extern void DISPTEXT_RenderCurrentLine(char *rp, LONG x, LONG y);
extern void COI_ProcessEntrySelectionState(void);
extern void CLEANUP_FormatClockFormatEntry(void);
extern void ESQ_GetHalfHourSlotIndex(void);
extern char *STR_SkipClass3Chars(char *s);
extern void STRING_AppendN(void);
extern void ESQDISP_ComputeScheduleOffsetForRow(void);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern void CLEANUP_TestEntryFlagYAndBit1(void);
extern LONG DISPTEXT_IsCurrentLineLast(void);
extern LONG DISPTEXT_IsLastLineSelected(void);
extern void BEVEL_DrawBeveledFrame(void);
extern LONG DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *title, LONG index);
extern LONG ESQ_TestBit1Based(UBYTE *base, ULONG bitIndex);
extern LONG DISPTEXT_MeasureCurrentLineLength(char *rp);
extern void DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern LONG DISPTEXT_HasMultipleLines(void);
extern void BEVEL_DrawHorizontalBevel(void);
extern LONG MATH_DivS32(LONG a, LONG b);
extern LONG MATH_Mulu32(LONG a, LONG b);

void NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(void){COI_SelectAnimFieldPointer();}
void NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(LONG lineIndex){DISPTEXT_SetCurrentLineIndex(lineIndex);}
LONG NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(char *layoutCtx, const char *src){return DISPTEXT_LayoutAndAppendToBuffer(layoutCtx, src);}
LONG NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount(void){return DISPTEXT_GetTotalLineCount();}
void NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(void){TLIBA_FindFirstWildcardMatchIndex();}
void NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource(void){DISPTEXT_BuildLayoutForSource();}
void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void){BEVEL_DrawBevelFrameWithTopRight();}
char *NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode){return ESQDISP_GetEntryAuxPointerByMode(index, mode);}
void NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(void){BEVEL_DrawVerticalBevel();}
void NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(void){DISPTEXT_LayoutSourceToLines();}
void NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes(void){CLEANUP_UpdateEntryFlagBytes();}
void NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant(void){COI_RenderClockFormatEntryVariant();}
void NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2(void){ESQDISP_TestEntryBits0And2();}
LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG maxLines){return DISPTEXT_ComputeVisibleLineCount(maxLines);}
void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(char *rp, LONG x, LONG y){DISPTEXT_RenderCurrentLine(rp, x, y);}
void NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(void){COI_ProcessEntrySelectionState();}
void NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(void){CLEANUP_FormatClockFormatEntry();}
void NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(void){ESQ_GetHalfHourSlotIndex();}
char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(char *s){return STR_SkipClass3Chars(s);}
void NEWGRID2_JMPTBL_STRING_AppendN(void){STRING_AppendN();}
void NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(void){ESQDISP_ComputeScheduleOffsetForRow();}
LONG NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s){return PARSE_ReadSignedLongSkipClass3_Alt(s);}
void NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1(void){CLEANUP_TestEntryFlagYAndBit1();}
LONG NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void){return DISPTEXT_IsCurrentLineLast();}
LONG NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(void){return DISPTEXT_IsLastLineSelected();}
void NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(void){BEVEL_DrawBeveledFrame();}
LONG NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *title, LONG index){return DISPLIB_FindPreviousValidEntryIndex(entry, title, index);}
LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(UBYTE *base, ULONG bitIndex){return ESQ_TestBit1Based(base, bitIndex);}
LONG NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength(char *rp){return DISPTEXT_MeasureCurrentLineLength(rp);}
void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen){DISPTEXT_SetLayoutParams(width, rowHeight, pen);}
LONG NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(void){return DISPTEXT_HasMultipleLines();}
void NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(void){BEVEL_DrawHorizontalBevel();}
LONG NEWGRID2_JMPTBL_MATH_DivS32(LONG a, LONG b){return MATH_DivS32(a, b);}
LONG NEWGRID2_JMPTBL_MATH_Mulu32(LONG a, LONG b){return MATH_Mulu32(a, b);}
