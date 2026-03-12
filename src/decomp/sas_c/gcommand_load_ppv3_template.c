typedef signed long LONG;
typedef unsigned char UBYTE;

extern char *Global_PTR_WORK_BUFFER;
extern LONG Global_REF_LONG_FILE_SCRATCH;
extern UBYTE GCOMMAND_DigitalPpvEnabledFlag[];
extern char *GCOMMAND_PPVListingsTemplatePtr;
extern char *GCOMMAND_PPVPeriodTemplatePtr;
extern void *AbsExecBase;
extern void *Global_REF_DOS_LIBRARY_2;

extern const char GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplatePrimaryLoad[];
extern const char GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackLoad[];
extern const char GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackDelete[];
extern const char Global_STR_GCOMMAND_C_3[];

extern LONG DISKIO_LoadFileToWorkBuffer(const char *path);
extern void _LVOCopyMem(void *execBase, const void *src, void *dst, LONG size);
extern char *STR_FindCharPtr(const char *text, LONG ch);
extern char *ESQPARS_ReplaceOwnedString(const char *newString, char *oldString);
extern void MEMORY_DeallocateMemory(void *ptr, LONG size);
extern LONG _LVODeleteFile(void *dosBase, const char *name);
extern LONG GCOMMAND_LoadPPVTemplate(void);

LONG GCOMMAND_LoadPPV3Template(void)
{
    LONG copySize;
    LONG usedFallbackDelete;
    char *loadedBuffer;
    LONG loadedSize;
    const char *splitSearch;
    char *splitPtr;

    copySize = 0;
    usedFallbackDelete = 0;

    if (DISKIO_LoadFileToWorkBuffer(
            GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplatePrimaryLoad) != -1) {
        copySize = 56;
    } else if (DISKIO_LoadFileToWorkBuffer(
                   GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackLoad) != -1) {
        copySize = 52;
        _LVODeleteFile(
            Global_REF_DOS_LIBRARY_2,
            GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackDelete);
        usedFallbackDelete = 1;
    }

    if (copySize == 0) {
        return 1;
    }

    loadedBuffer = Global_PTR_WORK_BUFFER;
    loadedSize = Global_REF_LONG_FILE_SCRATCH;

    _LVOCopyMem(AbsExecBase, GCOMMAND_DigitalPpvEnabledFlag, loadedBuffer, copySize);

    GCOMMAND_PPVPeriodTemplatePtr = 0;
    GCOMMAND_PPVListingsTemplatePtr = 0;

    Global_PTR_WORK_BUFFER += copySize;
    splitSearch = STR_FindCharPtr(Global_PTR_WORK_BUFFER, 18);
    splitPtr = (char *)splitSearch;

    if (splitPtr && *splitPtr) {
        *splitPtr = 0;
        splitPtr++;
    }

    GCOMMAND_PPVPeriodTemplatePtr = ESQPARS_ReplaceOwnedString(
        Global_PTR_WORK_BUFFER,
        GCOMMAND_PPVPeriodTemplatePtr);
    GCOMMAND_PPVListingsTemplatePtr = ESQPARS_ReplaceOwnedString(
        splitPtr,
        GCOMMAND_PPVListingsTemplatePtr);

    MEMORY_DeallocateMemory(loadedBuffer, loadedSize + 1);

    if (usedFallbackDelete) {
        GCOMMAND_LoadPPVTemplate();
    }

    return 1;
}
