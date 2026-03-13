typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;

enum {
    SERIAL_READ_DEFAULT_ARG = 0
};

extern UBYTE *ESQIFF_RecordBufferPtr;
extern UBYTE ESQIFF_RecordChecksumByte;
extern UWORD ESQIFF_ParseAttemptCount;
extern UWORD ESQIFF_RecordLength;
extern UWORD DATACErrs;

extern LONG ESQIFF2_ReadSerialRecordIntoBuffer(UBYTE *dst, LONG a1, LONG a2);
extern LONG ESQ_GenerateXorChecksumByte(UBYTE seed, const UBYTE *buf, LONG len);
extern LONG UNKNOWN_ParseListAndUpdateEntries(const char *buf);

LONG ESQPROTO_VerifyChecksumAndParseList(UBYTE seed)
{
    LONG checksum;

    ESQIFF_ParseAttemptCount = (UWORD)(ESQIFF_ParseAttemptCount + 1u);
    ESQIFF_RecordLength =
        (UWORD)ESQIFF2_ReadSerialRecordIntoBuffer(
            ESQIFF_RecordBufferPtr,
            SERIAL_READ_DEFAULT_ARG,
            SERIAL_READ_DEFAULT_ARG
        );

    checksum = ESQ_GenerateXorChecksumByte(
        seed, ESQIFF_RecordBufferPtr, (LONG)ESQIFF_RecordLength);
    if (checksum != (LONG)ESQIFF_RecordChecksumByte) {
        DATACErrs = (UWORD)(DATACErrs + 1u);
        return 0;
    }

    return UNKNOWN_ParseListAndUpdateEntries((const char *)ESQIFF_RecordBufferPtr);
}
