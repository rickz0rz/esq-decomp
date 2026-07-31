/* RESTORES: DISKIO2_HandleInteractiveFileTransfer
 * MODULE:   modules/groups/a/h/diskio2_p1_diskio2_handleinteractivefiletransfer.s
 * STATUS:   behavioural
 *
 * Receives a file over the serial link and installs it. 1428 bytes, and it reads
 * as a protocol: filename, optional size token, name checksum, then a block loop
 * driven by three-byte sync markers.
 *
 * THE FILE IS RECEIVED TO RAM: AND THEN COPIED. The filename arrives with its own
 * four-character volume prefix; the code copies the whole name, then overwrites
 * the first four characters with "RAM:" to build the staging path, and keeps the
 * original prefix separately to Lock() for the free-space check. On success it
 * deletes the destination, shells out a copy from the staging path to it, and
 * deletes the staging file.
 *
 * THE XOR CHECKSUM SEED DEPENDS ON THE MODE, 0xC2 or 0xB7, and it is re-seeded
 * from the SAME pair when the block loop sees its marker. So the seed is not a
 * constant of the protocol, it is a function of which marker arrived.
 *
 * A RESULT OF -1 IS THE SUCCESS PATH. `if (result != -1) goto error` is what the
 * original branches on, so -1 means "transfer complete" here and every other value
 * is a fault code handed to the diagnostics printer. That reads backwards and is
 * transcribed as-is.
 *
 * THE FREE-SPACE LIMIT IS ONLY COMPUTED IN MODE 1, and only if both the Lock and
 * the InfoData allocation succeed. When any of that fails the limit keeps whatever
 * the uninitialised local held -- the original does not zero it. So the size check
 * below it is not reliably a check at all. Reproduced rather than fixed.
 *
 * THE READ MODE FLAGS ARE SAVED AND RESTORED TWICE, once around the buffer
 * allocation and once around the teardown, and the second save overwrites the
 * first. Only the second restore runs, so the value the function leaves behind is
 * the one that was live at teardown, not the one on entry.
 *
 * MEASURED: 1428 emitted against 1428 in the original -- EQUAL SIZE -- over 62
 * differing regions.
 *
 * AGENTS.md rule 1 applies and is worth restating here: equal size is NOT evidence
 * of fidelity, and 62 regions on a 1428-byte body says the code generator laid this
 * function out differently while happening to land on the same total. The agreement
 * is a coincidence of the frame class cancelling against the call class, not a
 * result. Judge this restoration by the region count, not the zero.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....              JSR (d16,PC)
 *   got:     61000000              BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame-and-large-locals
 *   ref:     4e55ff60 ... 4e5d     LINK.W A5,#-160 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: no-return-value-on-the-fall-through-path
 *   ref:     the shared exit returns whatever D0 held
 *   got:     the same, by falling off the end
 *   summary: the two early failures return -2 and -1 explicitly; the shared exit
 *            does not set D0 at all. Reproduced by falling off the end rather than
 *            by inventing a value.
 *   scope:   this function.
 *   retest:  n/a.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: NOT itemised. Recorded as a known-unknown per AGENTS.md rule 3.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <graphics/rastport.h>
#include <string.h>

#include "esq-dos.h"

extern char  CTASKS_EXT_GRF[];
extern char  Global_STR_SPECIAL_NGAD[];
extern char  Global_STR_FILENAME[];
extern char  Global_STR_STORED[];
extern char  Global_STR_RAM[];
extern char  Global_STR_COPY_NIL[];
extern char  Global_STR_DISK_0_IS_FULL_WITH_ERRORS_FORMATTED[];
extern char  Global_STR_DISKIO2_C_24[];
extern char  Global_STR_DISKIO2_C_25[];
extern char  Global_STR_DISKIO2_C_26[];
extern char  Global_STR_DISKIO2_C_27[];
extern char  DISKIO2_STR_DiagTransferStatusClearLine210[];
extern char  DISKIO2_STR_DiagTransferStatusClearLine240[];
extern char  DISKIO2_STR_ShellCommandArgSeparator[];

extern unsigned char DISKIO2_TransferXorChecksumByte;
extern char  DISKIO2_TransferFilenameBuffer[];
extern char  DISKIO2_TransferFilenameExtPtr[];
extern char  DISKIO2_TransferSizeTokenBuffer[];
extern char  DISKIO2_DiagnosticsDiskUsagePercentBuffer[];
extern char  DISKIO2_DiagnosticsSoftErrorCountBuffer[];
extern long  DISKIO2_TransferCrcErrorCount;
extern unsigned char DISKIO2_TransferBlockSequence;
extern void *DISKIO2_TransferBlockBufferPtr;
extern short DISKIO2_TransferBufferedByteCount;
extern long  DISKIO2_InteractiveTransferArmedFlag;
extern long  DISKIO_WriteFileHandle;
extern short DISKIO_SavedReadModeFlags;
extern short ESQPARS2_ReadModeFlags;
extern unsigned char ESQIFF_RecordChecksumByte;
extern short ED_DiagnosticsScreenActive;
extern struct RastPort *Global_REF_RASTPORT_1;
extern char  BRUSH_SnapshotHeader[];

extern void  GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(long mask,
                                                                long mode);
extern void  GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern unsigned char GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(void);
extern char  GROUP_AH_JMPTBL_ESQ_WildcardMatch(char *pattern, char *text);
extern void  GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(long kind);
extern long  GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3(char *s);
extern void  GROUP_AG_JMPTBL_STRING_CopyPadNul(char *dst, char *src, long n);
extern long  GROUP_AG_JMPTBL_DOS_OpenFileWithMode(char *name, long mode);
extern void  GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, char *src);
extern void  GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, char *fmt, long a, long b);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);
extern void  GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                     void *p, long size);
extern void  DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                           char *text);
extern void  DISKIO_DrawTransferErrorMessageIfDiagnostics(long code);
extern void  DISKIO_ForceUiRefreshIfIdle(void);
extern void  DISKIO_ResetCtrlInputStateIfIdle(void);
extern long  DISKIO_QueryDiskUsagePercentAndSetBufferSize(char *buf);
extern long  DISKIO_QueryVolumeSoftErrorCount(char *buf);
extern long  DISKIO2_ReceiveTransferBlocksToFile(long flag);

long DISKIO2_HandleInteractiveFileTransfer(char mode)
{
    char  targetPath[40];
    char  volName[8];
    char  cmdLine[80];
    struct InfoData *info;
    BPTR  lock;
    long  freeSpace;
    long  requestedSize;
    long  result;
    long  ok;
    long  usage;
    long  softErrors;
    long *cs;
    long *cd;
    unsigned char count;
    unsigned char b;

    GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(4L, 1L);
    ok = 1;
    count = 0;

    if (mode != 0)
        DISKIO2_TransferXorChecksumByte = 0xc2;
    else
        DISKIO2_TransferXorChecksumByte = 0xb7;

    GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();

    while (count < 0x1f) {
        b = GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (b == 0)
            break;
        DISKIO2_TransferFilenameBuffer[count++] = b;
        DISKIO2_TransferXorChecksumByte = DISKIO2_TransferXorChecksumByte ^ b;
        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
    }
    DISKIO2_TransferFilenameBuffer[count] = 0;

    if (count == 13 &&
        GROUP_AH_JMPTBL_ESQ_WildcardMatch(DISKIO2_TransferFilenameExtPtr,
                                          CTASKS_EXT_GRF) == 0) {
        ok = 0;
        if (ED_DiagnosticsScreenActive != 0)
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 240L,
                                          Global_STR_SPECIAL_NGAD);
    }

    /* Stage into RAM: by overwriting the arriving volume prefix. */
    strcpy(targetPath, DISKIO2_TransferFilenameBuffer);
    GROUP_AG_JMPTBL_STRING_CopyPadNul(targetPath, Global_STR_RAM, 4L);

    if (ED_DiagnosticsScreenActive != 0) {
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 180L,
                                      Global_STR_FILENAME);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 205L, 180L,
                                      DISKIO2_TransferFilenameBuffer);
    }

    GROUP_AG_JMPTBL_STRING_CopyPadNul(volName, DISKIO2_TransferFilenameBuffer,
                                      4L);
    volName[4] = 0;

    if (mode != 0) {
        count = 0;
        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        while (count < 8) {
            b = GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
            if (b == 0)
                break;
            DISKIO2_TransferSizeTokenBuffer[count++] = b;
            DISKIO2_TransferXorChecksumByte =
                DISKIO2_TransferXorChecksumByte ^ b;
            GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        }
        DISKIO2_TransferSizeTokenBuffer[count] = 0;

        lock = Lock(volName, -2L);
        if (lock != 0) {
            info = (struct InfoData *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_DISKIO2_C_24, 1312, (long)sizeof(struct InfoData),
                MEMF_CLEAR);
            if (info != 0) {
                if (Info(lock, info) != 0)
                    freeSpace = ((0x6deL - info->id_NumBlocksUsed) << 8) * 2 -
                                0x1000;
                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_DISKIO2_C_25, 1318, info,
                    (long)sizeof(struct InfoData));
            }
            UnLock(lock);
        }

        requestedSize = GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3(
            DISKIO2_TransferSizeTokenBuffer);
        if (requestedSize > freeSpace) {
            strcpy(BRUSH_SnapshotHeader, DISKIO2_TransferFilenameBuffer);
            GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(2L);
            DISKIO2_InteractiveTransferArmedFlag = 0;
            GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(4L, 0L);
            return -2;
        }
    }

    GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
    ESQIFF_RecordChecksumByte = GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
    if (ESQIFF_RecordChecksumByte != DISKIO2_TransferXorChecksumByte)
        goto clearOverlay;
    if (ok != 1)
        goto clearOverlay;

    DISKIO_WriteFileHandle = GROUP_AG_JMPTBL_DOS_OpenFileWithMode(targetPath,
                                                                 MODE_NEWFILE);
    if (DISKIO_WriteFileHandle == 0) {
        DISKIO_DrawTransferErrorMessageIfDiagnostics(5L);
        GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(4L, 0L);
        return -1;
    }

    DISKIO_SavedReadModeFlags = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = 0x100;
    DISKIO2_TransferCrcErrorCount = 0;
    DISKIO2_TransferBlockSequence = 0;
    DISKIO2_TransferBlockBufferPtr = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISKIO2_C_26, 1389, 4352, MEMF_PUBLIC | MEMF_CLEAR);
    ESQPARS2_ReadModeFlags = DISKIO_SavedReadModeFlags;
    DISKIO2_TransferBufferedByteCount = 0;

    for (;;) {
        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        b = GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (b != 85)
            continue;

        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        b = GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (b != 170)
            continue;

        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        b = GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();

        if (b == 72 || b == 61) {
            if (b == 61)
                DISKIO2_TransferXorChecksumByte = 0xc2;
            else
                DISKIO2_TransferXorChecksumByte = 0xb7;
            result = DISKIO2_ReceiveTransferBlocksToFile((b == 61) ? 1L : 0L);
            if (result == 0)
                continue;
            break;
        }

        if (b != 187)
            continue;
        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        b = GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (b != 187)
            continue;
        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        b = GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (b != 0)
            continue;
        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        b = GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (b != 255)
            continue;
        result = 4;
        break;
    }

    DISKIO_SavedReadModeFlags = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = 0x100;
    Close(DISKIO_WriteFileHandle);
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_27, 1499,
                                            DISKIO2_TransferBlockBufferPtr,
                                            4352);

    if (ED_DiagnosticsScreenActive != 0) {
        DISPLIB_DisplayTextAtPosition(
            Global_REF_RASTPORT_1, 40L, 210L,
            DISKIO2_STR_DiagTransferStatusClearLine210);
        DISPLIB_DisplayTextAtPosition(
            Global_REF_RASTPORT_1, 40L, 240L,
            DISKIO2_STR_DiagTransferStatusClearLine240);
    }

    if (result == -1) {
        DeleteFile(DISKIO2_TransferFilenameBuffer);
        DISKIO_ForceUiRefreshIfIdle();

        cs = (long *)Global_STR_COPY_NIL;
        cd = (long *)cmdLine;
        *cd++ = *cs++;
        *cd++ = *cs++;
        *cd++ = *cs++;

        GROUP_AI_JMPTBL_STRING_AppendAtNull(cmdLine, targetPath);
        GROUP_AI_JMPTBL_STRING_AppendAtNull(
            cmdLine, DISKIO2_STR_ShellCommandArgSeparator);
        GROUP_AI_JMPTBL_STRING_AppendAtNull(cmdLine,
                                            DISKIO2_TransferFilenameBuffer);
        Execute(cmdLine, 0L, 0L);
        DeleteFile(targetPath);
        DISKIO_ResetCtrlInputStateIfIdle();

        if (ED_DiagnosticsScreenActive != 0)
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 180L,
                                          Global_STR_STORED);
    } else {
        DISKIO_DrawTransferErrorMessageIfDiagnostics(result);
        DeleteFile(targetPath);
    }

    ESQPARS2_ReadModeFlags = DISKIO_SavedReadModeFlags;

clearOverlay:
    DISKIO2_InteractiveTransferArmedFlag = 0;
    GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(4L, 0L);

    if (ED_DiagnosticsScreenActive != 0) {
        usage = DISKIO_QueryDiskUsagePercentAndSetBufferSize(
            DISKIO2_DiagnosticsDiskUsagePercentBuffer);
        softErrors = DISKIO_QueryVolumeSoftErrorCount(
            DISKIO2_DiagnosticsSoftErrorCountBuffer);
        GROUP_AM_JMPTBL_WDISP_SPrintf(
            targetPath, Global_STR_DISK_0_IS_FULL_WITH_ERRORS_FORMATTED, usage,
            softErrors);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 90L,
                                      targetPath);
    }
}
