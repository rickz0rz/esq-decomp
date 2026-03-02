#include "esq_types.h"

/*
 * Target 593 GCC trial function.
 * Read record payload, verify XOR checksum, and dispatch record parser.
 */
extern u8 *ESQIFF_RecordBufferPtr;
extern u8 ESQIFF_RecordChecksumByte;
extern u16 ESQIFF_ParseAttemptCount;
extern u16 ESQIFF_RecordLength;
extern u16 DATACErrs;

s32 UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer(u8 *dst, s32 a1, s32 a2) __attribute__((noinline));
s32 UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte(u8 seed, const u8 *buf, s32 len) __attribute__((noinline));
s32 UNKNOWN_ParseRecordAndUpdateDisplay(const u8 *buf) __attribute__((noinline));

s32 ESQPROTO_VerifyChecksumAndParseRecord(u8 seed) __attribute__((noinline, used));

s32 ESQPROTO_VerifyChecksumAndParseRecord(u8 seed)
{
    s32 checksum;

    ESQIFF_ParseAttemptCount = (u16)(ESQIFF_ParseAttemptCount + 1u);
    ESQIFF_RecordLength = (u16)UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 0, 0);

    checksum = UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte(seed, ESQIFF_RecordBufferPtr, (s32)ESQIFF_RecordLength);
    if (checksum != (s32)ESQIFF_RecordChecksumByte) {
        DATACErrs = (u16)(DATACErrs + 1u);
        return 0;
    }

    return UNKNOWN_ParseRecordAndUpdateDisplay(ESQIFF_RecordBufferPtr);
}
