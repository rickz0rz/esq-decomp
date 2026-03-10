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

extern LONG GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(const char *path);
extern void _LVOCopyMem(void *execBase, const void *src, void *dst, LONG size);
extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(const char *text, LONG ch);
extern char *ESQPARS_ReplaceOwnedString(const char *newString, char *oldString);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern LONG _LVODeleteFile(void *dosBase, const char *name);
extern LONG GCOMMAND_LoadPPVTemplate(void);

LONG GCOMMAND_LoadPPV3Template(void)
{
    LONG copySize;
    LONG usedFallbackDelete;
    char *loadedBuffer;
    LONG loadedSize;
    char *splitPtr;

    copySize = 0;
    usedFallbackDelete = 0;

    if (GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(
            GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplatePrimaryLoad) != -1) {
        copySize = 56;
    } else if (GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(
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

    GCOMMAND_PPVPeriodTemplatePtr = (char *)0;
    GCOMMAND_PPVListingsTemplatePtr = (char *)0;

    Global_PTR_WORK_BUFFER += copySize;
    splitPtr = GROUP_AS_JMPTBL_STR_FindCharPtr(Global_PTR_WORK_BUFFER, 18);

    if (splitPtr != (char *)0 && *splitPtr != 0) {
        *splitPtr = 0;
        splitPtr++;
    }

    GCOMMAND_PPVPeriodTemplatePtr = ESQPARS_ReplaceOwnedString(
        Global_PTR_WORK_BUFFER,
        GCOMMAND_PPVPeriodTemplatePtr);
    GCOMMAND_PPVListingsTemplatePtr = ESQPARS_ReplaceOwnedString(
        splitPtr,
        GCOMMAND_PPVListingsTemplatePtr);

    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_GCOMMAND_C_3,
        993,
        loadedBuffer,
        loadedSize + 1);

    if (usedFallbackDelete != 0) {
        GCOMMAND_LoadPPVTemplate();
    }

    return 1;
}
