#include <exec/types.h>
extern LONG MODE_NEWFILE;
extern const char GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile[];
extern UBYTE GCOMMAND_DigitalNicheEnabledFlag[];

extern LONG DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern LONG DISKIO_WriteBufferedBytes(LONG handle, const void *buffer, LONG len);
extern LONG DISKIO_CloseBufferedFileAndFlush(LONG handle);

LONG GCOMMAND_LoadCommandFile(void)
{
    const LONG TEMPLATE_WORD_COUNT = 8;
    const LONG TEMPLATE_WORD_LAST = 7;
    const LONG TEMPLATE_BLOCK_BYTES = 32;
    const UBYTE CH_NUL = 0;
    const LONG ONE = 1;
    LONG fileHandle;
    LONG templateWords[8];
    UBYTE *textStart;
    UBYTE *scan;
    LONG i;

    fileHandle = DISKIO_OpenFileWithBuffer(
        GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile,
        MODE_NEWFILE);
    if (fileHandle == 0) {
        return fileHandle;
    }

    for (i = 0; i < TEMPLATE_WORD_COUNT; i++) {
        templateWords[i] = ((LONG *)GCOMMAND_DigitalNicheEnabledFlag)[i];
    }

    textStart = (UBYTE *)templateWords[TEMPLATE_WORD_LAST];
    templateWords[TEMPLATE_WORD_LAST] = 0;

    DISKIO_WriteBufferedBytes(fileHandle, templateWords, TEMPLATE_BLOCK_BYTES);

    scan = textStart;
    do {
    } while (*scan++ != CH_NUL);

    DISKIO_WriteBufferedBytes(
        fileHandle,
        textStart,
        (LONG)(scan - textStart));

    return DISKIO_CloseBufferedFileAndFlush(fileHandle);
}
