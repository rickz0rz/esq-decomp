typedef signed long LONG;
typedef signed short WORD;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern void DST_AddTimeOffset(void *dt, WORD hours, WORD minutes);
extern LONG ESQ_TestBit1Based(const UBYTE *base, ULONG bitIndex);

void TLIBA2_JMPTBL_DST_AddTimeOffset(void *dt, WORD hours, WORD minutes){DST_AddTimeOffset(dt, hours, minutes);}
LONG TLIBA2_JMPTBL_ESQ_TestBit1Based(const UBYTE *base, ULONG bitIndex){return ESQ_TestBit1Based(base, bitIndex);}
