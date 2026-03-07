typedef signed long LONG;

enum {
    DISKIO_SEEK_MODE_END = -1,
    DISKIO_SEEK_MODE_BEGIN = 0,
    DISKIO_SEEK_MODE_CURRENT = 1,
    DISKIO_SEEK_OFFSET_ZERO = 0
};

extern void *Global_REF_DOS_LIBRARY_2;
extern LONG _LVOSeek(void *dosBase, LONG fh, LONG offset, LONG mode);

LONG DISKIO_GetFilesizeFromHandle(LONG fileHandle)
{
    LONG endPos;

    _LVOSeek(Global_REF_DOS_LIBRARY_2, fileHandle, DISKIO_SEEK_OFFSET_ZERO, DISKIO_SEEK_MODE_CURRENT);
    _LVOSeek(Global_REF_DOS_LIBRARY_2, fileHandle, DISKIO_SEEK_OFFSET_ZERO, DISKIO_SEEK_MODE_BEGIN);
    endPos = _LVOSeek(Global_REF_DOS_LIBRARY_2, fileHandle, DISKIO_SEEK_OFFSET_ZERO, DISKIO_SEEK_MODE_END);

    return endPos;
}
