extern void CLEANUP_RenderAlignedStatusScreen(void);
extern void ESQPARS_ApplyRtcBytesAndPersist(void);
extern void ESQ_SetCopperEffect_Custom(void);
extern void GCOMMAND_GetBannerChar(void);
extern void PARSEINI_ParseIniBufferAndDispatch(void);
extern void PARSEINI_ScanLogoDirectory(void);
extern void PARSEINI_WriteErrorLogEntry(void);
extern void SCRIPT_DeassertCtrlLineNow(void);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(void);
extern void TEXTDISP_FormatEntryTimeForIndex(void);
extern void TLIBA3_SelectNextViewMode(void);

void GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen(void){CLEANUP_RenderAlignedStatusScreen();}
void GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(void){ESQPARS_ApplyRtcBytesAndPersist();}
void GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom(void){ESQ_SetCopperEffect_Custom();}
void GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar(void){GCOMMAND_GetBannerChar();}
void GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(void){PARSEINI_ParseIniBufferAndDispatch();}
void GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory(void){PARSEINI_ScanLogoDirectory();}
void GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry(void){PARSEINI_WriteErrorLogEntry();}
void GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow(void){SCRIPT_DeassertCtrlLineNow();}
void GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(void){SCRIPT_UpdateSerialShadowFromCtrlByte();}
void GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex(void){TEXTDISP_FormatEntryTimeForIndex();}
void GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode(void){TLIBA3_SelectNextViewMode();}
