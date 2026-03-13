typedef signed long LONG;

extern void ESQPARS_ClearAliasStringPointers(void);
extern LONG PARSEINI_ParseIniBufferAndDispatch(const char *path);
extern const char CTASKS_PATH_QTABLE_INI[];

void DISKIO2_ParseIniFileFromDisk(void)
{
    ESQPARS_ClearAliasStringPointers();
    PARSEINI_ParseIniBufferAndDispatch(CTASKS_PATH_QTABLE_INI);
}
