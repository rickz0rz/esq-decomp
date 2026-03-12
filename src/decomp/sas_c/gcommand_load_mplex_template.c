typedef signed long LONG;
typedef unsigned char UBYTE;

extern char *Global_PTR_WORK_BUFFER;
extern LONG Global_REF_LONG_FILE_SCRATCH;
extern UBYTE GCOMMAND_DigitalMplexEnabledFlag[];
extern char *GCOMMAND_MplexListingsTemplatePtr;
extern char *GCOMMAND_MplexAtTemplatePtr;
extern void *AbsExecBase;

extern const char GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateLoad[];
extern const char GCOMMAND_FMT_PCT_T_MplexTemplateLoad[];
extern const char Global_STR_GCOMMAND_C_2[];

extern LONG DISKIO_LoadFileToWorkBuffer(const char *path);
extern void _LVOCopyMem(void *execBase, const void *src, void *dst, LONG size);
extern char *STR_FindCharPtr(const char *text, LONG ch);
extern char *ESQ_FindSubstringCaseFold(const char *text, const char *needle);
extern char *ESQPARS_ReplaceOwnedString(const char *newString, char *oldString);
extern void MEMORY_DeallocateMemory(void *ptr, LONG size);

LONG GCOMMAND_LoadMplexTemplate(void)
{
    char *loadedBuffer;
    LONG loadedSize;
    char *splitPtr;
    const char *fmtSlotSearch;
    char *fmtSlot;

    if (DISKIO_LoadFileToWorkBuffer(
            GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateLoad) == -1) {
        return 1;
    }

    loadedBuffer = Global_PTR_WORK_BUFFER;
    loadedSize = Global_REF_LONG_FILE_SCRATCH;

    _LVOCopyMem(AbsExecBase, GCOMMAND_DigitalMplexEnabledFlag, loadedBuffer, 52);
    Global_PTR_WORK_BUFFER += 52;

    GCOMMAND_MplexListingsTemplatePtr = 0;
    GCOMMAND_MplexAtTemplatePtr = 0;

    splitPtr = STR_FindCharPtr(Global_PTR_WORK_BUFFER, 18);
    if (splitPtr && *splitPtr) {
        *splitPtr = 0;
        splitPtr++;
    }

    GCOMMAND_MplexAtTemplatePtr = ESQPARS_ReplaceOwnedString(
        Global_PTR_WORK_BUFFER,
        GCOMMAND_MplexAtTemplatePtr);
    GCOMMAND_MplexListingsTemplatePtr = ESQPARS_ReplaceOwnedString(
        splitPtr,
        GCOMMAND_MplexListingsTemplatePtr);

    MEMORY_DeallocateMemory(loadedBuffer, loadedSize + 1);

    fmtSlotSearch = 0;
    fmtSlot = 0;
    if (GCOMMAND_MplexAtTemplatePtr && *GCOMMAND_MplexAtTemplatePtr) {
        fmtSlotSearch = ESQ_FindSubstringCaseFold(
            GCOMMAND_MplexAtTemplatePtr,
            GCOMMAND_FMT_PCT_T_MplexTemplateLoad);
    }

    if (fmtSlotSearch && *fmtSlotSearch) {
        fmtSlot = (char *)fmtSlotSearch;
        fmtSlot[1] = 's';
    }

    return 1;
}
