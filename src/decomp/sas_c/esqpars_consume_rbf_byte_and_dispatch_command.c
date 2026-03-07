typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD ESQPARS_Preamble55SeenFlag;
extern UWORD ESQPARS_CommandPreambleArmedFlag;
extern UWORD ESQPARS_SelectionMatchCode;

extern UWORD ESQIFF_RecordLength;
extern UBYTE ESQIFF_RecordChecksumByte;
extern UBYTE *ESQIFF_RecordBufferPtr;

extern UWORD DATACErrs;

extern UBYTE ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void);
extern LONG ESQIFF2_ReadSerialRecordIntoBuffer(void *buffer, LONG arg1, LONG arg2);
extern LONG ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(LONG seed, const UBYTE *buffer, LONG len);
extern UBYTE ESQSHARED_MatchSelectionCodeWithOptionalSuffix(const UBYTE *record);
extern void ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord(LONG cmdChar);
extern void ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList(LONG cmdChar);

LONG ESQPARS_ConsumeRbfByteAndDispatchCommand(void)
{
    UBYTE cmdByte;
    UWORD armed;

    cmdByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
    armed = ESQPARS_CommandPreambleArmedFlag;

    if (armed == 0) {
        if (cmdByte == 0x55u) {
            ESQPARS_Preamble55SeenFlag = 1;
            ESQPARS_CommandPreambleArmedFlag = 0;
            return 0;
        }

        if ((UWORD)cmdByte == 0xAAu && ESQPARS_Preamble55SeenFlag == 1) {
            ESQPARS_Preamble55SeenFlag = 0;
            ESQPARS_CommandPreambleArmedFlag = 1;
            return 0;
        }

        ESQPARS_Preamble55SeenFlag = 0;
        ESQPARS_CommandPreambleArmedFlag = 0;
        return 0;
    }

    if (armed == 1 && ESQPARS_SelectionMatchCode == 0) {
        if (cmdByte == (UBYTE)'A') {
            LONG checksum;

            ESQIFF_RecordLength = (UWORD)ESQIFF2_ReadSerialRecordIntoBuffer((void *)ESQIFF_RecordBufferPtr, 0, 0);
            checksum = ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((LONG)cmdByte, ESQIFF_RecordBufferPtr, (LONG)ESQIFF_RecordLength);
            if ((UBYTE)checksum != ESQIFF_RecordChecksumByte) {
                DATACErrs += 1;
            } else if (ESQIFF_RecordLength <= 16) {
                ESQPARS_SelectionMatchCode = (UWORD)ESQSHARED_MatchSelectionCodeWithOptionalSuffix(ESQIFF_RecordBufferPtr);
            }
        } else if (cmdByte == (UBYTE)'W') {
            ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord((LONG)cmdByte);
        } else if (cmdByte == (UBYTE)'w') {
            ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList((LONG)cmdByte);
        }

        ESQPARS_Preamble55SeenFlag = 0;
        ESQPARS_CommandPreambleArmedFlag = 0;
        return 0;
    }

    return 0;
}
