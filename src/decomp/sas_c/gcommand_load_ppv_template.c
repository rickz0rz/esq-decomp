typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG MODE_NEWFILE;
extern const char GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplateSave[];
extern UBYTE GCOMMAND_DigitalPpvEnabledFlag[];
extern UBYTE GCOMMAND_PpvTemplateFieldSeparatorByteStorage;

extern LONG GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern LONG GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(LONG handle, const void *buffer, LONG len);
extern LONG GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(LONG handle);

LONG GCOMMAND_LoadPPVTemplate(void)
{
    LONG fileHandle;
    LONG templateWords[14];
    UBYTE *firstText;
    UBYTE *secondText;
    UBYTE *scan;
    LONG i;

    fileHandle = GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(
        GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplateSave,
        MODE_NEWFILE);
    if (fileHandle == 0) {
        return fileHandle;
    }

    for (i = 0; i < 14; i++) {
        templateWords[i] = ((LONG *)GCOMMAND_DigitalPpvEnabledFlag)[i];
    }

    firstText = (UBYTE *)templateWords[12];
    secondText = (UBYTE *)templateWords[13];
    templateWords[12] = 0;
    templateWords[13] = 0;

    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(fileHandle, templateWords, 56);

    scan = firstText;
    while (*scan != 0) {
        scan++;
    }

    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(fileHandle, firstText, (LONG)(scan - firstText));

    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(fileHandle, &GCOMMAND_PpvTemplateFieldSeparatorByteStorage, 1);

    scan = secondText;
    while (*scan != 0) {
        scan++;
    }

    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(fileHandle, secondText, (LONG)(scan - secondText) + 1);

    return GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(fileHandle);
}
