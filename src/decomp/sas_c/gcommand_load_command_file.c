typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG MODE_NEWFILE;
extern const char GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile[];
extern UBYTE GCOMMAND_DigitalNicheEnabledFlag[];

extern LONG GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern LONG GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(LONG handle, const void *buffer, LONG len);
extern LONG GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(LONG handle);

LONG GCOMMAND_LoadCommandFile(void)
{
    LONG fileHandle;
    LONG templateWords[8];
    UBYTE *textStart;
    UBYTE *scan;
    LONG i;

    fileHandle = GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(
        GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile,
        MODE_NEWFILE);
    if (fileHandle == 0) {
        return fileHandle;
    }

    for (i = 0; i < 8; i++) {
        templateWords[i] = ((LONG *)GCOMMAND_DigitalNicheEnabledFlag)[i];
    }

    textStart = (UBYTE *)templateWords[7];
    templateWords[7] = 0;

    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(fileHandle, templateWords, 32);

    scan = textStart;
    while (*scan != 0) {
        scan++;
    }

    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(
        fileHandle,
        textStart,
        (LONG)(scan - textStart) + 1);

    return GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(fileHandle);
}
