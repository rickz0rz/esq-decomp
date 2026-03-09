typedef signed long LONG;
typedef unsigned char UBYTE;

extern void CLEANUP_RenderAlignedStatusScreen(void);
extern void ESQPARS_ApplyRtcBytesAndPersist(void);
extern void ESQ_SetCopperEffect_Custom(void);
extern LONG GCOMMAND_GetBannerChar(void);
extern void PARSEINI_ParseIniBufferAndDispatch(const char *path);
extern void PARSEINI_ScanLogoDirectory(void);
extern void PARSEINI_WriteErrorLogEntry(void);
extern void SCRIPT_DeassertCtrlLineNow(void);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(UBYTE ctrlByte);
extern void TEXTDISP_FormatEntryTimeForIndex(char *dst, LONG entryIndex, char *entryTable);
extern void TLIBA3_SelectNextViewMode(void);

void GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen(void){CLEANUP_RenderAlignedStatusScreen();}
void GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(void){ESQPARS_ApplyRtcBytesAndPersist();}
void GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom(void){ESQ_SetCopperEffect_Custom();}
LONG GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar(void){return GCOMMAND_GetBannerChar();}
void GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(const char *path){PARSEINI_ParseIniBufferAndDispatch(path);}
void GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory(void){PARSEINI_ScanLogoDirectory();}
void GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry(void){PARSEINI_WriteErrorLogEntry();}
void GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow(void){SCRIPT_DeassertCtrlLineNow();}
void GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(UBYTE ctrlByte){SCRIPT_UpdateSerialShadowFromCtrlByte(ctrlByte);}
void GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex(char *dst, LONG entryIndex, char *entryTable){TEXTDISP_FormatEntryTimeForIndex(dst, entryIndex, entryTable);}
void GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode(void){TLIBA3_SelectNextViewMode();}
