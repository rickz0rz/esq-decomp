extern long MATH_Mulu32(long a, long b);
extern void DISKIO_ResetCtrlInputStateIfIdle(void);

long ESQIFF_JMPTBL_MATH_Mulu32(long a, long b){return MATH_Mulu32(a, b);}
void ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle(void){DISKIO_ResetCtrlInputStateIfIdle();}
