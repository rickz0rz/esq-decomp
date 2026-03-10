typedef signed long LONG;

extern void SCRIPT_BeginBannerCharTransition(LONG targetChar, LONG speedMs);
extern void MEMORY_AllocateMemory(void);
extern void CTASKS_StartIffTaskProcess(void);
extern void DOS_OpenFileWithMode(void);

void ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(LONG targetChar, LONG speedMs){SCRIPT_BeginBannerCharTransition(targetChar, speedMs);}
void ESQIFF_JMPTBL_MEMORY_AllocateMemory(void){MEMORY_AllocateMemory();}
void ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(void){CTASKS_StartIffTaskProcess();}
void ESQIFF_JMPTBL_DOS_OpenFileWithMode(void){DOS_OpenFileWithMode();}
