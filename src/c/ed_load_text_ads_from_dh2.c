/* RESTORES: ED_LoadTextAdsFromDh2
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     2f074eba1fc82e004a076620487900001dd048780078487800282f39000087024ebacf544eba47ba4fef00104eba1fc02e1f4e75
 *   got:     2f07610000002e0020074a00662048790000000048780078487800282f390000000061000000610000004fef0010610000002e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void *Global_REF_RASTPORT_1;
extern char  Global_STR_LOADING_TEXT_ADS_FROM_DH2[];
extern long  ED_IsConfirmKey(void);
extern void  DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern void  LADFUNC_LoadTextAdsFromFile(void);
extern void  ED_DrawESCMenuBottomHelp(void);
void ED_LoadTextAdsFromDh2(void)
{
    long cancelled = ED_IsConfirmKey();

    if ((char)cancelled == 0) {
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 120,
                                      Global_STR_LOADING_TEXT_ADS_FROM_DH2);
        LADFUNC_LoadTextAdsFromFile();
    }
    ED_DrawESCMenuBottomHelp();
}
