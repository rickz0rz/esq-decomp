typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG ESQPROTO_VerifyChecksumAndParseRecord(UBYTE seed);

LONG ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord(LONG cmdChar){return ESQPROTO_VerifyChecksumAndParseRecord((UBYTE)cmdChar);}
