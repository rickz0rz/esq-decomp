#include <exec/types.h>
extern LONG MODE_NEWFILE;
extern const char GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateSave[];
extern UBYTE GCOMMAND_DigitalMplexEnabledFlag[];
extern UBYTE GCOMMAND_MplexTemplateFieldSeparatorByteStorage;

extern LONG DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern LONG DISKIO_WriteBufferedBytes(LONG handle, const void *buffer, LONG len);
extern LONG DISKIO_CloseBufferedFileAndFlush(LONG handle);

LONG GCOMMAND_LoadMplexFile(void)
{
    const LONG TEMPLATE_WORD_COUNT = 13;
    const LONG TEMPLATE_FIRST_TEXT_INDEX = 11;
    const LONG TEMPLATE_SECOND_TEXT_INDEX = 12;
    const LONG TEMPLATE_BLOCK_BYTES = 52;
    const LONG SEP_BYTES = 1;
    const LONG STR_TERM_BYTES = 1;
    LONG fileHandle;
    LONG templateWords[13];
    UBYTE *firstText;
    UBYTE *secondText;
    UBYTE *scan;
    LONG i;

    fileHandle = DISKIO_OpenFileWithBuffer(
        GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateSave,
        MODE_NEWFILE);
    if (fileHandle == 0) {
        return fileHandle;
    }

    for (i = 0; i < TEMPLATE_WORD_COUNT; i++) {
        templateWords[i] = ((LONG *)GCOMMAND_DigitalMplexEnabledFlag)[i];
    }

    firstText = (UBYTE *)templateWords[TEMPLATE_FIRST_TEXT_INDEX];
    secondText = (UBYTE *)templateWords[TEMPLATE_SECOND_TEXT_INDEX];
    templateWords[TEMPLATE_FIRST_TEXT_INDEX] = 0;
    templateWords[TEMPLATE_SECOND_TEXT_INDEX] = 0;

    DISKIO_WriteBufferedBytes(fileHandle, templateWords, TEMPLATE_BLOCK_BYTES);

    scan = firstText;
    while (*scan != 0) {
        scan++;
    }

    DISKIO_WriteBufferedBytes(fileHandle, firstText, (LONG)(scan - firstText));

    DISKIO_WriteBufferedBytes(
        fileHandle, &GCOMMAND_MplexTemplateFieldSeparatorByteStorage, SEP_BYTES);

    scan = secondText;
    while (*scan != 0) {
        scan++;
    }

    DISKIO_WriteBufferedBytes(
        fileHandle, secondText, (LONG)(scan - secondText) + STR_TERM_BYTES);

    return DISKIO_CloseBufferedFileAndFlush(fileHandle);
}
