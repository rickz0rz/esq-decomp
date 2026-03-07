typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern void *Global_REF_DOS_LIBRARY_2;
extern const char Global_STR_DISKIO_C_7[];
extern const char Global_STR_DISKIO_C_8[];

extern LONG _LVOLock(void *dosBase, const char *name, LONG mode);
extern LONG _LVOInfo(void *dosBase, LONG lock, void *infoData);
extern LONG _LVOUnLock(void *dosBase, LONG lock);

extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);

#define LOCK_READ_MODE (-2L)
#define MEMF_CLEAR_FLAG 0x00010000UL
#define STRUCT_INFODATA_SIZE 36L
#define INFODATA_ALLOC_LINE 593L
#define INFODATA_FREE_LINE 599L
#define RESULT_FAIL 0L

LONG DISKIO_QueryVolumeSoftErrorCount(const char *path)
{
    LONG softErrorCount = 0;
    LONG lock;
    UBYTE *infoData;

    lock = _LVOLock(Global_REF_DOS_LIBRARY_2, path, LOCK_READ_MODE);
    if (lock == RESULT_FAIL) {
        return RESULT_FAIL;
    }

    infoData = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISKIO_C_7,
        INFODATA_ALLOC_LINE,
        STRUCT_INFODATA_SIZE,
        MEMF_CLEAR_FLAG);

    if (infoData != 0) {
        if (_LVOInfo(Global_REF_DOS_LIBRARY_2, lock, infoData) != RESULT_FAIL) {
            softErrorCount = *(LONG *)(void *)infoData;
        }

        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_DISKIO_C_8,
            INFODATA_FREE_LINE,
            infoData,
            STRUCT_INFODATA_SIZE);
    }

    _LVOUnLock(Global_REF_DOS_LIBRARY_2, lock);
    return softErrorCount;
}
