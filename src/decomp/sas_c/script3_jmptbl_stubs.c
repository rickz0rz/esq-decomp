typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef signed char BYTE;
typedef unsigned char UBYTE;

extern void LOCAVAIL_UpdateFilterStateMachine(void *ctxPtr, void *statePtr);
extern LONG MATH_DivS32(LONG dividend, LONG divisor);
extern char *ESQSHARED_ApplyProgramTitleTextFilters(char *text, LONG maxLen);
extern LONG STRING_CompareN(const char *a, const char *b, LONG maxLen);
extern void ESQDISP_UpdateStatusMaskAndRefresh(unsigned long mask, LONG setMode);
extern LONG GCOMMAND_GetBannerChar(void);
extern LONG LADFUNC_ParseHexDigit(BYTE ch);
extern void ESQPARS_ApplyRtcBytesAndPersist(BYTE *src);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *s);
extern void GCOMMAND_AdjustBannerCopperOffset(BYTE delta);
extern void ESQ_SetCopperEffect_Custom(void);
extern void CLEANUP_RenderAlignedStatusScreen(UWORD sourceMode, UWORD modeSel, UWORD slot);
extern void LOCAVAIL_ComputeFilterOffsetForEntry(const BYTE *text, void *statePtr);
extern LONG MATH_Mulu32(LONG a, LONG b);
extern void LOCAVAIL_SetFilterModeAndResetState(LONG mode);
extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG n);

void SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine(void *ctxPtr, void *statePtr){LOCAVAIL_UpdateFilterStateMachine(ctxPtr, statePtr);}
LONG SCRIPT3_JMPTBL_MATH_DivS32(LONG dividend, LONG divisor){return MATH_DivS32(dividend, divisor);}
char *SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(char *text, LONG maxLen){return ESQSHARED_ApplyProgramTitleTextFilters(text, maxLen);}
LONG SCRIPT3_JMPTBL_STRING_CompareN(const char *a, const char *b, LONG maxLen){return STRING_CompareN(a, b, maxLen);}
void SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(unsigned long mask, LONG setMode){ESQDISP_UpdateStatusMaskAndRefresh(mask, setMode);}
LONG SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(void){return GCOMMAND_GetBannerChar();}
LONG SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(BYTE ch){return LADFUNC_ParseHexDigit(ch);}
void SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(BYTE *src){ESQPARS_ApplyRtcBytesAndPersist(src);}
LONG SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *s){return PARSE_ReadSignedLongSkipClass3_Alt(s);}
void SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset(BYTE delta){GCOMMAND_AdjustBannerCopperOffset(delta);}
void SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom(void){ESQ_SetCopperEffect_Custom();}
void SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(LONG sourceMode, LONG modeSel, LONG slot){CLEANUP_RenderAlignedStatusScreen((UWORD)sourceMode, (UWORD)modeSel, (UWORD)slot);}
void SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry(const BYTE *text, void *statePtr){LOCAVAIL_ComputeFilterOffsetForEntry(text, statePtr);}
LONG SCRIPT3_JMPTBL_MATH_Mulu32(LONG a, LONG b){return MATH_Mulu32(a, b);}
void SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState(LONG mode){LOCAVAIL_SetFilterModeAndResetState(mode);}
char *SCRIPT3_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG n){return STRING_CopyPadNul(dst, src, n);}
