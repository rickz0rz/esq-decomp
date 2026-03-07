typedef signed long LONG;
typedef unsigned long ULONG;

struct DiskIoBufferState {
    void *BufferPtr;
    LONG BufferSize;
    LONG Remaining;
    short SavedF45;
};

struct InfoDataApprox {
    ULONG pad0;
    ULONG pad1;
    ULONG pad2;
    ULONG id_NumBlocks;
    ULONG id_NumBlocksUsed;
    ULONG id_BytesPerBlock;
};

extern void *Global_REF_DOS_LIBRARY_2;
extern struct DiskIoBufferState DISKIO_BufferState;
extern const char Global_STR_DISKIO_C_5[];
extern const char Global_STR_DISKIO_C_6[];

extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, ULONG size, ULONG flags);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, ULONG size);
extern LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG num, LONG den);

extern LONG _LVOLock(void *dosBase, const char *name, LONG mode);
extern LONG _LVOInfo(void *dosBase, LONG lock, void *infoData);
extern LONG _LVOUnLock(void *dosBase, LONG lock);

LONG DISKIO_QueryDiskUsagePercentAndSetBufferSize(const char *path)
{
    const LONG LOCK_READ = -2;
    const LONG LOCK_INVALID = 0;
    const LONG INFO_QUERY_OK = 1;
    const LONG PERCENT_SCALE = 100;
    const LONG BUFFER_BLOCK_MULT = 2;
    const LONG ALLOC_LINE = 567;
    const LONG FREE_LINE = 574;
    const ULONG INFODATA_SIZE = 32;
    const ULONG MEMF_CLEAR = 0x10000UL;
    LONG usagePercent;
    LONG lockHandle;
    struct InfoDataApprox *info;

    usagePercent = 0;
    lockHandle = _LVOLock(Global_REF_DOS_LIBRARY_2, path, LOCK_READ);
    if (lockHandle == LOCK_INVALID) {
        return usagePercent;
    }

    info = (struct InfoDataApprox *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISKIO_C_5, ALLOC_LINE, INFODATA_SIZE, MEMF_CLEAR);
    if (info != 0) {
        if (_LVOInfo(Global_REF_DOS_LIBRARY_2, lockHandle, info) == INFO_QUERY_OK) {
            usagePercent = GROUP_AG_JMPTBL_MATH_Mulu32((LONG)info->id_NumBlocksUsed, PERCENT_SCALE);
            usagePercent = GROUP_AG_JMPTBL_MATH_DivS32(usagePercent, (LONG)info->id_NumBlocks);
            DISKIO_BufferState.BufferSize = (LONG)(info->id_BytesPerBlock * BUFFER_BLOCK_MULT);
        }

        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO_C_6, FREE_LINE, info, INFODATA_SIZE);
    }

    _LVOUnLock(Global_REF_DOS_LIBRARY_2, lockHandle);
    return usagePercent;
}
