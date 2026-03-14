#include <exec/types.h>
extern void CLEANUP_RenderAlignedStatusScreen(UWORD sourceMode, UWORD modeSel, UWORD slot);
extern void ESQPARS_ApplyRtcBytesAndPersist(BYTE *src);
extern void ESQ_SetCopperEffect_Custom(void);
extern LONG GCOMMAND_GetBannerChar(void);
extern LONG PARSEINI_ParseIniBufferAndDispatch(const char *path);
extern void PARSEINI_ScanLogoDirectory(void);
extern LONG PARSEINI_WriteErrorLogEntry(void);
extern void SCRIPT_DeassertCtrlLineNow(void);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(UBYTE ctrlByte);
extern void TEXTDISP_FormatEntryTimeForIndex(char *dst, LONG entryIndex, char *entryTable);
extern void TLIBA3_SelectNextViewMode(void);

void GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen(LONG sourceMode, LONG modeSel, LONG slot){CLEANUP_RenderAlignedStatusScreen((UWORD)sourceMode, (UWORD)modeSel, (UWORD)slot);}
void GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(const UBYTE *src){ESQPARS_ApplyRtcBytesAndPersist((BYTE *)src);}
void GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom(void){ESQ_SetCopperEffect_Custom();}
LONG GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar(void){return GCOMMAND_GetBannerChar();}
LONG GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(const char *path){return PARSEINI_ParseIniBufferAndDispatch(path);}
void GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory(void){PARSEINI_ScanLogoDirectory();}
LONG GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry(void){return PARSEINI_WriteErrorLogEntry();}
void GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow(void){SCRIPT_DeassertCtrlLineNow();}
void GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(UBYTE ctrlByte){SCRIPT_UpdateSerialShadowFromCtrlByte(ctrlByte);}
void GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex(char *dst, LONG entryIndex, char *entryTable){TEXTDISP_FormatEntryTimeForIndex(dst, entryIndex, entryTable);}
void GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode(void){TLIBA3_SelectNextViewMode();}
