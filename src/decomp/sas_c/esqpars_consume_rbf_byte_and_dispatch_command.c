#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/text.h>

typedef struct ESQPARS_EntryRecord {
    UBYTE pad0[1];
    UBYTE titleText[26];
    UBYTE flags27;
    UBYTE pad1[12];
    UBYTE flags40;
    UBYTE pad2[7];
} ESQPARS_EntryRecord;

typedef struct ESQPARS_TitleRecord {
    char titleKey[7];
    UBYTE slotFlags[49];
    char *slotTextTable[49];
    UBYTE slotAttr252[49];
    UBYTE slotAttr301[49];
    UBYTE slotAttr350[49];
} ESQPARS_TitleRecord;

enum {
    FLAG_FALSE = 0,
    FLAG_TRUE = 1,
    ASCII_SYNC_55 = 0x55,
    ASCII_SYNC_AA = 0xAA,
    ASCII_BANG = '!',
    ASCII_A = 'A',
    ASCII_B = 'B',
    ASCII_C = 'C',
    ASCII_D = 'D',
    ASCII_E = 'E',
    ASCII_F = 'F',
    ASCII_I = 'I',
    ASCII_J = 'J',
    ASCII_K = 'K',
    ASCII_M = 'M',
    ASCII_O = 'O',
    ASCII_P = 'P',
    ASCII_R = 'R',
    ASCII_V = 'V',
    ASCII_W = 'W',
    ASCII_X = 'X',
    ASCII_g = 'g',
    ASCII_c = 'c',
    ASCII_f = 'f',
    ASCII_i = 'i',
    ASCII_j = 'j',
    ASCII_l = 'l',
    ASCII_o = 'o',
    ASCII_p = 'p',
    ASCII_t = 't',
    ASCII_v = 'v',
    ASCII_w = 'w',
    ASCII_x = 'x',
    ASCII_PERCENT = '%',
    ASCII_EQUALS = '=',
    STATUS_MASK_SELECT = 1,
    STATUS_MASK_TRANSFER = 4,
    STATUS_MODE_SET = 1,
    STATUS_MODE_CLEAR = 0,
    MODE_RECORD_SIMPLE = 0,
    MODE_RECORD_EXTENDED = 1,
    MODE_RECORD_GROUP = 1,
    MODE_RECORD_PROGRAM_INFO = 1,
    MODE_RECORD_COMPACT = 2,
    GROUP_EXTENSION_COUNT = 6,
    SELECT_MATCH_OK = 1,
    MAX_SELECTION_RECORD = 16,
    MAX_PROGRAM_INFO_RECORD = 0xFFFFL,
    MAX_COMPACT_RECORD = 0x1FF,
    MAX_LINE_HEAD_TAIL_RECORD = 0x1F4,
    MAX_DIGIT_LABEL_RECORD = 39,
    MAX_COPY_LABEL_RECORD = 39,
    MAX_FONT_COMMAND_RECORD = 80,
    MAX_VERSION_RECORD = 0x8B,
    MAX_BANNER_ENTRY_RECORD = 0x130,
    MAX_CONFIG_RECORD = 0x2328,
    DIAGNOSTICS_PACKET_BYTES = 256,
    STATUS_PACKET_BYTES = 20,
    CLOCK_PACKET_BYTES = 8
};

extern const char ESQPARS_BannerSubcommandSet[];

extern UWORD ESQPARS_Preamble55SeenFlag;
extern UWORD ESQPARS_CommandPreambleArmedFlag;
extern UWORD ESQPARS_SelectionMatchCode;
extern UWORD ESQPARS_ResetArmedFlag;
extern UWORD ESQPARS_PersistOnNextBoxOffFlag;
extern UWORD ESQ_GlobalTickCounter;

extern UWORD ESQIFF_RecordLength;
extern UBYTE ESQIFF_RecordChecksumByte;
extern UBYTE *ESQIFF_RecordBufferPtr;
extern UWORD ESQIFF_ParseAttemptCount;
extern UWORD ESQIFF_LineErrorCount;
extern UWORD ESQIFF_StatusPacketReadyFlag;

extern ULONG DISKIO2_InteractiveTransferArmedFlag;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UWORD ED_DiagnosticsViewMode;
extern UBYTE CTASKS_STR_1;
extern void *LOCAVAIL_PrimaryFilterState;
extern void *LOCAVAIL_SecondaryFilterState;
extern UBYTE ESQPARS_SelectionSuffixBuffer[];
extern ESQPARS_EntryRecord *TEXTDISP_PrimaryEntryPtrTable[];
extern ESQPARS_EntryRecord *TEXTDISP_SecondaryEntryPtrTable[];
extern ESQPARS_TitleRecord *TEXTDISP_PrimaryTitlePtrTable[];
extern ESQPARS_TitleRecord *TEXTDISP_SecondaryTitlePtrTable[];

extern UWORD DATACErrs;
extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap *Global_REF_696_400_BITMAP;
extern char *Global_STR_RESET_COMMAND_RECEIVED;

extern LONG SCRIPT_ReadNextRbfByte(void);
extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(const char *haystack, LONG needle);
extern LONG ESQIFF2_ReadSerialRecordIntoBuffer(UBYTE *buffer, WORD arg1, WORD arg2);
extern WORD ESQIFF2_ReadSerialSizedTextRecord(char *dst, LONG payload_size);
extern UBYTE *ESQIFF2_ReadRbfBytesToBuffer(UBYTE *dst, UWORD count);
extern UBYTE *ESQIFF2_ReadRbfBytesWithXor(UBYTE *dst, UWORD count, UBYTE *xorAccum);
extern LONG ESQ_GenerateXorChecksumByte(UBYTE seed, const UBYTE *buffer, LONG len);
extern void ESQ_ReverseBitsIn6Bytes(UBYTE *dst, UBYTE *src);
extern LONG ESQ_TestBit1Based(const UBYTE *base, ULONG bitIndex);
extern UBYTE ESQSHARED_MatchSelectionCodeWithOptionalSuffix(const UBYTE *record);
extern LONG ESQPROTO_VerifyChecksumAndParseRecord(UBYTE seed);
extern LONG ESQPROTO_VerifyChecksumAndParseList(UBYTE seed);
extern void ESQDISP_UpdateStatusMaskAndRefresh(LONG mask, LONG mode);
extern const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern const char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern void ESQSHARED_ParseCompactEntryRecord(UBYTE *record);
extern void ESQDISP_ParseProgramInfoCommandRecord(char *record);
extern char *ESQPROTO_ParseDigitLabelAndDisplay(const char *in);
extern void ESQPROTO_CopyLabelToGlobal(const char *src);
extern void ESQIFF2_ClearPrimaryEntryFlags34To39(void);
extern void PARSEINI_HandleFontCommand(const char *command);
extern void ESQIFF2_ParseLineHeadTailRecord(UBYTE *record);
extern void ESQIFF2_ParseGroupRecordAndRefresh(UBYTE *src);
extern void ESQIFF2_ApplyIncomingStatusPacket(UBYTE *src);
extern void ESQIFF2_ShowVersionMismatchOverlay(void);
extern void DST_HandleBannerCommand32_33(UBYTE cmd, const char *text);
extern LONG LADFUNC_ParseBannerEntryData(UBYTE mode, const char *in);
extern void ESQPARS_ApplyRtcBytesAndPersist(BYTE *src);
extern UBYTE ESQPARS_ReadLengthWordWithChecksumXor(UBYTE xor_seed);
extern void ESQPARS_PersistStateDataAfterCommand(void);
extern LONG DISKIO2_HandleInteractiveFileTransfer(UBYTE crc32Mode);
extern void DISKIO_ParseConfigBuffer(char *buffer, ULONG size);
extern LONG DISKIO_SaveConfigToFileHandle(void);
extern LONG CLEANUP_ParseAlignedListingBlock(char *record);
extern LONG LOCAVAIL_ParseFilterStateFromBuffer(const UBYTE *buffer, void *statePtr);
extern LONG P_TYPE_ParseAndStoreTypeRecord(const char *src);
extern LONG GCOMMAND_ParseCommandOptions(char *cmd);
extern LONG GCOMMAND_ParseCommandString(char *cmd);
extern LONG GCOMMAND_ParsePPVCommand(char *cmd);
extern ULONG MATH_Mulu32(ULONG a, ULONG b);
extern char *ESQPARS_ReplaceOwnedString(const char *new_src, char *old_owned);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text);
extern void ESQ_PollCtrlInput(void);
extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);

static LONG ESQPARS_ComputeResetOverlayX(struct RastPort *rastPort)
{
    LONG x;
    LONG charWidth;

    charWidth = (LONG)(UWORD)rastPort->Font->tf_XSize;
    x = 34 - charWidth;
    if (x < 0) {
        x++;
    }

    return (x >> 1) + charWidth + 29;
}

static void ESQPARS_ClearPreambleState(void)
{
    ESQPARS_Preamble55SeenFlag = 0;
    ESQPARS_CommandPreambleArmedFlag = 0;
}

static void ESQPARS_IncrementParseAttemptCount(void)
{
    ESQIFF_ParseAttemptCount = (UWORD)(ESQIFF_ParseAttemptCount + 1u);
}

static void ESQPARS_IncrementLineErrorCount(void)
{
    ESQIFF_LineErrorCount = (UWORD)(ESQIFF_LineErrorCount + 1u);
}

static void ESQPARS_IncrementDataErrorCount(void)
{
    DATACErrs = (UWORD)(DATACErrs + 1u);
}

static LONG ESQPARS_VerifyExistingRecord(UBYTE seed, LONG maxLength)
{
    LONG checksum;

    checksum = ESQ_GenerateXorChecksumByte(seed, ESQIFF_RecordBufferPtr, (LONG)ESQIFF_RecordLength);
    if ((UBYTE)checksum != ESQIFF_RecordChecksumByte) {
        ESQPARS_IncrementDataErrorCount();
        return FLAG_FALSE;
    }

    if ((LONG)ESQIFF_RecordLength > maxLength) {
        ESQPARS_IncrementLineErrorCount();
        return FLAG_FALSE;
    }

    return FLAG_TRUE;
}

static LONG ESQPARS_ReadRecordAndVerify(UBYTE seed, WORD mode, WORD extCount, LONG maxLength)
{
    ESQIFF_RecordLength =
        (UWORD)ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, mode, extCount);
    return ESQPARS_VerifyExistingRecord(seed, maxLength);
}

static LONG ESQPARS_ReadStatusPacketAndVerify(UBYTE seed)
{
    ESQIFF2_ReadRbfBytesToBuffer(ESQIFF_RecordBufferPtr, STATUS_PACKET_BYTES + 1);
    ESQFUNC_WaitForClockChangeAndServiceUi();
    ESQIFF_RecordChecksumByte = (UBYTE)SCRIPT_ReadNextRbfByte();
    return ((UBYTE)ESQ_GenerateXorChecksumByte(seed, ESQIFF_RecordBufferPtr, STATUS_PACKET_BYTES) ==
            ESQIFF_RecordChecksumByte);
}

static LONG ESQPARS_ReadFixedPacketAndVerify(UBYTE seed, UWORD count)
{
    ESQIFF2_ReadRbfBytesToBuffer(ESQIFF_RecordBufferPtr, count);
    ESQFUNC_WaitForClockChangeAndServiceUi();
    (void)SCRIPT_ReadNextRbfByte();
    ESQFUNC_WaitForClockChangeAndServiceUi();
    ESQIFF_RecordChecksumByte = (UBYTE)SCRIPT_ReadNextRbfByte();
    return ((UBYTE)ESQ_GenerateXorChecksumByte(seed, ESQIFF_RecordBufferPtr, (LONG)count) ==
            ESQIFF_RecordChecksumByte);
}

static void ESQPARS_CopySelectionSuffixBuffer(void)
{
    UBYTE *src;
    UBYTE *dst;

    src = ESQIFF_RecordBufferPtr;
    dst = ESQPARS_SelectionSuffixBuffer;
    do {
        *dst = *src;
        dst++;
        src++;
    } while (dst[-1] != 0);
}

static LONG ESQPARS_ResolveGroupModeAndCount(
    UBYTE groupCode,
    LONG *modeOut,
    LONG *countOut)
{
    if (groupCode == TEXTDISP_SecondaryGroupCode && TEXTDISP_SecondaryGroupPresentFlag == 1) {
        *modeOut = 2;
        *countOut = (LONG)(UWORD)TEXTDISP_SecondaryGroupEntryCount;
        return FLAG_TRUE;
    }

    if (groupCode == TEXTDISP_PrimaryGroupCode) {
        *modeOut = 1;
        *countOut = (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount;
        return FLAG_TRUE;
    }

    return FLAG_FALSE;
}

static LONG ESQPARS_TitleKeyMatches(const char *lhs, const char *rhs)
{
    while (*lhs == *rhs) {
        if (*lhs == 0) {
            return FLAG_TRUE;
        }
        lhs++;
        rhs++;
    }

    return FLAG_FALSE;
}

static LONG ESQPARS_BitmapHasAnySetBytes(const UBYTE *bitmap)
{
    UWORD i;

    for (i = 0; i < 6; ++i) {
        if (bitmap[i] != 0) {
            return FLAG_TRUE;
        }
    }

    return FLAG_FALSE;
}

LONG ESQPARS_ConsumeRbfByteAndDispatchCommand(void)
{
    UBYTE cmdByte;
    UWORD armed;

    cmdByte = (UBYTE)SCRIPT_ReadNextRbfByte();
    armed = ESQPARS_CommandPreambleArmedFlag;

    if (armed == 0) {
        if (cmdByte == (UBYTE)ASCII_SYNC_55) {
            ESQPARS_Preamble55SeenFlag = 1;
            ESQPARS_CommandPreambleArmedFlag = 0;
            return 0;
        }

        if ((UWORD)cmdByte == (UWORD)ASCII_SYNC_AA && ESQPARS_Preamble55SeenFlag == 1) {
            ESQPARS_Preamble55SeenFlag = 0;
            ESQPARS_CommandPreambleArmedFlag = 1;
            return 0;
        }

        ESQPARS_ClearPreambleState();
        return 0;
    }

    if (armed == 1 && ESQPARS_SelectionMatchCode == 0) {
        if (cmdByte == (UBYTE)ASCII_A) {
            if (ESQPARS_ReadRecordAndVerify(cmdByte, MODE_RECORD_SIMPLE, 0, MAX_SELECTION_RECORD) !=
                FLAG_FALSE) {
                ESQPARS_SelectionMatchCode =
                    (UWORD)ESQSHARED_MatchSelectionCodeWithOptionalSuffix(ESQIFF_RecordBufferPtr);
                if (ESQPARS_SelectionMatchCode == SELECT_MATCH_OK) {
                    ESQPARS_ResetArmedFlag = 1;
                    ESQDISP_UpdateStatusMaskAndRefresh(STATUS_MASK_SELECT, 2);
                    DISKIO2_InteractiveTransferArmedFlag = 1;
                    ESQPARS_IncrementParseAttemptCount();
                }
            }
        } else if (cmdByte == (UBYTE)ASCII_W) {
            ESQPROTO_VerifyChecksumAndParseRecord(cmdByte);
        } else if (cmdByte == (UBYTE)ASCII_w) {
            ESQPROTO_VerifyChecksumAndParseList(cmdByte);
        }

        ESQPARS_ClearPreambleState();
        return 0;
    }

    if (armed != 1 || ESQPARS_SelectionMatchCode != SELECT_MATCH_OK) {
        return 0;
    }

    switch (cmdByte) {
    case ASCII_BANG:
    {
        UBYTE valid;
        UBYTE xorAccum;
        UBYTE groupCode;
        UBYTE slotStart;
        UBYTE slotEnd;
        UBYTE titleByte;
        char titleKey[7];
        UBYTE checksumByte;
        LONG mode;
        LONG count;
        LONG index;
        ESQPARS_EntryRecord *entry;
        ESQPARS_TitleRecord *title;

        valid = 0;
        xorAccum = 0xDEu;
        ESQPARS_IncrementParseAttemptCount();
        ESQIFF2_ReadRbfBytesWithXor(&groupCode, 1, &xorAccum);
        ESQIFF2_ReadRbfBytesWithXor(&slotStart, 1, &xorAccum);
        ESQIFF2_ReadRbfBytesWithXor(&slotEnd, 1, &xorAccum);

        if (slotStart < 1 || slotEnd > (UBYTE)'0' || slotStart > slotEnd) {
            break;
        }
        if (groupCode != TEXTDISP_PrimaryGroupCode && groupCode != TEXTDISP_SecondaryGroupCode) {
            break;
        }

        index = 0;
        ESQIFF2_ReadRbfBytesWithXor(&titleByte, 1, &xorAccum);
        while (titleByte != 0 && titleByte != 0x12 && titleByte != ' ' && index < 6) {
            titleKey[index++] = (char)titleByte;
            ESQIFF2_ReadRbfBytesWithXor(&titleByte, 1, &xorAccum);
        }
        titleKey[index] = 0;
        while (titleByte != 0) {
            ESQIFF2_ReadRbfBytesWithXor(&titleByte, 1, &xorAccum);
        }

        ESQIFF2_ReadRbfBytesToBuffer(&checksumByte, 1);
        if (xorAccum != checksumByte) {
            break;
        }

        if (slotStart == (UBYTE)'Y') {
            slotStart = 1;
            slotEnd = (UBYTE)'0';
        }

        if (ESQPARS_ResolveGroupModeAndCount(groupCode, &mode, &count) == FLAG_FALSE) {
            break;
        }

        entry = 0;
        title = 0;
        for (index = 0; index < count; ++index) {
            entry = (ESQPARS_EntryRecord *)ESQDISP_GetEntryPointerByMode(index, mode);
            title = (ESQPARS_TitleRecord *)ESQDISP_GetEntryAuxPointerByMode(index, mode);
            if (ESQPARS_TitleKeyMatches(titleKey, (const char *)title) != FLAG_FALSE) {
                valid = 1;
                break;
            }
        }

        if (valid == 0) {
            break;
        }

        if (slotStart == 1 && slotEnd == (UBYTE)'0') {
            entry->flags40 = (UBYTE)(entry->flags40 & 0x7Fu);
        }

        while (slotStart <= slotEnd) {
            title->slotTextTable[(UWORD)slotStart] =
                ESQPARS_ReplaceOwnedString((const char *)0, title->slotTextTable[(UWORD)slotStart]);
            title->slotFlags[(UWORD)slotStart] = 1;
            slotStart++;
        }
        break;
    }

    case ASCII_P:
        ESQPARS_IncrementParseAttemptCount();
        if (ESQPARS_ReadRecordAndVerify(cmdByte, MODE_RECORD_SIMPLE, 0, MAX_COMPACT_RECORD) !=
            FLAG_FALSE) {
            ESQSHARED_ParseCompactEntryRecord(ESQIFF_RecordBufferPtr);
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_p:
    {
        UBYTE valid;
        UBYTE xorAccum;
        UBYTE groupCode;
        UBYTE bitmap[6];
        UBYTE reversedBitmap[6];
        char keyBuf[9];
        UBYTE payloadWidth;
        UBYTE payload[147];
        UBYTE payloadTrailer;
        UBYTE checksumByte;
        LONG mode;
        LONG count;
        LONG titleIndex;
        LONG payloadIndex;
        ESQPARS_EntryRecord *entry;
        ESQPARS_TitleRecord *title;

        ESQPARS_IncrementParseAttemptCount();
        valid = 0;
        xorAccum = 0x8Fu;
        ESQIFF2_ReadRbfBytesWithXor(&groupCode, 1, &xorAccum);
        ESQIFF2_ReadRbfBytesWithXor((UBYTE *)&payloadWidth, 1, &xorAccum);
        titleIndex = 0;
        for (;;) {
            keyBuf[(UWORD)titleIndex] = (char)payloadWidth;
            if (payloadWidth == 0x12u || titleIndex >= 8) {
                break;
            }
            titleIndex++;
            ESQIFF2_ReadRbfBytesWithXor((UBYTE *)&payloadWidth, 1, &xorAccum);
        }
        keyBuf[(UWORD)titleIndex] = 0;

        if (ESQPARS_ResolveGroupModeAndCount(groupCode, &mode, &count) == FLAG_FALSE) {
            break;
        }

        ESQIFF2_ReadRbfBytesWithXor(bitmap, 6, &xorAccum);
        ESQ_ReverseBitsIn6Bytes(reversedBitmap, bitmap);

        entry = 0;
        title = 0;
        for (titleIndex = 0; titleIndex < count; ++titleIndex) {
            if (mode == 2) {
                entry = TEXTDISP_SecondaryEntryPtrTable[(UWORD)titleIndex];
                title = TEXTDISP_SecondaryTitlePtrTable[(UWORD)titleIndex];
            } else {
                entry = TEXTDISP_PrimaryEntryPtrTable[(UWORD)titleIndex];
                title = TEXTDISP_PrimaryTitlePtrTable[(UWORD)titleIndex];
            }
            if (ESQPARS_TitleKeyMatches(keyBuf, (const char *)title) != FLAG_FALSE) {
                valid = 1;
                break;
            }
        }

        ESQIFF2_ReadRbfBytesWithXor(&payloadWidth, 1, &xorAccum);
        if (payloadWidth < 1 || payloadWidth > 3) {
            valid = 0;
        }

        if (ESQPARS_BitmapHasAnySetBytes(bitmap) == FLAG_FALSE) {
            if (valid == 0) {
                break;
            }
            ESQIFF2_ReadRbfBytesWithXor(payload, payloadWidth, &xorAccum);
            ESQIFF2_ReadRbfBytesWithXor(&payloadTrailer, 1, &xorAccum);
            if (payloadTrailer != 0) {
                valid = 0;
            }
            ESQIFF2_ReadRbfBytesToBuffer(&checksumByte, 1);
            if (xorAccum != checksumByte) {
                valid = 0;
            }

            if (valid != 0) {
                if (payloadWidth > 0 && payload[0] >= 5 && payload[0] <= 10) {
                    entry->flags40 = (UBYTE)(entry->flags40 | 0x01u);
                }
                for (payloadIndex = 0; payloadIndex < 49; ++payloadIndex) {
                    if (payloadWidth > 0) title->slotAttr252[(UWORD)payloadIndex] = payload[0];
                    if (payloadWidth > 1) title->slotAttr301[(UWORD)payloadIndex] = payload[1];
                    if (payloadWidth > 2) title->slotAttr350[(UWORD)payloadIndex] = payload[2];
                }
            }
        } else {
            LONG markedRows;
            LONG row;

            if (valid == 0) {
                break;
            }

            markedRows = 0;
            for (row = 1; row < 49; ++row) {
                if (ESQ_TestBit1Based(reversedBitmap, (ULONG)row) + 1 == 0) {
                    markedRows++;
                }
            }

            ESQIFF2_ReadRbfBytesWithXor(
                payload, (UWORD)MATH_Mulu32((ULONG)payloadWidth, (ULONG)markedRows), &xorAccum);
            ESQIFF2_ReadRbfBytesWithXor(&payloadTrailer, 1, &xorAccum);
            if (payloadTrailer != 0) {
                valid = 0;
            }
            ESQIFF2_ReadRbfBytesToBuffer(&checksumByte, 1);
            if (xorAccum != checksumByte) {
                valid = 0;
            }

            if (valid != 0) {
                payloadIndex = 0;
                for (row = 1; row < 49; ++row) {
                    if (ESQ_TestBit1Based(reversedBitmap, (ULONG)row) + 1 != 0) {
                        continue;
                    }
                    if (payloadWidth > 0) {
                        title->slotAttr252[(UWORD)row] = payload[(UWORD)payloadIndex];
                        if (payload[(UWORD)payloadIndex] >= 5 &&
                            payload[(UWORD)payloadIndex] <= 10) {
                            entry->flags40 = (UBYTE)(entry->flags40 | 0x01u);
                        }
                        payloadIndex++;
                    }
                    if (payloadWidth > 1) {
                        title->slotAttr301[(UWORD)row] = payload[(UWORD)payloadIndex];
                        payloadIndex++;
                    }
                    if (payloadWidth > 2) {
                        title->slotAttr350[(UWORD)row] = payload[(UWORD)payloadIndex];
                        payloadIndex++;
                    }
                }
            }
        }

        ESQPARS_ResetArmedFlag = 0;
        break;
    }

    case ASCII_E:
        ESQPARS_IncrementParseAttemptCount();
        if (ESQPARS_ReadRecordAndVerify(cmdByte, MODE_RECORD_SIMPLE, 0, MAX_PROGRAM_INFO_RECORD) !=
            FLAG_FALSE) {
            ESQPARS_CopySelectionSuffixBuffer();
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_c:
        ESQPARS_IncrementParseAttemptCount();
        ESQIFF_RecordLength =
            (UWORD)ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, MODE_RECORD_PROGRAM_INFO, 0);
        if (ESQIFF_RecordLength != 0 &&
            (UBYTE)ESQ_GenerateXorChecksumByte(
                cmdByte, ESQIFF_RecordBufferPtr, (LONG)ESQIFF_RecordLength) ==
                ESQIFF_RecordChecksumByte) {
            ESQDISP_ParseProgramInfoCommandRecord((char *)ESQIFF_RecordBufferPtr);
        } else {
            ESQPARS_IncrementDataErrorCount();
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_I:
        ESQPARS_IncrementParseAttemptCount();
        if (ESQPARS_ReadRecordAndVerify(cmdByte, MODE_RECORD_SIMPLE, 0, MAX_DIGIT_LABEL_RECORD) !=
            FLAG_FALSE) {
            ESQPROTO_ParseDigitLabelAndDisplay((const char *)ESQIFF_RecordBufferPtr);
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_i:
    case ASCII_j:
        ESQPARS_IncrementParseAttemptCount();
        if (ESQPARS_ReadRecordAndVerify(cmdByte,
                                        MODE_RECORD_SIMPLE,
                                        0,
                                        (cmdByte == (UBYTE)ASCII_j) ? MAX_LINE_HEAD_TAIL_RECORD
                                                                    : MAX_COPY_LABEL_RECORD) !=
            FLAG_FALSE) {
            if (cmdByte == (UBYTE)ASCII_j) {
                ESQIFF2_ParseLineHeadTailRecord(ESQIFF_RecordBufferPtr);
            } else {
                ESQPROTO_CopyLabelToGlobal((const char *)ESQIFF_RecordBufferPtr);
            }
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_F:
        ESQPARS_IncrementParseAttemptCount();
        if (ESQPARS_ReadStatusPacketAndVerify(cmdByte) != FLAG_FALSE) {
            if ((ESQIFF_RecordBufferPtr[0] == (UBYTE)ASCII_A ||
                 ESQIFF_RecordBufferPtr[0] == (UBYTE)ASCII_B) &&
                ESQIFF_RecordBufferPtr[1] >= (UBYTE)ASCII_A &&
                ESQIFF_RecordBufferPtr[1] < (UBYTE)ASCII_J) {
                ESQIFF2_ApplyIncomingStatusPacket(ESQIFF_RecordBufferPtr);
            } else {
                ESQPARS_IncrementDataErrorCount();
            }
        } else {
            ESQPARS_IncrementDataErrorCount();
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_K:
        if (ED_DiagnosticsViewMode != 1) {
            ESQPARS_IncrementParseAttemptCount();
            if (ESQPARS_ReadFixedPacketAndVerify(cmdByte, CLOCK_PACKET_BYTES) != FLAG_FALSE &&
                ESQIFF_RecordBufferPtr[0] < 7 &&
                ESQIFF_RecordBufferPtr[1] < 12 &&
                ESQIFF_RecordBufferPtr[6] < 60 &&
                CTASKS_STR_1 == '2') {
                ESQPARS_ApplyRtcBytesAndPersist((BYTE *)ESQIFF_RecordBufferPtr);
            } else {
                ESQPARS_IncrementDataErrorCount();
            }
            ESQPARS_ResetArmedFlag = 0;
        }
        break;

    case ASCII_O:
        ESQPARS_IncrementParseAttemptCount();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        (void)SCRIPT_ReadNextRbfByte();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        if ((UBYTE)SCRIPT_ReadNextRbfByte() == (UBYTE)0xB0) {
            ESQIFF2_ClearPrimaryEntryFlags34To39();
        } else {
            ESQPARS_IncrementDataErrorCount();
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_X:
        ESQPARS_IncrementParseAttemptCount();
        ESQIFF_RecordLength = (UWORD)ESQIFF2_ReadSerialRecordIntoBuffer(
            ESQIFF_RecordBufferPtr, MODE_RECORD_SIMPLE, 0);
        if ((UBYTE)ESQ_GenerateXorChecksumByte(
                cmdByte, ESQIFF_RecordBufferPtr, (LONG)ESQIFF_RecordLength) ==
                ESQIFF_RecordChecksumByte &&
            ESQIFF_RecordLength <= MAX_FONT_COMMAND_RECORD) {
            PARSEINI_HandleFontCommand((const char *)ESQIFF_RecordBufferPtr);
        } else {
            ESQPARS_IncrementDataErrorCount();
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_C:
        ESQPARS_IncrementParseAttemptCount();
        ESQIFF_RecordLength = (UWORD)ESQIFF2_ReadSerialRecordIntoBuffer(
            ESQIFF_RecordBufferPtr, MODE_RECORD_GROUP, GROUP_EXTENSION_COUNT);
        if (ESQIFF_RecordLength == 0) {
            break;
        }
        if (ESQPARS_VerifyExistingRecord(cmdByte, MAX_PROGRAM_INFO_RECORD) != FLAG_FALSE &&
            ESQIFF_StatusPacketReadyFlag == 1) {
            ESQIFF2_ParseGroupRecordAndRefresh(ESQIFF_RecordBufferPtr);
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_V:
        ESQPARS_IncrementParseAttemptCount();
        if (ESQPARS_ReadRecordAndVerify(cmdByte, MODE_RECORD_SIMPLE, 0, MAX_VERSION_RECORD) !=
            FLAG_FALSE) {
            ESQIFF2_ShowVersionMismatchOverlay();
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_f:
    {
        UBYTE xorSeed;

        ESQFUNC_WaitForClockChangeAndServiceUi();
        xorSeed = (UBYTE)SCRIPT_ReadNextRbfByte();
        xorSeed ^= cmdByte;
        xorSeed = ESQPARS_ReadLengthWordWithChecksumXor(xorSeed);

        if (ESQIFF_RecordLength >= MAX_CONFIG_RECORD) {
            ESQPARS_IncrementLineErrorCount();
            ESQPARS_ClearPreambleState();
            return 0;
        }

        ESQIFF_RecordLength = (UWORD)(ESQIFF_RecordLength - 1u);
        ESQIFF2_ReadRbfBytesToBuffer(ESQIFF_RecordBufferPtr, ESQIFF_RecordLength);
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = (UBYTE)SCRIPT_ReadNextRbfByte();
        if ((UBYTE)ESQ_GenerateXorChecksumByte(xorSeed, ESQIFF_RecordBufferPtr, (LONG)ESQIFF_RecordLength) ==
            ESQIFF_RecordChecksumByte) {
            ESQPARS_IncrementParseAttemptCount();
            DISKIO_ParseConfigBuffer((char *)ESQIFF_RecordBufferPtr, (ULONG)ESQIFF_RecordLength);
            DISKIO_SaveConfigToFileHandle();
        } else {
            ESQPARS_IncrementDataErrorCount();
        }
        ESQPARS_ResetArmedFlag = 0;
        break;
    }

    case ASCII_g:
    {
        UBYTE xorSeed;
        UBYTE subcommand;

        ESQFUNC_WaitForClockChangeAndServiceUi();
        subcommand = (UBYTE)SCRIPT_ReadNextRbfByte();
        xorSeed = (UBYTE)(cmdByte ^ subcommand);

        if (subcommand == (UBYTE)'1') {
            ESQFUNC_WaitForClockChangeAndServiceUi();
            ESQIFF_RecordBufferPtr[0] = (UBYTE)SCRIPT_ReadNextRbfByte();
            ESQIFF_RecordLength = (UWORD)(ESQIFF2_ReadSerialRecordIntoBuffer(
                ESQIFF_RecordBufferPtr + 1, MODE_RECORD_SIMPLE, 0) + 1);
            if ((UBYTE)ESQ_GenerateXorChecksumByte(
                    xorSeed, ESQIFF_RecordBufferPtr, (LONG)ESQIFF_RecordLength) ==
                ESQIFF_RecordChecksumByte) {
                if (ESQIFF_RecordBufferPtr[0] == TEXTDISP_PrimaryGroupCode) {
                    LOCAVAIL_ParseFilterStateFromBuffer(
                        ESQIFF_RecordBufferPtr, LOCAVAIL_PrimaryFilterState);
                } else if (ESQIFF_RecordBufferPtr[0] == TEXTDISP_SecondaryGroupCode) {
                    LOCAVAIL_ParseFilterStateFromBuffer(
                        ESQIFF_RecordBufferPtr, LOCAVAIL_SecondaryFilterState);
                }
                ESQPARS_IncrementParseAttemptCount();
            } else {
                ESQPARS_IncrementDataErrorCount();
            }
            break;
        }

        if (GROUP_AS_JMPTBL_STR_FindCharPtr(ESQPARS_BannerSubcommandSet, (LONG)subcommand) != 0) {
            ESQIFF_RecordLength =
                (UWORD)ESQIFF2_ReadSerialSizedTextRecord((char *)ESQIFF_RecordBufferPtr, 2);
            if (ESQIFF_RecordLength == 0) {
                ESQPARS_IncrementLineErrorCount();
            } else if ((UBYTE)ESQ_GenerateXorChecksumByte(
                           xorSeed, ESQIFF_RecordBufferPtr, (LONG)ESQIFF_RecordLength) ==
                       ESQIFF_RecordChecksumByte) {
                DST_HandleBannerCommand32_33(subcommand, (const char *)ESQIFF_RecordBufferPtr);
                ESQPARS_IncrementParseAttemptCount();
            } else {
                ESQPARS_IncrementDataErrorCount();
            }
            break;
        }

        if (subcommand >= (UBYTE)'5' && subcommand <= (UBYTE)'8') {
            ESQFUNC_WaitForClockChangeAndServiceUi();
            ESQIFF_RecordLength = (UWORD)ESQIFF2_ReadSerialRecordIntoBuffer(
                ESQIFF_RecordBufferPtr, MODE_RECORD_SIMPLE, 0);
            if ((UBYTE)ESQ_GenerateXorChecksumByte(
                    xorSeed, ESQIFF_RecordBufferPtr, (LONG)ESQIFF_RecordLength) ==
                ESQIFF_RecordChecksumByte) {
                if (subcommand == (UBYTE)'5') {
                    P_TYPE_ParseAndStoreTypeRecord((const char *)ESQIFF_RecordBufferPtr);
                } else if (subcommand == (UBYTE)'6') {
                    GCOMMAND_ParseCommandOptions((char *)ESQIFF_RecordBufferPtr);
                } else if (subcommand == (UBYTE)'7') {
                    GCOMMAND_ParseCommandString((char *)ESQIFF_RecordBufferPtr);
                } else {
                    GCOMMAND_ParsePPVCommand((char *)ESQIFF_RecordBufferPtr);
                }
                ESQPARS_IncrementParseAttemptCount();
            } else {
                ESQPARS_IncrementDataErrorCount();
            }
        }
        break;
    }

    case ASCII_EQUALS:
    case 'H':
        ESQPARS_IncrementParseAttemptCount();
        ESQPARS_ResetArmedFlag = 0;
        if (DISKIO2_InteractiveTransferArmedFlag == 1) {
            DISKIO2_HandleInteractiveFileTransfer((UBYTE)(cmdByte == (UBYTE)ASCII_EQUALS));
        }
        break;

    case ASCII_PERCENT:
        ESQPARS_IncrementParseAttemptCount();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        (void)SCRIPT_ReadNextRbfByte();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        if ((UBYTE)SCRIPT_ReadNextRbfByte() == (UBYTE)0xDA) {
            ESQPARS_PersistOnNextBoxOffFlag = 1;
        } else {
            ESQPARS_IncrementDataErrorCount();
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_R:
        ESQPARS_IncrementParseAttemptCount();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        (void)SCRIPT_ReadNextRbfByte();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        if ((UBYTE)SCRIPT_ReadNextRbfByte() == (UBYTE)0xAD) {
            if (ESQPARS_ResetArmedFlag == 1) {
                ESQ_GlobalTickCounter = 21000;
                Global_REF_RASTPORT_1->BitMap = Global_REF_696_400_BITMAP;

                for (;;) {
                    DISPLIB_DisplayTextAtPosition(
                        (char *)Global_REF_RASTPORT_1,
                        ESQPARS_ComputeResetOverlayX(Global_REF_RASTPORT_1),
                        40,
                        Global_STR_RESET_COMMAND_RECEIVED);
                }
            }
        } else {
            ESQPARS_IncrementDataErrorCount();
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_M:
        ESQPARS_IncrementParseAttemptCount();
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_v:
        ESQPARS_IncrementParseAttemptCount();
        ESQIFF_RecordLength =
            (UWORD)ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, MODE_RECORD_PROGRAM_INFO, 0);
        if (ESQIFF_RecordLength == 0) {
            break;
        }
        if (ESQPARS_VerifyExistingRecord(cmdByte, MAX_PROGRAM_INFO_RECORD) != FLAG_FALSE &&
            ESQIFF_RecordBufferPtr[1] == '1') {
            CLEANUP_ParseAlignedListingBlock((char *)ESQIFF_RecordBufferPtr);
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_l:
    case ASCII_t:
        ESQPARS_IncrementParseAttemptCount();
        if (ESQPARS_ReadRecordAndVerify(cmdByte,
                                        MODE_RECORD_SIMPLE,
                                        0,
                                        MAX_BANNER_ENTRY_RECORD) != FLAG_FALSE) {
            LADFUNC_ParseBannerEntryData(cmdByte, (const char *)ESQIFF_RecordBufferPtr);
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case ASCII_W:
        ESQPROTO_VerifyChecksumAndParseRecord(cmdByte);
        break;

    case ASCII_w:
        ESQPROTO_VerifyChecksumAndParseList(cmdByte);
        break;

    case ASCII_x:
    {
        UBYTE trailer;

        ESQPARS_IncrementParseAttemptCount();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        trailer = (UBYTE)SCRIPT_ReadNextRbfByte();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        (void)SCRIPT_ReadNextRbfByte();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = (UBYTE)SCRIPT_ReadNextRbfByte();

        if (trailer == (UBYTE)~ASCII_D && ESQIFF_RecordChecksumByte == (UBYTE)~0) {
            if (ESQPARS_PersistOnNextBoxOffFlag != 0) {
                ESQPARS_PersistStateDataAfterCommand();
                ESQPARS_PersistOnNextBoxOffFlag = 0;
            }
            ESQPARS_SelectionMatchCode = 0;
            ESQDISP_UpdateStatusMaskAndRefresh(STATUS_MASK_SELECT, STATUS_MODE_CLEAR);
        } else {
            ESQPARS_IncrementDataErrorCount();
        }
        ESQPARS_ResetArmedFlag = 0;
        break;
    }

    case ASCII_D:
        ESQPARS_IncrementParseAttemptCount();
        ESQIFF2_ReadRbfBytesToBuffer(ESQIFF_RecordBufferPtr, DIAGNOSTICS_PACKET_BYTES);
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = (UBYTE)SCRIPT_ReadNextRbfByte();
        if ((UBYTE)ESQ_GenerateXorChecksumByte(
                cmdByte, ESQIFF_RecordBufferPtr, DIAGNOSTICS_PACKET_BYTES) !=
            ESQIFF_RecordChecksumByte) {
            ESQPARS_IncrementDataErrorCount();
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    default:
        break;
    }

    ESQPARS_ClearPreambleState();
    return 0;
}
