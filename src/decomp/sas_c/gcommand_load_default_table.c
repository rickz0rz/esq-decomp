typedef signed long LONG;

typedef unsigned char UBYTE;

extern char *Global_PTR_WORK_BUFFER;
extern LONG Global_REF_LONG_FILE_SCRATCH;
extern UBYTE GCOMMAND_DigitalNicheEnabledFlag[];
extern char *GCOMMAND_DigitalNicheListingsTemplatePtr;
extern void *AbsExecBase;

extern const char GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_DefaultTable[];
extern const char Global_STR_GCOMMAND_C_1[];

extern LONG GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(const char *path);
extern void _LVOCopyMem(void *execBase, const void *src, void *dst, LONG size);
extern char *ESQPARS_ReplaceOwnedString(const char *newString, char *oldString);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

LONG GCOMMAND_LoadDefaultTable(void)
{
    char *loadedBuffer;
    LONG loadedSize;

    if (GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_DefaultTable) == -1) {
        return 1;
    }

    loadedBuffer = Global_PTR_WORK_BUFFER;
    loadedSize = Global_REF_LONG_FILE_SCRATCH;

    _LVOCopyMem(AbsExecBase, GCOMMAND_DigitalNicheEnabledFlag, loadedBuffer, 32);
    Global_PTR_WORK_BUFFER += 32;

    GCOMMAND_DigitalNicheListingsTemplatePtr = (char *)0;
    GCOMMAND_DigitalNicheListingsTemplatePtr = ESQPARS_ReplaceOwnedString(Global_PTR_WORK_BUFFER, (char *)0);

    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_GCOMMAND_C_1, 335, loadedBuffer, loadedSize + 1);

    return 1;
}
