typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG TEXTDISP_SourceConfigEntryTable[];
extern LONG TEXTDISP_SourceConfigEntryCount;
extern UBYTE TEXTDISP_SourceConfigFlagMask;

extern const char Global_STR_DF0_SOURCECFG_INI_2[];
extern LONG PARSEINI_ParseIniBufferAndDispatch(const char *path);

void TEXTDISP_LoadSourceConfig(void)
{
    LONG i;

    for (i = 0; i < 0x12e; ++i) {
        TEXTDISP_SourceConfigEntryTable[i] = 0;
    }

    TEXTDISP_SourceConfigEntryCount = 0;
    TEXTDISP_SourceConfigFlagMask = 0;
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_SOURCECFG_INI_2);
}
