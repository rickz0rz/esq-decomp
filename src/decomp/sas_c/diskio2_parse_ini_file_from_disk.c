extern void GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers(void);
extern void GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(const char *path);
extern const char CTASKS_PATH_QTABLE_INI[];

void DISKIO2_ParseIniFileFromDisk(void)
{
    GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers();
    GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(CTASKS_PATH_QTABLE_INI);
}
