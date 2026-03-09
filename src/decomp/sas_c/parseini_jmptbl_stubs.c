extern long STRING_CompareNoCase(const char *a, const char *b);
extern void ED1_WaitForFlagAndClearBit0(void);
extern void DISKIO2_ParseIniFileFromDisk(void);
extern char *STR_FindCharPtr(char *s, long ch);
extern void HANDLE_OpenWithMode(void);
extern void ESQIFF_QueueIffBrushLoad(void);
extern void ESQIFF_HandleBrushIniReloadHotkey(void);
extern void BRUSH_FreeBrushResources(void);
extern void ESQFUNC_RebuildPwBrushListFromTagTable(void);
extern char *GCOMMAND_FindPathSeparator(char *path);
extern char *DISKIO_ConsumeLineFromWorkBuffer(void);
extern void ED1_DrawDiagnosticsScreen(void);
extern void BRUSH_FreeBrushList(void);
extern void GCOMMAND_ValidatePresetTable(void);
extern void BRUSH_AllocBrushNode(void);
extern void UNKNOWN36_FinalizeRequest(void);
extern void GCOMMAND_InitPresetTableFromPalette(void);
extern void STRING_AppendAtNull(void);
extern long DISKIO_LoadFileToWorkBuffer(const char *path);
extern void WDISP_SPrintf(void);
extern void STREAM_ReadLineWithLimit(void);
extern char *STR_FindAnyCharPtr(char *s, const char *set);
extern void ED1_ExitEscMenu(void);
extern char *ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);
extern void ED1_EnterEscMenu(void);
extern void ESQFUNC_DrawEscMenuVersion(void);

long PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b){return STRING_CompareNoCase(a, b);}
void PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0(void){ED1_WaitForFlagAndClearBit0();}
void PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk(void){DISKIO2_ParseIniFileFromDisk();}
char *PARSEINI_JMPTBL_STR_FindCharPtr(char *s, long ch){return STR_FindCharPtr(s, ch);}
void PARSEINI_JMPTBL_HANDLE_OpenWithMode(void){HANDLE_OpenWithMode();}
void PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad(void){ESQIFF_QueueIffBrushLoad();}
void PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey(void){ESQIFF_HandleBrushIniReloadHotkey();}
void PARSEINI_JMPTBL_BRUSH_FreeBrushResources(void){BRUSH_FreeBrushResources();}
void PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable(void){ESQFUNC_RebuildPwBrushListFromTagTable();}
char *PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(char *path){return GCOMMAND_FindPathSeparator(path);}
char *PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer(void){return DISKIO_ConsumeLineFromWorkBuffer();}
void PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen(void){ED1_DrawDiagnosticsScreen();}
void PARSEINI_JMPTBL_BRUSH_FreeBrushList(void){BRUSH_FreeBrushList();}
void PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable(void){GCOMMAND_ValidatePresetTable();}
void PARSEINI_JMPTBL_BRUSH_AllocBrushNode(void){BRUSH_AllocBrushNode();}
void PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(void){UNKNOWN36_FinalizeRequest();}
void PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette(void){GCOMMAND_InitPresetTableFromPalette();}
void PARSEINI_JMPTBL_STRING_AppendAtNull(void){STRING_AppendAtNull();}
long PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(const char *path){return DISKIO_LoadFileToWorkBuffer(path);}
void PARSEINI_JMPTBL_WDISP_SPrintf(void){WDISP_SPrintf();}
void PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(void){STREAM_ReadLineWithLimit();}
char *PARSEINI_JMPTBL_STR_FindAnyCharPtr(char *s, const char *set){return STR_FindAnyCharPtr(s, set);}
void PARSEINI_JMPTBL_ED1_ExitEscMenu(void){ED1_ExitEscMenu();}
char *PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newText, char *oldText){return ESQPARS_ReplaceOwnedString(newText, oldText);}
void PARSEINI_JMPTBL_ED1_EnterEscMenu(void){ED1_EnterEscMenu();}
void PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion(void){ESQFUNC_DrawEscMenuVersion();}
