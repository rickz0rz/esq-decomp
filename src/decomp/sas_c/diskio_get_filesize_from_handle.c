typedef signed long LONG;

extern void *Global_REF_DOS_LIBRARY_2;
extern LONG _LVOSeek(void *dosBase, LONG fh, LONG offset, LONG mode);

LONG DISKIO_GetFilesizeFromHandle(LONG fileHandle)
{
    LONG endPos;

    _LVOSeek(Global_REF_DOS_LIBRARY_2, fileHandle, 0, 1);
    _LVOSeek(Global_REF_DOS_LIBRARY_2, fileHandle, 0, 0);
    endPos = _LVOSeek(Global_REF_DOS_LIBRARY_2, fileHandle, 0, -1);

    return endPos;
}
