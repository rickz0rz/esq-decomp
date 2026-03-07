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
    const LONG TEMPLATE_WORD_COUNT = 14;
    const LONG TEMPLATE_FIRST_TEXT_INDEX = 12;
    const LONG TEMPLATE_SECOND_TEXT_INDEX = 13;
    const LONG TEMPLATE_BLOCK_BYTES = 56;
    const LONG SEP_BYTES = 1;
    const LONG CH_NUL = 0;
    const LONG STR_TERM_BYTES = 1;
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

    for (i = 0; i < TEMPLATE_WORD_COUNT; i++) {
        templateWords[i] = ((LONG *)GCOMMAND_DigitalPpvEnabledFlag)[i];
    }

    firstText = (UBYTE *)templateWords[TEMPLATE_FIRST_TEXT_INDEX];
    secondText = (UBYTE *)templateWords[TEMPLATE_SECOND_TEXT_INDEX];
    templateWords[TEMPLATE_FIRST_TEXT_INDEX] = CH_NUL;
    templateWords[TEMPLATE_SECOND_TEXT_INDEX] = CH_NUL;

    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(fileHandle, templateWords, TEMPLATE_BLOCK_BYTES);

    scan = firstText;
    while (*scan != CH_NUL) {
        scan++;
    }

    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(fileHandle, firstText, (LONG)(scan - firstText));

    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(
        fileHandle, &GCOMMAND_PpvTemplateFieldSeparatorByteStorage, SEP_BYTES);

    scan = secondText;
    while (*scan != CH_NUL) {
        scan++;
    }

    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(
        fileHandle, secondText, (LONG)(scan - secondText) + STR_TERM_BYTES);

    return GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(fileHandle);
}
