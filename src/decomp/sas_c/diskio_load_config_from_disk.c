typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern const char Global_STR_DF0_CONFIG_DAT_2[];
extern const char Global_STR_DISKIO_C_9[];
extern LONG Global_REF_LONG_FILE_SCRATCH;
extern char *Global_PTR_WORK_BUFFER;

extern LONG DISKIO_LoadFileToWorkBuffer(const char *path);
extern void DISKIO_ParseConfigBuffer(char *buffer, ULONG size);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, ULONG size);

LONG DISKIO_LoadConfigFromDisk(void)
{
    LONG workBufferSize;
    char *workBuffer;

    if (DISKIO_LoadFileToWorkBuffer(Global_STR_DF0_CONFIG_DAT_2) == -1) {
        return -1;
    }

    workBufferSize = Global_REF_LONG_FILE_SCRATCH;
    workBuffer = Global_PTR_WORK_BUFFER;
    DISKIO_ParseConfigBuffer(workBuffer, (ULONG)(workBufferSize + 1));

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO_C_9, 1344, workBuffer, (ULONG)(workBufferSize + 1));
    return 0;
}
