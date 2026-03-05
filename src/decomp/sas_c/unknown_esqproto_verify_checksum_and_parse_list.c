typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern UBYTE *ESQIFF_RecordBufferPtr;
extern UBYTE ESQIFF_RecordChecksumByte;
extern UWORD ESQIFF_ParseAttemptCount;
extern UWORD ESQIFF_RecordLength;
extern UWORD DATACErrs;

extern LONG UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer(UBYTE *dst, LONG a1, LONG a2);
extern LONG UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte(UBYTE seed, const UBYTE *buf, LONG len);
extern LONG UNKNOWN_ParseListAndUpdateEntries(const UBYTE *buf);

LONG ESQPROTO_VerifyChecksumAndParseList(UBYTE seed)
{
    LONG checksum;

    ESQIFF_ParseAttemptCount = (UWORD)(ESQIFF_ParseAttemptCount + 1u);
    ESQIFF_RecordLength =
        (UWORD)UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 0, 0);

    checksum = UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte(
        seed, ESQIFF_RecordBufferPtr, (LONG)ESQIFF_RecordLength);
    if (checksum != (LONG)ESQIFF_RecordChecksumByte) {
        DATACErrs = (UWORD)(DATACErrs + 1u);
        return 0;
    }

    return UNKNOWN_ParseListAndUpdateEntries(ESQIFF_RecordBufferPtr);
}
