typedef signed short WORD;

extern void DST_RefreshBannerBuffer(void);
extern long DST_UpdateBannerQueue(void *pair);
extern void ESQDISP_DrawStatusBanner(void);
extern void ESQFUNC_DrawDiagnosticsScreen(void);
extern void ESQFUNC_DrawEscMenuVersion(void);
extern void ESQFUNC_DrawMemoryStatusScreen(void);
extern void ESQFUNC_FreeExtraTitleTextPointers(WORD max_index);
extern void GCOMMAND_UpdateBannerBounds(long left, long top, long right, long bottom);

extern long PARSEINI_AdjustHoursTo24HrFormat(WORD hour, WORD amPmFlag);
extern void PARSEINI_UpdateClockFromRtc(void);
extern void SCRIPT_ClearCtrlLineIfEnabled(void);
extern void SCRIPT_PollHandshakeAndApplyTimeout(void);

void GROUP_AC_JMPTBL_DST_RefreshBannerBuffer(void){DST_RefreshBannerBuffer();}
long GROUP_AC_JMPTBL_DST_UpdateBannerQueue(void *pair){return DST_UpdateBannerQueue(pair);}
void GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner(void){ESQDISP_DrawStatusBanner();}
void GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen(void){ESQFUNC_DrawDiagnosticsScreen();}
void GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion(void){ESQFUNC_DrawEscMenuVersion();}
void GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen(void){ESQFUNC_DrawMemoryStatusScreen();}
void GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers(WORD max_index){ESQFUNC_FreeExtraTitleTextPointers(max_index);}
void GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds(long left, long top, long right, long bottom){GCOMMAND_UpdateBannerBounds(left, top, right, bottom);}
long GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat(WORD hour, WORD amPmFlag){return PARSEINI_AdjustHoursTo24HrFormat(hour, amPmFlag);}
void GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc(void){PARSEINI_UpdateClockFromRtc();}
void GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled(void){SCRIPT_ClearCtrlLineIfEnabled();}
void GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout(void){SCRIPT_PollHandshakeAndApplyTimeout();}
