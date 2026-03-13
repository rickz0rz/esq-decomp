typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern void *Global_REF_DOS_LIBRARY_2;
extern LONG Global_REF_LONG_FILE_SCRATCH;
extern char *Global_PTR_WORK_BUFFER;
extern const char Global_STR_DISKIO_C_3[];
extern const char Global_STR_DISKIO_C_4[];

extern LONG DOS_OpenFileWithMode(const char *path, LONG mode);
extern void *MEMORY_AllocateMemory(ULONG size, ULONG flags);
extern void MEMORY_DeallocateMemory(void *ptr, ULONG size);

extern LONG DISKIO_GetFilesizeFromHandle(LONG fileHandle);
extern LONG _LVOClose(void *dosBase, LONG fileHandle);
extern LONG _LVORead(void *dosBase, LONG fileHandle, void *buffer, LONG length);

LONG DISKIO_LoadFileToWorkBuffer(const char *path)
{
    LONG fileHandle;
    LONG bytesRead;

    fileHandle = DOS_OpenFileWithMode(path, 1005);
    if (fileHandle == 0) {
        return -1;
    }

    Global_REF_LONG_FILE_SCRATCH = DISKIO_GetFilesizeFromHandle(fileHandle);
    if (Global_REF_LONG_FILE_SCRATCH <= 0) {
        _LVOClose(Global_REF_DOS_LIBRARY_2, fileHandle);
        return -1;
    }

    Global_PTR_WORK_BUFFER = (char *)MEMORY_AllocateMemory(
        (ULONG)(Global_REF_LONG_FILE_SCRATCH + 1),
        0x10001UL);
    if (Global_PTR_WORK_BUFFER == 0) {
        _LVOClose(Global_REF_DOS_LIBRARY_2, fileHandle);
        return -1;
    }

    bytesRead = _LVORead(Global_REF_DOS_LIBRARY_2, fileHandle, Global_PTR_WORK_BUFFER, Global_REF_LONG_FILE_SCRATCH);
    if (bytesRead != Global_REF_LONG_FILE_SCRATCH) {
        MEMORY_DeallocateMemory(
            Global_PTR_WORK_BUFFER,
            (ULONG)(Global_REF_LONG_FILE_SCRATCH + 1));
        _LVOClose(Global_REF_DOS_LIBRARY_2, fileHandle);
        return -1;
    }

    _LVOClose(Global_REF_DOS_LIBRARY_2, fileHandle);
    return Global_REF_LONG_FILE_SCRATCH;
}
