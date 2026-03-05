typedef signed long LONG;

extern const char Global_STR_DF0_CONFIG_DAT_1[];
extern const char Global_STR_DEFAULT_CONFIG_FORMATTED[];
extern char BRUSH_LabelScratch[];

extern LONG DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern LONG GROUP_AE_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern LONG DISKIO_WriteBufferedBytes(LONG fileHandle, const void *src, LONG len);
extern LONG DISKIO_CloseBufferedFileAndFlush(LONG fileHandle);

LONG DISKIO_SaveConfigToFileHandle(void)
{
    LONG fileHandle;

    fileHandle = DISKIO_OpenFileWithBuffer(Global_STR_DF0_CONFIG_DAT_1, 1006);
    if (fileHandle == 0) {
        return -1;
    }

    GROUP_AE_JMPTBL_WDISP_SPrintf(BRUSH_LabelScratch, Global_STR_DEFAULT_CONFIG_FORMATTED, 0);
    DISKIO_WriteBufferedBytes(fileHandle, BRUSH_LabelScratch, 52);
    DISKIO_CloseBufferedFileAndFlush(fileHandle);
    return 0;
}
