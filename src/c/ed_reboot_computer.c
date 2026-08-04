/* RESTORES: ED_RebootComputer
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: loop-shape
 *   ref:     48e703004eba1f922e004a076630487900001dec48780078487800282f39000087024ebacf1e4fef00107c000c86000aae606c065286528660f24eba09764eba1f7a4cdf00c04e75
 *   got:     2f07610000004a00662e48790000000048780078487800282f3900000000610000004fef00107e000c87000aae606c04548760f461000000610000002e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void *Global_REF_RASTPORT_1;
extern char  Global_STR_REBOOTING_COMPUTER[];
extern long  ED_IsConfirmKey(void);
extern void  DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern void  ESQ_ColdReboot(void);
extern void  ED_DrawESCMenuBottomHelp(void);
void ED_RebootComputer(void)
{
    long i;

    if ((char)ED_IsConfirmKey() == 0) {
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 120,
                                      Global_STR_REBOOTING_COMPUTER);
        for (i = 0; i < 0xaae60L; i += 2)
            ;
        ESQ_ColdReboot();
    }
    ED_DrawESCMenuBottomHelp();
}
