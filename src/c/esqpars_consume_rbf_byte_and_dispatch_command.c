/* RESTORES: _ESQPARS_ConsumeRbfByteAndDispatchCommand
 * MODULE:   src/modules/groups/a/o/esqpars_p1_2.s
 * STATUS:   behavioural
 *
 * The RBF serial command interpreter: 5,956 bytes, the largest function in
 * ESQ. It reads one byte from the serial line, runs the 0x55/0xAA preamble
 * state machine, and dispatches 30 command letters.
 *
 * Structure of the original, which this file keeps:
 *   - preamble not armed: 0x55 arms the "seen" flag, 0xAA with "seen" set
 *     arms the command flag, anything else clears both.
 *   - armed and no selection match yet: only 'A', 'W' and 'w' are accepted.
 *   - armed and selection match code 1: the full command table.
 *
 * SASC-MISMATCH: reserved-a5-frame-and-call-encoding
 *   ref:     4EBA<d16>                 JSR (d16,PC)
 *   got:     6100<d16>                 BSR.W
 *   summary: every call in this function is cross-unit in the original, so
 *            each one costs the same size at a different opcode. The function
 *            also holds a 232-byte A5 frame that SAS/C 6.51 lays out in its
 *            own order.
 *   tried:   nothing. A function this size cannot land byte-exact under a
 *            compiler that emits BSR.W for every callee.
 *   scope:   whole function.
 *   retest:  a compiler that picks the call encoding per translation unit.
 *
 * NOTE ON MATH_Mulu32: the sparse payload length is a 32-bit multiply. Written
 * in C it makes SAS/C emit a call to __CXM22, its own runtime helper, which is
 * not linked here -- so this file calls the original's helper instead, through
 * an __asm register prototype. That is safe and was CHECKED, not assumed:
 * _MATH_Mulu32 opens `MOVEM.L D2-D3,-(A7)` and restores both, so it honours the
 * standard convention. It is also what the original does at this site.
 */

#include <exec/types.h>
#include <string.h>

/* Byte and long access at a fixed offset from a pointer. The original folds
 * these offsets into (d16,An) displacements. */
#define BYTE_AT(p, off) (*((unsigned char *)(p) + (off)))
#define LONG_AT(p, off) (*(long *)((char *)(p) + (off)))

extern unsigned short ESQIFF_RecordLength;
extern unsigned char  ESQIFF_RecordChecksumByte;
extern char          *ESQIFF_RecordBufferPtr;
extern short          ESQIFF_ParseAttemptCount;
extern short          ESQIFF_LineErrorCount;
extern short          ESQIFF_StatusPacketReadyFlag;
extern short          DATACErrs;

extern short          ESQPARS_SelectionMatchCode;
extern short          ESQPARS_ResetArmedFlag;
extern short          ESQPARS_Preamble55SeenFlag;
extern short          ESQPARS_CommandPreambleArmedFlag;
extern short          ESQPARS_PersistOnNextBoxOffFlag;
extern char           ESQPARS_SelectionSuffixBuffer[];
extern char           ESQPARS_BannerSubcommandSet[];

extern long           DISKIO2_InteractiveTransferArmedFlag;
extern short          ED_DiagnosticsViewMode;
extern short          ESQ_GlobalTickCounter;

extern unsigned char  TEXTDISP_PrimaryGroupCode;
extern unsigned char  TEXTDISP_SecondaryGroupCode;
extern unsigned char  TEXTDISP_SecondaryGroupPresentFlag;
extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern unsigned short TEXTDISP_SecondaryGroupEntryCount;
extern char          *TEXTDISP_PrimaryEntryPtrTable[];
extern char          *TEXTDISP_PrimaryTitlePtrTable[];
extern char          *TEXTDISP_SecondaryEntryPtrTable[];
extern char          *TEXTDISP_SecondaryTitlePtrTable[];

extern char           LOCAVAIL_PrimaryFilterState[];
extern char           LOCAVAIL_SecondaryFilterState[];
extern char           CTASKS_STR_1;
extern char          *Global_REF_RASTPORT_1;
extern char           Global_REF_696_400_BITMAP[];
extern char           Global_STR_RESET_COMMAND_RECEIVED[];

extern unsigned char ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void);
extern long  ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(long seed, char *buf, long len);
extern void  ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord(long cmd);
extern void  ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList(long cmd);
extern void  ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay(char *buf);
extern void  ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal(char *buf);
extern void  ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock(char *buf);
extern void  ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer(long isEquals);
extern void  ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer(char *buf, long len);
extern void  ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle(char *buf, long len);
extern void  ESQPARS_JMPTBL_PARSEINI_HandleFontCommand(char *buf);
extern void  ESQPARS_JMPTBL_DST_HandleBannerCommand32_33(long sub, char *buf);
extern void  ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord(char *buf);
extern void  ESQPARS_ApplyRtcBytesAndPersist(char *buf);
extern void  ESQPARS_PersistStateDataAfterCommand(void);
extern unsigned char ESQPARS_ReadLengthWordWithChecksumXor(long seed);
extern char *ESQPARS_ReplaceOwnedString(char *newText, char *owned);

extern short ESQIFF2_ReadSerialRecordIntoBuffer(char *buf, long mode, long extra);
extern short ESQIFF2_ReadSerialSizedTextRecord(char *buf, long mode);
extern void  ESQIFF2_ReadRbfBytesToBuffer(char *buf, long count);
extern void  ESQIFF2_ReadRbfBytesWithXor(char *buf, long count, unsigned char *xor);
extern void  ESQIFF2_ParseGroupRecordAndRefresh(char *buf);
extern void  ESQIFF2_ParseLineHeadTailRecord(char *buf);
extern void  ESQIFF2_ApplyIncomingStatusPacket(char *buf);
extern void  ESQIFF2_ClearPrimaryEntryFlags34To39(void);
extern void  ESQIFF2_ShowVersionMismatchOverlay(void);

extern void  ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(unsigned char *dst, unsigned char *src);
extern long  ESQSHARED_JMPTBL_ESQ_TestBit1Based(unsigned char *bits, long index);
extern long __asm ESQIFF_JMPTBL_MATH_Mulu32(register __d0 long a,
                                            register __d1 long b);
extern unsigned char ESQSHARED_MatchSelectionCodeWithOptionalSuffix(char *buf);
extern void  ESQSHARED_ParseCompactEntryRecord(char *buf);

extern void  ESQDISP_UpdateStatusMaskAndRefresh(long mask, long flag);
extern char *ESQDISP_GetEntryPointerByMode(long index, long mode);
extern char *ESQDISP_GetEntryAuxPointerByMode(long index, long mode);
extern void  ESQDISP_ParseProgramInfoCommandRecord(char *buf);

extern void  ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern void  LADFUNC_ParseBannerEntryData(long cmd, char *buf);
extern void  LOCAVAIL_ParseFilterStateFromBuffer(char *buf, char *state);
extern void  GCOMMAND_ParseCommandOptions(char *buf);
extern void  GCOMMAND_ParseCommandString(char *buf);
extern void  GCOMMAND_ParsePPVCommand(char *buf);
extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(char *set, long ch);
extern void  GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(char *rp, long x, long y,
                                                           char *text);

void ESQPARS_ConsumeRbfByteAndDispatchCommand(void)
{
    unsigned char cmd;
    unsigned char seed;
    unsigned char sub;
    unsigned char one;
    unsigned char readByte;
    unsigned char checkByte;
    unsigned char runningXor;
    unsigned char trailer;
    unsigned char titleMatched;
    unsigned char bitmapClear;
    unsigned char width;
    unsigned char slot;
    unsigned char firstSlot;
    unsigned char lastSlot;
    unsigned char bitmap[8];
    /* The sparse 'p' path reads width * count bytes, up to 3 * 48 = 144. The
     * original's buffer is at -212(A5) in a 232-byte frame, so it has about
     * 204 bytes of room. Sizing this 8 was a stack smash. */
    unsigned char payload[204];
    unsigned char titleKey[16];
    unsigned char rowBits[8];
    char *entry;
    char *title;
    char *rp;
    char *font;
    long groupId;
    long entryCount;
    long index;
    long mode;
    long count;
    long source;
    long row;
    long y;

    cmd = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();

    if (ESQPARS_CommandPreambleArmedFlag == 0) {
        if (cmd == 0x55) {
            ESQPARS_Preamble55SeenFlag = 1;
            ESQPARS_CommandPreambleArmedFlag = 0;
        } else if (cmd == 0xaa && ESQPARS_Preamble55SeenFlag == 1) {
            ESQPARS_Preamble55SeenFlag = 0;
            ESQPARS_CommandPreambleArmedFlag = 1;
        } else {
            ESQPARS_Preamble55SeenFlag = ESQPARS_CommandPreambleArmedFlag = 0;
        }
        return;
    }

    /* Before a selection code is matched, only the three selection commands
     * are accepted. */
    if (ESQPARS_CommandPreambleArmedFlag == 1 && ESQPARS_SelectionMatchCode == 0) {
        if (cmd == 65) {
            ESQIFF_RecordLength =
                ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 0, 0);
            if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                    ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
                != (long)ESQIFF_RecordChecksumByte) {
                DATACErrs++;
            } else if (ESQIFF_RecordLength > 16) {
                ESQIFF_LineErrorCount++;
            } else {
                ESQPARS_SelectionMatchCode = (short)
                    ESQSHARED_MatchSelectionCodeWithOptionalSuffix(ESQIFF_RecordBufferPtr);
                if (ESQPARS_SelectionMatchCode == 1) {
                    ESQPARS_ResetArmedFlag = 1;
                    ESQDISP_UpdateStatusMaskAndRefresh(2, 1);
                    DISKIO2_InteractiveTransferArmedFlag = 1;
                    ESQIFF_ParseAttemptCount++;
                }
            }
        } else if (cmd == 87) {
            ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord((long)cmd);
        } else if (cmd == 119) {
            ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList((long)cmd);
        }
        ESQPARS_Preamble55SeenFlag = ESQPARS_CommandPreambleArmedFlag = 0;
        return;
    }

    if (ESQPARS_CommandPreambleArmedFlag != 1 || ESQPARS_SelectionMatchCode != 1)
        return;

    switch (cmd) {

    case 33:                                    /* '!' retitle a slot range */
        titleMatched = 0;
        runningXor = 0xde;
        ESQIFF_ParseAttemptCount++;

        ESQIFF2_ReadRbfBytesWithXor(&readByte, 1, &runningXor);
        groupId = (long)readByte;
        ESQIFF2_ReadRbfBytesWithXor(&readByte, 1, &runningXor);
        firstSlot = readByte;
        ESQIFF2_ReadRbfBytesWithXor(&readByte, 1, &runningXor);
        lastSlot = readByte;

        if (firstSlot < 1 || lastSlot > 48 || lastSlot < firstSlot) {
            titleMatched = 0;
            break;
        }
        if ((long)TEXTDISP_PrimaryGroupCode != groupId
            && groupId != (long)TEXTDISP_SecondaryGroupCode) {
            titleMatched = 0;
            break;
        }

        index = 0;
        ESQIFF2_ReadRbfBytesWithXor(&readByte, 1, &runningXor);
        while (readByte != 0 && readByte != 18 && readByte != 32 && index < 6) {
            titleKey[index] = readByte;
            index++;
            ESQIFF2_ReadRbfBytesWithXor(&readByte, 1, &runningXor);
        }
        titleKey[index] = 0;
        while (readByte != 0)
            ESQIFF2_ReadRbfBytesWithXor(&readByte, 1, &runningXor);

        ESQIFF2_ReadRbfBytesToBuffer((char *)&checkByte, 1);
        if (runningXor != checkByte) {
            titleMatched = 0;
            break;
        }
        titleMatched = 0;

        if (firstSlot == 89) {                /* 'Y' means the whole range */
            lastSlot = 0x30;
            firstSlot = 1;
        }

        if (groupId == (long)TEXTDISP_SecondaryGroupCode
            && TEXTDISP_SecondaryGroupPresentFlag == 1) {
            entryCount = (long)TEXTDISP_SecondaryGroupEntryCount;
            mode = 2;
        } else if (groupId == (long)TEXTDISP_PrimaryGroupCode) {
            entryCount = (long)TEXTDISP_PrimaryGroupEntryCount;
            mode = 1;
        } else {
            break;
        }

        entry = 0;
        title = 0;
        for (index = 0; index < entryCount; index++) {
            entry = ESQDISP_GetEntryPointerByMode(index, mode);
            title = ESQDISP_GetEntryAuxPointerByMode(index, mode);
            if (strcmp((char *)titleKey, title) == 0) {
                titleMatched = 1;
                break;
            }
        }
        if (titleMatched != 1)
            break;

        if (firstSlot == 1 && lastSlot == 48)
            BYTE_AT(entry, 40) &= 0x7f;

        for (slot = firstSlot; slot <= lastSlot; slot++) {
            LONG_AT(title, 56 + (long)slot * 4) =
                (long)ESQPARS_ReplaceOwnedString(0,
                    (char *)LONG_AT(title, 56 + (long)slot * 4));
            BYTE_AT(title, 7 + (long)slot) = 1;
        }
        break;

    case 37:                                    /* '%' arm the state save */
        ESQIFF_ParseAttemptCount++;
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        checkByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        ESQIFF_RecordChecksumByte = checkByte;
        if (checkByte == 218)
            ESQPARS_PersistOnNextBoxOffFlag = 1;
        else
            DATACErrs++;
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 61:                                    /* '=', 'H', 'h': file transfer */
    case 72:
    case 104:
        ESQIFF_ParseAttemptCount++;
        ESQPARS_ResetArmedFlag = 0;
        if (DISKIO2_InteractiveTransferArmedFlag != 1)
            break;
        ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer(cmd == 61 ? 1L : 0L);
        break;

    case 67:                                    /* 'C' group record */
        ESQIFF_ParseAttemptCount++;
        ESQIFF_RecordLength =
            ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 1, 6);
        if (ESQIFF_RecordLength == 0)
            return;
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
            != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else if (ESQIFF_StatusPacketReadyFlag == 1)
            ESQIFF2_ParseGroupRecordAndRefresh(ESQIFF_RecordBufferPtr);
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 68:                                    /* 'D' diagnostics block */
        ESQIFF_ParseAttemptCount++;
        ESQIFF2_ReadRbfBytesToBuffer(ESQIFF_RecordBufferPtr, 256);
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, 256) != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 69:                                    /* 'E' selection suffix */
        ESQIFF_ParseAttemptCount++;
        ESQIFF_RecordLength =
            ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 0, 0);
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
            != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else
            strcpy(ESQPARS_SelectionSuffixBuffer, ESQIFF_RecordBufferPtr);
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 70:                                    /* 'F' status packet */
        ESQIFF_ParseAttemptCount++;
        ESQIFF2_ReadRbfBytesToBuffer(ESQIFF_RecordBufferPtr, 21);
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, 20) != (long)ESQIFF_RecordChecksumByte) {
            DATACErrs++;
        } else if (BYTE_AT(ESQIFF_RecordBufferPtr, 0) != 65
                   && BYTE_AT(ESQIFF_RecordBufferPtr, 0) != 66) {
            DATACErrs++;
        } else if (BYTE_AT(ESQIFF_RecordBufferPtr, 1) < 65
                   || BYTE_AT(ESQIFF_RecordBufferPtr, 1) >= 74) {
            DATACErrs++;
        } else {
            ESQIFF2_ApplyIncomingStatusPacket(ESQIFF_RecordBufferPtr);
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 73:                                    /* 'I' digit label */
        ESQIFF_ParseAttemptCount++;
        ESQIFF_RecordLength =
            ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 0, 0);
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
            != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else if (ESQIFF_RecordLength > 39)
            ESQIFF_LineErrorCount++;
        else
            ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay(ESQIFF_RecordBufferPtr);
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 75:                                    /* 'K' clock set */
        if (ED_DiagnosticsViewMode == 1)
            return;
        ESQIFF_ParseAttemptCount++;
        ESQIFF2_ReadRbfBytesToBuffer(ESQIFF_RecordBufferPtr, 8);
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, 8) != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else if (BYTE_AT(ESQIFF_RecordBufferPtr, 0) >= 7)
            DATACErrs++;
        else if (BYTE_AT(ESQIFF_RecordBufferPtr, 1) >= 12)
            DATACErrs++;
        else if (BYTE_AT(ESQIFF_RecordBufferPtr, 6) >= 60)
            DATACErrs++;
        else if (CTASKS_STR_1 != 50)
            DATACErrs++;
        else
            ESQPARS_ApplyRtcBytesAndPersist(ESQIFF_RecordBufferPtr);
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 76:                                    /* 'L' and 't' banner entry */
    case 116:
        ESQIFF_ParseAttemptCount++;
        ESQIFF_RecordLength =
            ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 0, 0);
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
            != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else if (ESQIFF_RecordLength > 0x130)
            ESQIFF_LineErrorCount++;
        else
            LADFUNC_ParseBannerEntryData((long)cmd, ESQIFF_RecordBufferPtr);
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 77:                                    /* 'M' acknowledge only */
        ESQIFF_ParseAttemptCount++;
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 79:                                    /* 'O' clear primary flags */
        ESQIFF_ParseAttemptCount++;
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        checkByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (checkByte == 176)
            ESQIFF2_ClearPrimaryEntryFlags34To39();
        else
            DATACErrs++;
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 80:                                    /* 'P' compact entry record */
        ESQIFF_ParseAttemptCount++;
        ESQIFF_RecordLength =
            ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 2, 0);
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
            != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else if (ESQIFF_RecordLength > 0x1ff)
            ESQIFF_LineErrorCount++;
        else
            ESQSHARED_ParseCompactEntryRecord(ESQIFF_RecordBufferPtr);
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 82:                                    /* 'R' reset: never returns */
        ESQIFF_ParseAttemptCount++;
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        checkByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (checkByte != 0xad) {
            DATACErrs++;
            ESQPARS_ResetArmedFlag = 0;
            break;
        }
        if (ESQPARS_ResetArmedFlag != 1)
            break;
        ESQ_GlobalTickCounter = 21000;
        LONG_AT(Global_REF_RASTPORT_1, 4) = (long)Global_REF_696_400_BITMAP;
        for (;;) {
            rp = Global_REF_RASTPORT_1;
            font = (char *)LONG_AT(rp, 52);
            y = (34L - (long)*(short *)(font + 26)) / 2;
            y += (long)*(unsigned short *)(font + 26);
            y += 29;
            GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(rp, 40, y,
                Global_STR_RESET_COMMAND_RECEIVED);
        }

    case 86:                                    /* 'V' version overlay */
        ESQIFF_ParseAttemptCount++;
        ESQIFF_RecordLength =
            ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 0, 0);
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
            != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else if (ESQIFF_RecordLength > 0x8b)
            ESQIFF_LineErrorCount++;
        else
            ESQIFF2_ShowVersionMismatchOverlay();
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 87:                                    /* 'W' verify one record */
        ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord((long)cmd);
        break;

    case 99:                                    /* 'c' program info */
        ESQIFF_ParseAttemptCount++;
        ESQIFF_RecordLength =
            ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 1, 0);
        if (ESQIFF_RecordLength == 0)
            DATACErrs++;
        else if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                     ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
                 != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else
            ESQDISP_ParseProgramInfoCommandRecord(ESQIFF_RecordBufferPtr);
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 102:                                   /* 'f' configuration record */
        ESQFUNC_WaitForClockChangeAndServiceUi();
        sub = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        seed = (unsigned char)(cmd ^ sub);
        seed = ESQPARS_ReadLengthWordWithChecksumXor((long)seed);
        if (ESQIFF_RecordLength >= 0x2328) {
            ESQIFF_LineErrorCount++;
            break;
        }
        ESQIFF_RecordLength = ESQIFF_RecordLength - 1;
        ESQIFF2_ReadRbfBytesToBuffer(ESQIFF_RecordBufferPtr,
                                     (long)(short)ESQIFF_RecordLength);
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if ((unsigned char)ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)seed,
                ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
            != ESQIFF_RecordChecksumByte) {
            DATACErrs++;
            ESQPARS_ResetArmedFlag = 0;
            break;
        }
        ESQIFF_ParseAttemptCount++;
        ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer(ESQIFF_RecordBufferPtr,
                                                (long)ESQIFF_RecordLength);
        ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle(ESQIFF_RecordBufferPtr,
                                                     (long)ESQIFF_RecordLength);
        break;

    case 103:                                   /* 'g' filter and banner group */
        ESQFUNC_WaitForClockChangeAndServiceUi();
        sub = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        seed = (unsigned char)(cmd ^ sub);

        if (sub == 49) {                        /* '1' availability filter */
            ESQFUNC_WaitForClockChangeAndServiceUi();
            one = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
            BYTE_AT(ESQIFF_RecordBufferPtr, 0) = one;
            ESQIFF_RecordLength = (unsigned short)
                (ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr + 1, 0, 0) + 1);
            if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)seed,
                    ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
                != (long)ESQIFF_RecordChecksumByte) {
                DATACErrs++;
                break;
            }
            if (BYTE_AT(ESQIFF_RecordBufferPtr, 0) == TEXTDISP_PrimaryGroupCode)
                LOCAVAIL_ParseFilterStateFromBuffer(ESQIFF_RecordBufferPtr,
                                                    LOCAVAIL_PrimaryFilterState);
            else if (BYTE_AT(ESQIFF_RecordBufferPtr, 0) == TEXTDISP_SecondaryGroupCode)
                LOCAVAIL_ParseFilterStateFromBuffer(ESQIFF_RecordBufferPtr,
                                                    LOCAVAIL_SecondaryFilterState);
            ESQIFF_ParseAttemptCount++;
            break;
        }

        if (GROUP_AS_JMPTBL_STR_FindCharPtr(ESQPARS_BannerSubcommandSet,
                                            (long)sub) != 0) {
            ESQIFF_RecordLength =
                ESQIFF2_ReadSerialSizedTextRecord(ESQIFF_RecordBufferPtr, 2);
            if (ESQIFF_RecordLength == 0) {
                ESQIFF_LineErrorCount++;
                break;
            }
            if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)seed,
                    ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
                != (long)ESQIFF_RecordChecksumByte) {
                DATACErrs++;
                break;
            }
            ESQPARS_JMPTBL_DST_HandleBannerCommand32_33((long)(char)sub,
                                                        ESQIFF_RecordBufferPtr);
            ESQIFF_ParseAttemptCount++;
            break;
        }

        if (sub == 53 || sub == 54 || sub == 55 || sub == 56) {
            ESQFUNC_WaitForClockChangeAndServiceUi();
            ESQIFF_RecordLength =
                ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 0, 0);
            if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)seed,
                    ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
                != (long)ESQIFF_RecordChecksumByte) {
                DATACErrs++;
                break;
            }
            if (sub == 53)
                ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord(ESQIFF_RecordBufferPtr);
            else if (sub == 54)
                GCOMMAND_ParseCommandOptions(ESQIFF_RecordBufferPtr);
            else if (sub == 55)
                GCOMMAND_ParseCommandString(ESQIFF_RecordBufferPtr);
            else
                GCOMMAND_ParsePPVCommand(ESQIFF_RecordBufferPtr);
            ESQIFF_ParseAttemptCount++;
        }
        break;

    case 105:                                   /* 'i' copy label to global */
        ESQIFF_ParseAttemptCount++;
        ESQIFF_RecordLength =
            ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 0, 0);
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
            != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else if (ESQIFF_RecordLength > 39)
            ESQIFF_LineErrorCount++;
        else
            ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal(ESQIFF_RecordBufferPtr);
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 106:                                   /* 'j' line head and tail */
        ESQIFF_ParseAttemptCount++;
        ESQIFF_RecordLength =
            ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 2, 0);
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
            != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else if (ESQIFF_RecordLength > 0x1f4)
            ESQIFF_LineErrorCount++;
        else
            ESQIFF2_ParseLineHeadTailRecord(ESQIFF_RecordBufferPtr);
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 112:                                   /* 'p' per-row attribute paint */
        titleMatched = 0;
        bitmapClear = 1;
        runningXor = 0x8f;
        ESQIFF_ParseAttemptCount++;

        ESQIFF2_ReadRbfBytesWithXor(&readByte, 1, &runningXor);
        groupId = (long)readByte;
        ESQIFF2_ReadRbfBytesWithXor(&readByte, 1, &runningXor);

        index = 0;
        for (;;) {
            titleKey[index] = readByte;
            if (readByte == 18 || index >= 8)
                break;
            ESQIFF2_ReadRbfBytesWithXor(&readByte, 1, &runningXor);
            index++;
        }
        titleKey[index] = 0;

        if (groupId == (long)TEXTDISP_SecondaryGroupCode
            && TEXTDISP_SecondaryGroupPresentFlag == 1)
            entryCount = (long)TEXTDISP_SecondaryGroupEntryCount;
        else if (groupId == (long)TEXTDISP_PrimaryGroupCode)
            entryCount = (long)TEXTDISP_PrimaryGroupEntryCount;
        else
            break;

        ESQIFF2_ReadRbfBytesWithXor(bitmap, 6, &runningXor);
        for (index = 0; index < 6; index++)
            if (bitmap[index] != 0)
                bitmapClear = 0;
        ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(rowBits, bitmap);

        entry = 0;
        title = 0;
        for (index = 0; index < entryCount; index++) {
            if (groupId == (long)TEXTDISP_SecondaryGroupCode
                && TEXTDISP_SecondaryGroupPresentFlag == 1) {
                entry = TEXTDISP_SecondaryEntryPtrTable[index];
                title = TEXTDISP_SecondaryTitlePtrTable[index];
            } else {
                entry = TEXTDISP_PrimaryEntryPtrTable[index];
                title = TEXTDISP_PrimaryTitlePtrTable[index];
            }
            if (strcmp((char *)titleKey, title) == 0) {
                titleMatched = 1;
                break;
            }
        }

        ESQIFF2_ReadRbfBytesWithXor(&width, 1, &runningXor);
        if (width < 1 || width > 3)
            titleMatched = 0;

        if (bitmapClear != 0 && titleMatched != 0) {
            /* Every row carries the same attribute bytes. */
            ESQIFF2_ReadRbfBytesWithXor(payload, (long)width, &runningXor);
            ESQIFF2_ReadRbfBytesWithXor(&trailer, 1, &runningXor);
            if (trailer != 0)
                titleMatched = 0;
            ESQIFF2_ReadRbfBytesToBuffer((char *)&checkByte, 1);
            if (runningXor != checkByte)
                titleMatched = 0;
            if (titleMatched == 0) {
                ESQPARS_ResetArmedFlag = 0;
                break;
            }
            if (width > 0 && payload[0] >= 5 && payload[0] <= 10)
                BYTE_AT(entry, 40) |= 1;
            for (row = 0; row < 49; row++) {
                if (width > 0)
                    BYTE_AT(title, row + 0xfc) = payload[0];
                if (width > 1)
                    BYTE_AT(title, row + 0x12d) = payload[1];
                if (width > 2)
                    BYTE_AT(title, row + 0x15e) = payload[2];
            }
            ESQPARS_ResetArmedFlag = 0;
            break;
        }

        /* Only the rows named by the bitmap carry attribute bytes. */
        if (titleMatched == 0) {
            ESQPARS_ResetArmedFlag = 0;
            break;
        }
        count = 0;
        for (row = 1; row < 49; row++)
            if (ESQSHARED_JMPTBL_ESQ_TestBit1Based(rowBits, row) == -1)
                count++;

        ESQIFF2_ReadRbfBytesWithXor(payload,
            (long)(short)ESQIFF_JMPTBL_MATH_Mulu32((long)width, count), &runningXor);
        ESQIFF2_ReadRbfBytesWithXor(&trailer, 1, &runningXor);
        if (trailer != 0)
            titleMatched = 0;
        ESQIFF2_ReadRbfBytesToBuffer((char *)&checkByte, 1);
        if (runningXor != checkByte)
            titleMatched = 0;
        if (titleMatched == 0) {
            ESQPARS_ResetArmedFlag = 0;
            break;
        }

        source = 0;
        for (row = 1; row < 49; row++) {
            if (ESQSHARED_JMPTBL_ESQ_TestBit1Based(rowBits, row) != -1)
                continue;
            if (width > 0) {
                BYTE_AT(title, row + 0xfc) = payload[source];
                if (payload[source] >= 5 && payload[source] <= 10)
                    BYTE_AT(entry, 40) |= 1;
            }
            source++;
            if (width > 1) {
                BYTE_AT(title, row + 0x12d) = payload[source];
                source++;
            }
            if (width > 2) {
                BYTE_AT(title, row + 0x15e) = payload[source];
                source++;
            }
        }
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 118:                                   /* 'v' aligned listing block */
        ESQIFF_ParseAttemptCount++;
        ESQIFF_RecordLength =
            ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 1, 0);
        if (ESQIFF_RecordLength == 0)
            return;
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
            != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else if (BYTE_AT(ESQIFF_RecordBufferPtr, 1) == 49)
            ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock(ESQIFF_RecordBufferPtr);
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 119:                                   /* 'w' verify a list */
        ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList((long)cmd);
        break;

    case 120:                                   /* 'x' font command */
        ESQIFF_ParseAttemptCount++;
        ESQIFF_RecordLength =
            ESQIFF2_ReadSerialRecordIntoBuffer(ESQIFF_RecordBufferPtr, 0, 0);
        if (ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte((long)cmd,
                ESQIFF_RecordBufferPtr, (long)ESQIFF_RecordLength)
            != (long)ESQIFF_RecordChecksumByte)
            DATACErrs++;
        else if (ESQIFF_RecordLength > 80)
            DATACErrs++;
        else
            ESQPARS_JMPTBL_PARSEINI_HandleFontCommand(ESQIFF_RecordBufferPtr);
        ESQPARS_ResetArmedFlag = 0;
        break;

    case 187:                                   /* box off */
        ESQIFF_ParseAttemptCount++;
        ESQFUNC_WaitForClockChangeAndServiceUi();
        cmd = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        ESQFUNC_WaitForClockChangeAndServiceUi();
        checkByte = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        ESQIFF_RecordChecksumByte = checkByte;
        if (cmd != 0xbb || checkByte != 0xff) {
            DATACErrs++;
            ESQPARS_ResetArmedFlag = 0;
            break;
        }
        if (ESQPARS_PersistOnNextBoxOffFlag != 0) {
            ESQPARS_PersistStateDataAfterCommand();
            ESQPARS_PersistOnNextBoxOffFlag = 0;
        }
        ESQPARS_SelectionMatchCode = 0;
        ESQDISP_UpdateStatusMaskAndRefresh(2, 0);
        break;

    default:
        break;
    }

    ESQPARS_Preamble55SeenFlag = ESQPARS_CommandPreambleArmedFlag = 0;
}
