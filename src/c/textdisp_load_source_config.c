/* RESTORES: TEXTDISP_LoadSourceConfig
 * MODULE:   modules/groups/b/a/textdisp3.s
 * STATUS:   behavioural
 *
 * Reproduces: the 302-entry table clear, both counter resets, and the parse of
 * the source-config INI. The loop counter is a `register long` because the
 * original keeps it in D7 and saves only D7 on entry.
 */
extern long  TEXTDISP_SourceConfigEntryTable[];
extern long  TEXTDISP_SourceConfigEntryCount;
extern char  TEXTDISP_SourceConfigFlagMask;
extern char  Global_STR_DF0_SOURCECFG_INI_2[];
extern void  PARSEINI_ParseIniBufferAndDispatch(char *path);

void TEXTDISP_LoadSourceConfig(void)
{
    register long i;

    for (i = 0; i < 302; i++)
        TEXTDISP_SourceConfigEntryTable[i] = 0;

    TEXTDISP_SourceConfigEntryCount = 0;
    TEXTDISP_SourceConfigFlagMask = 0;
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_SOURCECFG_INI_2);
}
