/* RESTORES: ED_SaveEverythingToDisk
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     2f074eba20342e004a076624487900001d984878005a487800282f39000087024ebacfc0487800014ebab4ec4fef00144eba20282e1f4e75
 *   got:     2f07610000002e004a0766244879000000004878005a487800282f39000000006100000048780001610000004fef0014610000002e1f4e75
 *   summary: Identical length and identical apart from the call opcode. The
 *            original encodes every call here as 4EBA, JSR (d16,PC); SAS/C 6.51
 *            emits 6100, BSR.W. Both are four bytes with a 16-bit PC-relative
 *            displacement, so this is a pure encoding choice.
 *   tried:   OPTIMIZE, OPTSIZE, OPTTIME, NOOPTPEEP -- none change the opcode.
 *   scope:   The original uses BOTH forms. BSR.W appears where the displacement
 *            is small (0x0092, 0x0330, 0xff12, 0xfebe) and JSR (d16,PC) where it
 *            is large (0x2034, 0xcfc0, 0xb4ec, 0x3e36). That correlates with
 *            whether the callee was in the same translation unit, which a
 *            one-function-per-file restoration can never reproduce: every call
 *            we emit is cross-unit by construction. See docs/compiler-version.md.
 *   retest:  SAS/C 6.00 emits 4EBA for all calls, so it matches this function's
 *            shape but breaks the BSR.W ones. A version that picks per-callee is
 *            what is wanted.
 */
extern long ED_IsConfirmKey(void);
extern void ED_DrawESCMenuBottomHelp(void);
extern void *Global_REF_RASTPORT_1;
extern char Global_STR_SAVING_EVERYTHING_TO_DISK[];
extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern void DISKIO2_RunDiskSyncWorkflow(long full);
void ED_SaveEverythingToDisk(void)
{
    register char confirmed = (char)ED_IsConfirmKey();
    if (!confirmed) {
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 90,
                                      Global_STR_SAVING_EVERYTHING_TO_DISK);
        DISKIO2_RunDiskSyncWorkflow(1);
    }
    ED_DrawESCMenuBottomHelp();
}
