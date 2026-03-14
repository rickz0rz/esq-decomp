#include <exec/types.h>
extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern LONG SCRIPT_ReadNextRbfByte(void);
extern LONG DISKIO_WriteBytesToOutputHandleGuarded(const void *data, UWORD byteCount);
extern void ESQIFF2_ShowAttentionOverlay(LONG arg);

extern UBYTE DISKIO2_TransferBlockSequence;
extern UBYTE DISKIO2_TransferXorChecksumByte;
extern UBYTE DISKIO2_TransferBlockLength;
extern UWORD DISKIO2_TransferBufferedByteCount;
extern UBYTE *DISKIO2_TransferBlockBufferPtr;
extern ULONG DISKIO2_TransferCrcErrorCount;
extern UWORD ESQIFF_ParseAttemptCount;
extern UBYTE ESQIFF_RecordChecksumByte;
extern ULONG DISKIO2_TransferCrc32Table[256];
extern char DISKIO2_TransferFilenameBuffer[];
extern UBYTE BRUSH_SnapshotHeader[];

LONG DISKIO2_ReceiveTransferBlocksToFile(UBYTE verifyCrc32)
{
    ULONG crcTableLocal[256];
    ULONG crcState = 0xFFFFFFFFUL;
    ULONG receivedCrc = 0;
    UBYTE crcMismatch = 0;
    ULONG i;
    UWORD buffered;
    UWORD payloadIndex;
    UBYTE seqByte;
    UBYTE nextByte;

    for (i = 0; i < 256UL; i++) {
        crcTableLocal[i] = DISKIO2_TransferCrc32Table[i];
    }

    ESQFUNC_WaitForClockChangeAndServiceUi();
    seqByte = (UBYTE)SCRIPT_ReadNextRbfByte();
    ESQIFF_ParseAttemptCount = (UWORD)(ESQIFF_ParseAttemptCount + 1U);

    if (seqByte != DISKIO2_TransferBlockSequence) {
        if ((UBYTE)(seqByte + 1U) == DISKIO2_TransferBlockSequence) {
            return 0;
        }

        {
            char *src = DISKIO2_TransferFilenameBuffer;
            UBYTE *dst = BRUSH_SnapshotHeader;
            do {
                *dst++ = (UBYTE)*src;
            } while (*src++ != 0);
        }
        ESQIFF2_ShowAttentionOverlay(1);
        return 1;
    }

    DISKIO2_TransferXorChecksumByte ^= seqByte;
    ESQFUNC_WaitForClockChangeAndServiceUi();
    DISKIO2_TransferBlockLength = (UBYTE)SCRIPT_ReadNextRbfByte();

    if (DISKIO2_TransferBlockLength == 0U) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        ESQIFF_RecordChecksumByte = (UBYTE)SCRIPT_ReadNextRbfByte();
        if (ESQIFF_RecordChecksumByte != DISKIO2_TransferXorChecksumByte) {
            crcMismatch = 1;
            DISKIO2_TransferCrcErrorCount++;
            return 0;
        }

        if (DISKIO2_TransferBufferedByteCount > 0U) {
            if (DISKIO_WriteBytesToOutputHandleGuarded(
                    DISKIO2_TransferBlockBufferPtr,
                    DISKIO2_TransferBufferedByteCount) != 0) {
                return 3;
            }
            DISKIO2_TransferBufferedByteCount = 0;
        }
        return -1;
    }

    DISKIO2_TransferXorChecksumByte ^= DISKIO2_TransferBlockLength;
    buffered = DISKIO2_TransferBufferedByteCount;
    for (payloadIndex = 0; payloadIndex < (UWORD)DISKIO2_TransferBlockLength; payloadIndex++) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        nextByte = (UBYTE)SCRIPT_ReadNextRbfByte();
        DISKIO2_TransferXorChecksumByte ^= nextByte;

        crcState = crcTableLocal[(UBYTE)(nextByte ^ (UBYTE)crcState)] ^ (crcState >> 8);
        DISKIO2_TransferBlockBufferPtr[buffered] = nextByte;
        buffered = (UWORD)(buffered + 1U);
    }

    if (verifyCrc32 != 0U) {
        receivedCrc = 0;
        for (i = 0; i < 4UL; i++) {
            ESQFUNC_WaitForClockChangeAndServiceUi();
            nextByte = (UBYTE)SCRIPT_ReadNextRbfByte();
            DISKIO2_TransferXorChecksumByte ^= nextByte;
            receivedCrc = (receivedCrc << 8) | (ULONG)nextByte;
        }
        if (crcState != receivedCrc) {
            crcMismatch = 1;
        }
    }

    if (crcMismatch != 0U) {
        DISKIO2_TransferCrcErrorCount++;
        return 0;
    }

    ESQFUNC_WaitForClockChangeAndServiceUi();
    ESQIFF_RecordChecksumByte = (UBYTE)SCRIPT_ReadNextRbfByte();
    if (ESQIFF_RecordChecksumByte != DISKIO2_TransferXorChecksumByte) {
        return 0;
    }

    DISKIO2_TransferBufferedByteCount = buffered;
    if (buffered >= 0x1000U) {
        if (DISKIO_WriteBytesToOutputHandleGuarded(DISKIO2_TransferBlockBufferPtr, buffered) != 0) {
            return 2;
        }
        DISKIO2_TransferBufferedByteCount = 0;
    }

    DISKIO2_TransferBlockSequence = (UBYTE)(DISKIO2_TransferBlockSequence + 1U);
    DISKIO2_TransferCrcErrorCount = 0;
    return 0;
}
