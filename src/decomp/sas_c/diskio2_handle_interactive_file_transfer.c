typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef signed short WORD;
typedef signed long LONG;
typedef char *STRPTR;

extern void GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(LONG mask, LONG mode);
extern void GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern LONG GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(void);
extern void DISPLIB_DisplayTextAtPosition(char *rp, LONG x, LONG y, const char *text);
extern char *GROUP_AG_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen);
extern LONG GROUP_AH_JMPTBL_ESQ_WildcardMatch(const char *pattern, const char *text);
extern LONG GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3(const char *text);
extern LONG GROUP_AG_JMPTBL_DOS_OpenFileWithMode(const char *path, LONG mode);
extern LONG DISKIO2_ReceiveTransferBlocksToFile(UBYTE verifyCrc32);
extern void DISKIO_DrawTransferErrorMessageIfDiagnostics(LONG code);
extern void DISKIO_ForceUiRefreshIfIdle(void);
extern void DISKIO_ResetCtrlInputStateIfIdle(void);
extern LONG DISKIO_QueryDiskUsagePercentAndSetBufferSize(char *out);
extern LONG DISKIO_QueryVolumeSoftErrorCount(char *out);
extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, LONG a, LONG b);
extern char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);
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
extern UBYTE DISKIO2_TransferFilenameBuffer[64];
extern UBYTE DISKIO2_TransferSizeTokenBuffer[16];
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

    GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(4, 1);

    DISKIO2_TransferXorChecksumByte = (crc32Mode != 0U) ? 0xC2 : 0xB7;
    GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();

    while (filenameLen < 0x1FU) {
        b = (UBYTE)GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (b == 0U) {
            break;
        }
        DISKIO2_TransferFilenameBuffer[filenameLen++] = b;
        DISKIO2_TransferXorChecksumByte ^= b;
        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
    }
    DISKIO2_TransferFilenameBuffer[filenameLen] = 0;

    if (filenameLen == 13U) {
        if (GROUP_AH_JMPTBL_ESQ_WildcardMatch(CTASKS_EXT_GRF, DISKIO2_TransferFilenameExtPtr) == 0) {
            status = 0;
            if (ED_DiagnosticsScreenActive != 0) {
                DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 240, Global_STR_SPECIAL_NGAD);
            }
        }
    }

    GROUP_AG_JMPTBL_STRING_CopyPadNul(targetPath, (const char *)DISKIO2_TransferFilenameBuffer, 64);
    GROUP_AG_JMPTBL_STRING_CopyPadNul(targetPath, Global_STR_RAM, 4);

    if (ED_DiagnosticsScreenActive != 0) {
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 180, Global_STR_FILENAME);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 205, 180, (const char *)DISKIO2_TransferFilenameBuffer);
    }

    GROUP_AG_JMPTBL_STRING_CopyPadNul(shortName, (const char *)DISKIO2_TransferFilenameBuffer, 4);

    if (crc32Mode != 0U) {
        UBYTE tokenLen = 0;
        LONG lock;
        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        while (tokenLen < 8U) {
            b = (UBYTE)GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
            if (b == 0U) {
                break;
            }
            DISKIO2_TransferSizeTokenBuffer[tokenLen++] = b;
            DISKIO2_TransferXorChecksumByte ^= b;
            GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
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

        if (GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3((const char *)DISKIO2_TransferSizeTokenBuffer) > targetMax) {
            UBYTE *s = DISKIO2_TransferFilenameBuffer;
            UBYTE *d = BRUSH_SnapshotHeader;
            do {
                *d++ = *s;
            } while (*s++ != 0);

            GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(4, 0);
            DISKIO2_InteractiveTransferArmedFlag = 0;
            return -2;
        }
    }

    GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
    ESQIFF_RecordChecksumByte = (UBYTE)GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
    if (ESQIFF_RecordChecksumByte != DISKIO2_TransferXorChecksumByte || status != 1) {
        goto finalize_overlay;
    }

    DISKIO_WriteFileHandle = GROUP_AG_JMPTBL_DOS_OpenFileWithMode(targetPath, 1006);
    if (DISKIO_WriteFileHandle == 0) {
        DISKIO_DrawTransferErrorMessageIfDiagnostics(5);
        GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(4, 0);
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
        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        b = (UBYTE)GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (b != 0x55U) {
            continue;
        }
        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        b = (UBYTE)GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();
        if (b != 0xAAU) {
            continue;
        }
        GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
        b = (UBYTE)GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte();

        if (b == 0x48U || b == 0x3DU) {
            DISKIO2_TransferXorChecksumByte = (b == 0x3D) ? 0xC2 : 0xB7;
            transferResult = DISKIO2_ReceiveTransferBlocksToFile((UBYTE)(b == 0x3D));
            if (transferResult != 0) {
                break;
            }
            continue;
        }

        if (b == 0xBBU) {
            GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
            if ((UBYTE)GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte() != 0xBBU) {
                continue;
            }
            GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
            if ((UBYTE)GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte() != 0x00U) {
                continue;
            }
            GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi();
            if ((UBYTE)GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte() != 0xFFU) {
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

        GROUP_AG_JMPTBL_STRING_CopyPadNul(scratch, Global_STR_COPY_NIL, 12);
        GROUP_AI_JMPTBL_STRING_AppendAtNull(scratch, targetPath);
        GROUP_AI_JMPTBL_STRING_AppendAtNull(scratch, DISKIO2_STR_ShellCommandArgSeparator);
        GROUP_AI_JMPTBL_STRING_AppendAtNull(scratch, (const char *)DISKIO2_TransferFilenameBuffer);
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
    GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(4, 0);

    if (ED_DiagnosticsScreenActive != 0) {
        LONG pct = DISKIO_QueryDiskUsagePercentAndSetBufferSize(DISKIO2_DiagnosticsDiskUsagePercentBuffer);
        LONG errs = DISKIO_QueryVolumeSoftErrorCount(DISKIO2_DiagnosticsSoftErrorCountBuffer);
        GROUP_AM_JMPTBL_WDISP_SPrintf(
            targetPath,
            Global_STR_DISK_0_IS_FULL_WITH_ERRORS_FORMATTED,
            pct,
            errs);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 90, targetPath);
    }

    return transferResult;
}
