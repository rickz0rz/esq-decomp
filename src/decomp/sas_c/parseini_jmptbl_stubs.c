typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern long STRING_CompareNoCase(const char *a, const char *b);
extern void ED1_WaitForFlagAndClearBit0(void);
extern void DISKIO2_ParseIniFileFromDisk(void);
extern char *STR_FindCharPtr(const char *s, long ch);
extern void *HANDLE_OpenWithMode(const char *path, const char *mode, char *unused);
extern void ESQIFF_QueueIffBrushLoad(void);
extern void ESQIFF_HandleBrushIniReloadHotkey(void);
extern void BRUSH_FreeBrushResources(void **headPtr);
extern void ESQFUNC_RebuildPwBrushListFromTagTable(void);
extern char *GCOMMAND_FindPathSeparator(const char *path);
extern char *DISKIO_ConsumeLineFromWorkBuffer(void);
extern void ED1_DrawDiagnosticsScreen(void);
extern void BRUSH_FreeBrushList(void **headPtr, LONG freeAll);
extern void GCOMMAND_ValidatePresetTable(UWORD *presetTable);
extern void *BRUSH_AllocBrushNode(const char *brushLabel, void *prevTail);
extern LONG UNKNOWN36_FinalizeRequest(void *req);
extern void GCOMMAND_InitPresetTableFromPalette(UWORD *presetTable);
extern char *STRING_AppendAtNull(char *dst, const char *src);
extern long DISKIO_LoadFileToWorkBuffer(const char *path);
extern long WDISP_SPrintf(void);
extern UBYTE *STREAM_ReadLineWithLimit(UBYTE *dst, LONG max_len, void *stream);
extern char *STR_FindAnyCharPtr(const char *s, const char *set);
extern void ED1_ExitEscMenu(void);
extern char *ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);
extern void ED1_EnterEscMenu(void);
extern void ESQFUNC_DrawEscMenuVersion(void);

long PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b){return STRING_CompareNoCase(a, b);}
void PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0(void){ED1_WaitForFlagAndClearBit0();}
void PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk(void){DISKIO2_ParseIniFileFromDisk();}
char *PARSEINI_JMPTBL_STR_FindCharPtr(const char *s, long ch){return STR_FindCharPtr(s, ch);}
void *PARSEINI_JMPTBL_HANDLE_OpenWithMode(const char *path, const char *mode, char *unused){return HANDLE_OpenWithMode(path, mode, unused);}
void PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad(void){ESQIFF_QueueIffBrushLoad();}
void PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey(void){ESQIFF_HandleBrushIniReloadHotkey();}
void PARSEINI_JMPTBL_BRUSH_FreeBrushResources(void **headPtr){BRUSH_FreeBrushResources(headPtr);}
void PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable(void){ESQFUNC_RebuildPwBrushListFromTagTable();}
char *PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(const char *path){return GCOMMAND_FindPathSeparator(path);}
char *PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer(void){return DISKIO_ConsumeLineFromWorkBuffer();}
void PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen(void){ED1_DrawDiagnosticsScreen();}
void PARSEINI_JMPTBL_BRUSH_FreeBrushList(void **headPtr, LONG freeAll){BRUSH_FreeBrushList(headPtr, freeAll);}
void PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable(UWORD *presetTable){GCOMMAND_ValidatePresetTable(presetTable);}
void *PARSEINI_JMPTBL_BRUSH_AllocBrushNode(const char *brushLabel, void *prevTail){return BRUSH_AllocBrushNode(brushLabel, prevTail);}
LONG PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(void *req){return UNKNOWN36_FinalizeRequest(req);}
void PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette(UWORD *presetTable){GCOMMAND_InitPresetTableFromPalette(presetTable);}
char *PARSEINI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src){return STRING_AppendAtNull(dst, src);}
long PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(const char *path){return DISKIO_LoadFileToWorkBuffer(path);}
long PARSEINI_JMPTBL_WDISP_SPrintf(void){return WDISP_SPrintf();}
UBYTE *PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(UBYTE *dst, LONG max_len, void *stream){return STREAM_ReadLineWithLimit(dst, max_len, stream);}
char *PARSEINI_JMPTBL_STR_FindAnyCharPtr(const char *s, const char *set){return STR_FindAnyCharPtr(s, set);}
void PARSEINI_JMPTBL_ED1_ExitEscMenu(void){ED1_ExitEscMenu();}
char *PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newText, char *oldText){return ESQPARS_ReplaceOwnedString(newText, oldText);}
void PARSEINI_JMPTBL_ED1_EnterEscMenu(void){ED1_EnterEscMenu();}
void PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion(void){ESQFUNC_DrawEscMenuVersion();}
