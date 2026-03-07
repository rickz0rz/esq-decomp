typedef signed long LONG;
typedef signed short WORD;
typedef const void *CPTR;

enum {
    DISKIO_READMODE_GUARD_FLAG = 0x100,
    DISKIO_WRITE_RESULT_FAIL = -1,
    DISKIO_WRITE_RESULT_OK = 0
};

extern void *Global_REF_DOS_LIBRARY_2;
extern WORD ESQPARS2_ReadModeFlags;
extern WORD DISKIO_SavedReadModeFlags;
extern LONG DISKIO_WriteFileHandle;

extern LONG _LVOWrite(void *dosBase, LONG fh, CPTR buffer, LONG len);

LONG DISKIO_WriteBytesToOutputHandleGuarded(CPTR data, WORD byteCount)
{
    LONG wrote;

    DISKIO_SavedReadModeFlags = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = DISKIO_READMODE_GUARD_FLAG;

    wrote = _LVOWrite(Global_REF_DOS_LIBRARY_2, DISKIO_WriteFileHandle, data, (LONG)byteCount);

    ESQPARS2_ReadModeFlags = DISKIO_SavedReadModeFlags;

    if ((WORD)wrote == byteCount) {
        return DISKIO_WRITE_RESULT_OK;
    }
    return DISKIO_WRITE_RESULT_FAIL;
}
