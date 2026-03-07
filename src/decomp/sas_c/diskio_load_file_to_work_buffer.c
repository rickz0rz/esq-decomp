typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern void *Global_REF_DOS_LIBRARY_2;
extern LONG Global_REF_LONG_FILE_SCRATCH;
extern UBYTE *Global_PTR_WORK_BUFFER;
extern const char Global_STR_DISKIO_C_3[];
extern const char Global_STR_DISKIO_C_4[];

extern LONG GROUP_AG_JMPTBL_DOS_OpenFileWithMode(const char *path, LONG mode);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, ULONG size, ULONG flags);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, ULONG size);

extern LONG DISKIO_GetFilesizeFromHandle(LONG fileHandle);
extern LONG _LVOClose(void *dosBase, LONG fileHandle);
extern LONG _LVORead(void *dosBase, LONG fileHandle, void *buffer, LONG length);

LONG DISKIO_LoadFileToWorkBuffer(const char *path)
{
    const LONG MODE_OLDFILE = 1005;
    const LONG FILEHANDLE_INVALID = 0;
    const LONG RESULT_FAIL = -1;
    const LONG SIZE_MIN_VALID = 0;
    const LONG ALLOC_LINE = 472;
    const LONG FREE_LINE = 492;
    const ULONG MEMF_PUBLIC_CLEAR = 0x10001UL;
    const ULONG STR_TERM_BYTES = 1;
    LONG fileHandle;
    LONG bytesRead;

    fileHandle = GROUP_AG_JMPTBL_DOS_OpenFileWithMode(path, MODE_OLDFILE);
    if (fileHandle == FILEHANDLE_INVALID) {
        return RESULT_FAIL;
    }

    Global_REF_LONG_FILE_SCRATCH = DISKIO_GetFilesizeFromHandle(fileHandle);
    if (Global_REF_LONG_FILE_SCRATCH <= SIZE_MIN_VALID) {
        _LVOClose(Global_REF_DOS_LIBRARY_2, fileHandle);
        return RESULT_FAIL;
    }

    Global_PTR_WORK_BUFFER = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISKIO_C_3,
        ALLOC_LINE,
        (ULONG)(Global_REF_LONG_FILE_SCRATCH + STR_TERM_BYTES),
        MEMF_PUBLIC_CLEAR);
    if (Global_PTR_WORK_BUFFER == (UBYTE *)FILEHANDLE_INVALID) {
        _LVOClose(Global_REF_DOS_LIBRARY_2, fileHandle);
        return RESULT_FAIL;
    }

    bytesRead = _LVORead(Global_REF_DOS_LIBRARY_2, fileHandle, Global_PTR_WORK_BUFFER, Global_REF_LONG_FILE_SCRATCH);
    if (bytesRead != Global_REF_LONG_FILE_SCRATCH) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_DISKIO_C_4,
            FREE_LINE,
            Global_PTR_WORK_BUFFER,
            (ULONG)(Global_REF_LONG_FILE_SCRATCH + STR_TERM_BYTES));
        _LVOClose(Global_REF_DOS_LIBRARY_2, fileHandle);
        return RESULT_FAIL;
    }

    _LVOClose(Global_REF_DOS_LIBRARY_2, fileHandle);
    return Global_REF_LONG_FILE_SCRATCH;
}
