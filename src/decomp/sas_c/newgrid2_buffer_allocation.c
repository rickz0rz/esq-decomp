typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG NEWGRID2_BufferAllocationFlag;
extern void *NEWGRID_SecondaryIndexCachePtr;
extern void *NEWGRID_EntryTextScratchPtr;
extern const UBYTE Global_STR_NEWGRID2_C_3;
extern const UBYTE Global_STR_NEWGRID2_C_4;
extern const UBYTE Global_STR_NEWGRID2_C_5;
extern const UBYTE Global_STR_NEWGRID2_C_6;

extern void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(const char *tagName, LONG line, LONG size, LONG flags);
extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const char *tagName, LONG line, void *ptr, LONG bytes);
extern void NEWGRID_RebuildIndexCache(void);

void NEWGRID2_EnsureBuffersAllocated(void)
{
    if (NEWGRID2_BufferAllocationFlag == 0) {
        return;
    }

    NEWGRID_SecondaryIndexCachePtr = SCRIPT_JMPTBL_MEMORY_AllocateMemory(
        &Global_STR_NEWGRID2_C_3, 4153, 1208, 0x10001
    );
    NEWGRID_RebuildIndexCache();

    NEWGRID_EntryTextScratchPtr = SCRIPT_JMPTBL_MEMORY_AllocateMemory(
        &Global_STR_NEWGRID2_C_4, 4156, 1000, 0x10001
    );
    NEWGRID2_BufferAllocationFlag = 0;
}

void NEWGRID2_FreeBuffersIfAllocated(void)
{
    if (NEWGRID_EntryTextScratchPtr == 0) {
        return;
    }

    SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
        &Global_STR_NEWGRID2_C_5, 4164, NEWGRID_EntryTextScratchPtr, 1000
    );
    NEWGRID_EntryTextScratchPtr = 0;

    SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
        &Global_STR_NEWGRID2_C_6, 4167, NEWGRID_SecondaryIndexCachePtr, 1208
    );
    NEWGRID_SecondaryIndexCachePtr = 0;
}
