typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern void DST_AddTimeOffset(void);
extern LONG ESQ_TestBit1Based(UBYTE *base, ULONG bitIndex);

void TLIBA2_JMPTBL_DST_AddTimeOffset(void){DST_AddTimeOffset();}
LONG TLIBA2_JMPTBL_ESQ_TestBit1Based(UBYTE *base, ULONG bitIndex){return ESQ_TestBit1Based(base, bitIndex);}
