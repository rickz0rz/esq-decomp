typedef signed long LONG;
typedef signed char BYTE;
typedef unsigned long ULONG;

extern void TEXTDISP_SetRastForMode(void);
extern void P_TYPE_PromoteSecondaryList(void);
extern void DISKIO_ProbeDrivesAndAssignPaths(void);
extern void PARSEINI_UpdateCtrlHDeltaMax(void);
extern void ESQ_ClampBannerCharRange(void);
extern LONG SCRIPT_ReadHandshakeBit3Flag(void);
extern void TLIBA3_DrawCenteredWrappedTextLines(char *rastPort, char *text, LONG y);
extern LONG SCRIPT_GetCtrlLineFlag(void);
extern void LOCAVAIL_SyncSecondaryFilterForCurrentGroup(void);
extern void TEXTDISP_ResetSelectionAndRefresh(void);
extern void PARSEINI_MonitorClockChange(void);
extern LONG LADFUNC_ParseHexDigit(BYTE ch);
extern void CLEANUP_ProcessAlerts(void);
extern ULONG ESQ_GetHalfHourSlotIndex(void *timePtr);
extern void CLEANUP_DrawClockBanner(void);
extern void PARSEINI_ComputeHTCMaxValues(void);
extern void LADFUNC_UpdateHighlightState(void);
extern void P_TYPE_EnsureSecondaryList(void);
extern void PARSEINI_NormalizeClockData(void);
extern void ESQ_TickGlobalCounters(void);
extern void SCRIPT_HandleSerialCtrlCmd(void);
extern void ESQ_HandleSerialRbfInterrupt(void);
extern void TEXTDISP_TickDisplayState(void);
extern void ESQ_PollCtrlInput(void);
extern void LOCAVAIL_RebuildFilterStateFromCurrentGroup(void);
extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen);

void ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(void){TEXTDISP_SetRastForMode();}
void ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList(void){P_TYPE_PromoteSecondaryList();}
void ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(void){DISKIO_ProbeDrivesAndAssignPaths();}
void ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax(void){PARSEINI_UpdateCtrlHDeltaMax();}
void ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange(void){ESQ_ClampBannerCharRange();}
LONG ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag(void){return SCRIPT_ReadHandshakeBit3Flag();}
void ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(char *rastPort, const char *text, LONG y){TLIBA3_DrawCenteredWrappedTextLines(rastPort, (char *)text, y);}
LONG ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag(void){return SCRIPT_GetCtrlLineFlag();}
void ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup(void){LOCAVAIL_SyncSecondaryFilterForCurrentGroup();}
void ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(void){TEXTDISP_ResetSelectionAndRefresh();}
void ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange(void){PARSEINI_MonitorClockChange();}
LONG ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(BYTE ch){return LADFUNC_ParseHexDigit(ch);}
void ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts(void){CLEANUP_ProcessAlerts();}
ULONG ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex(void *timePtr){return ESQ_GetHalfHourSlotIndex(timePtr);}
void ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner(void){CLEANUP_DrawClockBanner();}
void ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues(void){PARSEINI_ComputeHTCMaxValues();}
void ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(void){LADFUNC_UpdateHighlightState();}
void ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList(void){P_TYPE_EnsureSecondaryList();}
void ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData(void){PARSEINI_NormalizeClockData();}
void ESQFUNC_JMPTBL_ESQ_TickGlobalCounters(void){ESQ_TickGlobalCounters();}
void ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd(void){SCRIPT_HandleSerialCtrlCmd();}
void ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt(void){ESQ_HandleSerialRbfInterrupt();}
void ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState(void){TEXTDISP_TickDisplayState();}
void ESQFUNC_JMPTBL_ESQ_PollCtrlInput(void){ESQ_PollCtrlInput();}
void ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup(void){LOCAVAIL_RebuildFilterStateFromCurrentGroup();}
char *ESQFUNC_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen){return STRING_CopyPadNul(dst, src, maxLen);}
