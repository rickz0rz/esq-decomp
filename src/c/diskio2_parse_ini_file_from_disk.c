/* RESTORES: DISKIO2_ParseIniFileFromDisk
 * MODULE:   modules/groups/a/h/diskio2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     4eba0b224879000005b84eba5c0a584f4e75
 *   got:     6100000048790000000061000000584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char CTASKS_PATH_QTABLE_INI[];
extern void GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers(void);
extern void GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(char *path);
void DISKIO2_ParseIniFileFromDisk(void)
{
    GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers();
    GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(CTASKS_PATH_QTABLE_INI);
}
