#include <exec/types.h>typedef char *STRPTR;

extern void ESQDISP_UpdateStatusMaskAndRefresh(LONG mask, LONG mode);
extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern LONG SCRIPT_ReadNextRbfByte(void);
extern void DISPLIB_DisplayTextAtPosition(char *rp, LONG x, LONG y, const char *text);
extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen);
extern LONG ESQ_WildcardMatch(const char *pattern, const char *text);
extern LONG PARSE_ReadSignedLongSkipClass3(const char *text);
extern LONG DOS_OpenFileWithMode(const char *path, LONG mode);
extern LONG DISKIO2_ReceiveTransferBlocksToFile(UBYTE verifyCrc32);
extern void DISKIO_DrawTransferErrorMessageIfDiagnostics(LONG code);
extern void DISKIO_ForceUiRefreshIfIdle(void);
extern void DISKIO_ResetCtrlInputStateIfIdle(void);
extern LONG DISKIO_QueryDiskUsagePercentAndSetBufferSize(char *out);
extern LONG DISKIO_QueryVolumeSoftErrorCount(char *out);
extern LONG WDISP_SPrintf(char *dst, const char *fmt, LONG a, LONG b);
extern char *STRING_AppendAtNull(char *dst, const char *src);
extern LONG _LVOLock(void *dosBase, STRPTR name, LONG mode);
extern LONG _LVOUnLock(void *dosBase, LONG lock);
extern LONG _LVODeleteFile(void *dosBase, STRPTR name);
extern LONG _LVOClose(void *dosBase, LONG fh);
extern LONG _LVOExecute(void *dosBase, STRPTR cmd, LONG in, LONG out);
extern LONG _LVOInfo(void *dosBase, LONG lock, void *id);

extern LONG GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, ULONG size, ULONG flags);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, ULONG size);

extern char *Global_REF_RASTPORT_1;
extern void *Global_REF_DOS_LIBRARY_2;
extern const char Global_STR_SPECIAL_NGAD[];
extern const char Global_STR_RAM[];
extern const char Global_STR_FILENAME[];
extern const char Global_STR_DISK_0_IS_FULL_WITH_ERRORS_FORMATTED[];
extern const char Global_STR_COPY_NIL[];
extern const char Global_STR_DISKIO2_C_24[];
extern const char Global_STR_DISKIO2_C_25[];
extern const char Global_STR_DISKIO2_C_26[];
extern const char Global_STR_DISKIO2_C_27[];
extern const char DISKIO2_STR_DiagTransferStatusClearLine210[];
extern const char DISKIO2_STR_DiagTransferStatusClearLine240[];
extern const char DISKIO2_STR_ShellCommandArgSeparator[];
extern const char CTASKS_EXT_GRF[];
extern const char DISKIO2_TransferFilenameExtPtr[];

extern WORD ED_DiagnosticsScreenActive;
extern UBYTE DISKIO2_TransferXorChecksumByte;
extern char DISKIO2_TransferFilenameBuffer[64];
extern char DISKIO2_TransferSizeTokenBuffer[16];
extern ULONG DISKIO2_InteractiveTransferArmedFlag;
extern LONG DISKIO_WriteFileHandle;
extern WORD ESQPARS2_ReadModeFlags;
extern WORD DISKIO_SavedReadModeFlags;
extern ULONG DISKIO2_TransferCrcErrorCount;
extern UBYTE DISKIO2_TransferBlockSequence;
extern UBYTE *DISKIO2_TransferBlockBufferPtr;
extern UWORD DISKIO2_TransferBufferedByteCount;
extern UBYTE ESQIFF_RecordChecksumByte;
extern UBYTE BRUSH_SnapshotHeader[];
extern char DISKIO2_DiagnosticsDiskUsagePercentBuffer[];
extern char DISKIO2_DiagnosticsSoftErrorCountBuffer[];

LONG DISKIO2_HandleInteractiveFileTransfer(UBYTE crc32Mode)
{
    UBYTE filenameLen = 0;
    UBYTE b;
    LONG status = 1;
    LONG transferResult = 0;
    LONG targetMax = 0x7FFFFFFFL;
    char targetPath[64];
    char shortName[16];
    char scratch[156];

    ESQDISP_UpdateStatusMaskAndRefresh(4, 1);

    DISKIO2_TransferXorChecksumByte = (crc32Mode != 0U) ? 0xC2 : 0xB7;
    ESQFUNC_WaitForClockChangeAndServiceUi();

    while (filenameLen < 0x1FU) {
        b = (UBYTE)SCRIPT_ReadNextRbfByte();
        if (b == 0U) {
            break;
        }
        DISKIO2_TransferFilenameBuffer[filenameLen++] = b;
        DISKIO2_TransferXorChecksumByte ^= b;
        ESQFUNC_WaitForClockChangeAndServiceUi();
    }
    DISKIO2_TransferFilenameBuffer[filenameLen] = 0;

    if (filenameLen == 13U) {
        if (ESQ_WildcardMatch(CTASKS_EXT_GRF, DISKIO2_TransferFilenameExtPtr) == 0) {
            status = 0;
            if (ED_DiagnosticsScreenActive != 0) {
                DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 240, Global_STR_SPECIAL_NGAD);
            }
        }
    }

    STRING_CopyPadNul(targetPath, DISKIO2_TransferFilenameBuffer, 64);
    STRING_CopyPadNul(targetPath, Global_STR_RAM, 4);

    if (ED_DiagnosticsScreenActive != 0) {
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 180, Global_STR_FILENAME);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 205, 180, DISKIO2_TransferFilenameBuffer);
    }

    STRING_CopyPadNul(shortName, DISKIO2_TransferFilenameBuffer, 4);

    if (crc32Mode != 0U) {
        UBYTE tokenLen = 0;
        LONG lock;
        ESQFUNC_WaitForClockChangeAndServiceUi();
        while (tokenLen < 8U) {
            b = (UBYTE)SCRIPT_ReadNextRbfByte();
            if (b == 0U) {
                break;
            }
            DISKIO2_TransferSizeTokenBuffer[tokenLen++] = b;
            DISKIO2_TransferXorChecksumByte ^= b;
            ESQFUNC_WaitForClockChangeAndServiceUi();
        }
        DISKIO2_TransferSizeTokenBuffer[tokenLen] = 0;

        lock = _LVOLock(Global_REF_DOS_LIBRARY_2, shortName, -2);
        if (lock != 0) {
            void *id = (void *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_DISKIO2_C_24, 1312, 34, 1);
            if (id != 0) {
                if (_LVOInfo(Global_REF_DOS_LIBRARY_2, lock, id) != 0) {
                    targetMax = (((LONG)0x6DE - *((LONG *)((UBYTE *)id + 16))) << 9) - 0x1000;
                }
                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_25, 1318, id, 34);
            }
            _LVOUnLock(Global_REF_DOS_LIBRARY_2, lock);
        }

        if (PARSE_ReadSignedLongSkipClass3(DISKIO2_TransferSizeTokenBuffer) > targetMax) {
            char *s = DISKIO2_TransferFilenameBuffer;
            UBYTE *d = BRUSH_SnapshotHeader;
            do {
                *d++ = (UBYTE)*s;
            } while (*s++ != 0);

            ESQDISP_UpdateStatusMaskAndRefresh(4, 0);
            DISKIO2_InteractiveTransferArmedFlag = 0;
            return -2;
        }
    }

    ESQFUNC_WaitForClockChangeAndServiceUi();
    ESQIFF_RecordChecksumByte = (UBYTE)SCRIPT_ReadNextRbfByte();
    if (ESQIFF_RecordChecksumByte != DISKIO2_TransferXorChecksumByte || status != 1) {
        goto finalize_overlay;
    }

    DISKIO_WriteFileHandle = DOS_OpenFileWithMode(targetPath, 1006);
    if (DISKIO_WriteFileHandle == 0) {
        DISKIO_DrawTransferErrorMessageIfDiagnostics(5);
        ESQDISP_UpdateStatusMaskAndRefresh(4, 0);
        return -1;
    }

    DISKIO_SavedReadModeFlags = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = 0x100;
    DISKIO2_TransferCrcErrorCount = 0;
    DISKIO2_TransferBlockSequence = 0;
    DISKIO2_TransferBlockBufferPtr = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISKIO2_C_26, 1389, 4352, 0x10001UL);
    ESQPARS2_ReadModeFlags = DISKIO_SavedReadModeFlags;
    DISKIO2_TransferBufferedByteCount = 0;

    while (1) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        b = (UBYTE)SCRIPT_ReadNextRbfByte();
        if (b != 0x55U) {
            continue;
        }
        ESQFUNC_WaitForClockChangeAndServiceUi();
        b = (UBYTE)SCRIPT_ReadNextRbfByte();
        if (b != 0xAAU) {
            continue;
        }
        ESQFUNC_WaitForClockChangeAndServiceUi();
        b = (UBYTE)SCRIPT_ReadNextRbfByte();

        if (b == 0x48U || b == 0x3DU) {
            DISKIO2_TransferXorChecksumByte = (b == 0x3D) ? 0xC2 : 0xB7;
            transferResult = DISKIO2_ReceiveTransferBlocksToFile((UBYTE)(b == 0x3D));
            if (transferResult != 0) {
                break;
            }
            continue;
        }

        if (b == 0xBBU) {
            ESQFUNC_WaitForClockChangeAndServiceUi();
            if ((UBYTE)SCRIPT_ReadNextRbfByte() != 0xBBU) {
                continue;
            }
            ESQFUNC_WaitForClockChangeAndServiceUi();
            if ((UBYTE)SCRIPT_ReadNextRbfByte() != 0x00U) {
                continue;
            }
            ESQFUNC_WaitForClockChangeAndServiceUi();
            if ((UBYTE)SCRIPT_ReadNextRbfByte() != 0xFFU) {
                continue;
            }
            transferResult = 4;
            break;
        }
    }

    DISKIO_SavedReadModeFlags = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = 0x100;
    _LVOClose(Global_REF_DOS_LIBRARY_2, DISKIO_WriteFileHandle);
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_DISKIO2_C_27, 1499, DISKIO2_TransferBlockBufferPtr, 4352);

    if (ED_DiagnosticsScreenActive != 0) {
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 210, DISKIO2_STR_DiagTransferStatusClearLine210);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 240, DISKIO2_STR_DiagTransferStatusClearLine240);
    }

    if (transferResult == -1) {
        _LVODeleteFile(Global_REF_DOS_LIBRARY_2, (STRPTR)DISKIO2_TransferFilenameBuffer);
        DISKIO_ForceUiRefreshIfIdle();

        STRING_CopyPadNul(scratch, Global_STR_COPY_NIL, 12);
        STRING_AppendAtNull(scratch, targetPath);
        STRING_AppendAtNull(scratch, DISKIO2_STR_ShellCommandArgSeparator);
        STRING_AppendAtNull(scratch, DISKIO2_TransferFilenameBuffer);
        _LVOExecute(Global_REF_DOS_LIBRARY_2, scratch, 0, 0);
        _LVODeleteFile(Global_REF_DOS_LIBRARY_2, targetPath);
        DISKIO_ResetCtrlInputStateIfIdle();

        if (ED_DiagnosticsScreenActive != 0) {
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 180, "STORED");
        }
    } else {
        DISKIO_DrawTransferErrorMessageIfDiagnostics(transferResult);
        _LVODeleteFile(Global_REF_DOS_LIBRARY_2, targetPath);
    }

    ESQPARS2_ReadModeFlags = DISKIO_SavedReadModeFlags;

finalize_overlay:
    DISKIO2_InteractiveTransferArmedFlag = 0;
    ESQDISP_UpdateStatusMaskAndRefresh(4, 0);

    if (ED_DiagnosticsScreenActive != 0) {
        LONG pct = DISKIO_QueryDiskUsagePercentAndSetBufferSize(DISKIO2_DiagnosticsDiskUsagePercentBuffer);
        LONG errs = DISKIO_QueryVolumeSoftErrorCount(DISKIO2_DiagnosticsSoftErrorCountBuffer);
        WDISP_SPrintf(
            targetPath,
            Global_STR_DISK_0_IS_FULL_WITH_ERRORS_FORMATTED,
            pct,
            errs);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 90, targetPath);
    }

    return transferResult;
}
