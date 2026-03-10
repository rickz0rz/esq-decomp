typedef signed long LONG;
typedef unsigned long ULONG;

extern void SCRIPT_BeginBannerCharTransition(LONG targetChar, LONG speedMs);
extern void *MEMORY_AllocateMemory(ULONG byteSize, ULONG attributes);
extern void CTASKS_StartIffTaskProcess(void);
extern LONG DOS_OpenFileWithMode(const char *path, LONG mode);

void ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(LONG targetChar, LONG speedMs){SCRIPT_BeginBannerCharTransition(targetChar, speedMs);}
void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, ULONG bytes, ULONG flags){return MEMORY_AllocateMemory(bytes, flags);}
void ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(void){CTASKS_StartIffTaskProcess();}
LONG ESQIFF_JMPTBL_DOS_OpenFileWithMode(const char *path, LONG mode){return DOS_OpenFileWithMode(path, mode);}
