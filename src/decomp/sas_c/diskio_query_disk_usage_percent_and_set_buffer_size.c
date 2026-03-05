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
    LONG percent;
    LONG lockHandle;
    struct InfoDataApprox *info;

    percent = 0;
    lockHandle = _LVOLock(Global_REF_DOS_LIBRARY_2, path, -2);
    if (lockHandle == 0) {
        return percent;
    }

    info = (struct InfoDataApprox *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISKIO_C_5, 567, 32, 0x10000UL);
    if (info != 0) {
        if (_LVOInfo(Global_REF_DOS_LIBRARY_2, lockHandle, info) != 0) {
            percent = GROUP_AG_JMPTBL_MATH_Mulu32((LONG)info->id_NumBlocksUsed, 100);
            percent = GROUP_AG_JMPTBL_MATH_DivS32(percent, (LONG)info->id_NumBlocks);
            DISKIO_BufferState.BufferSize = (LONG)(info->id_BytesPerBlock * 2);
        }

        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO_C_6, 574, info, 32);
    }

    _LVOUnLock(Global_REF_DOS_LIBRARY_2, lockHandle);
    return percent;
}
