/* RESTORES: COI_FormatEntryDisplayText
 * MODULE:   modules/groups/a/e/coi_p3_coi_formatentrydisplaytext.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a7-frame-and-part-array
 *   ref:     4e55ffd448e72730266d0008246d000c2e2d00102c2d001870ffbc80660822390000aa1a6006223c000005a02b41ffe4bc80660820390000aa1e600620390000060c240748c22f002f012f022f0a2f0b2b40ffe0610001ee4fef00144a8067000112200748c0487800012f002f0b6100fe304fef000c2b40ffec70ffbc80661291c82b48fff02b48fff42b48fff87c036040200748c0487800032f002f0b6100fe002b40fff0200748c0487800042f002f0b6100fdec2b40fff4200748c0487800022f002f0b6100fdd84fef00242b40fff8200748c02f062f002f0b6100dc424fef000c4a806746200748c0487800062f002f0b6100fdaa487800142f0048780013487900000466486dffd42b40ffdc4eba030241edffd42b48fffc200748c02e802f0b6100dc584fef0024600442adfffc7a007005ba806c382005e5804ab508ec672a207508ec4a10672248790000046e2f2d00144eba4d982005e5802eb508ec2f2d00144eba4d884fef000c528560c2
 *   got:     9efc002c48e707342c2f00582e2f0050246f0054266f004c2a6f004870ffbc80660a2f790000000000346008725ae9892f410034bc8066082a390000000060062a39000000002f46001c200748c02f052f2f00382f002f0b2f0d610000004fef00144a8067000118200748c0487800012f002f0d610000002f40002c4fef000c20065280661691c82f48002c2f4800282f48002470032f40001c6040200748c0487800032f002f0d610000002f400030200748c0487800042f002f0d610000002f400040200748c0487800022f002f0d610000002f4000504fef00242f2f001c2f072f0d610000004fef000c4a806742200748c0487800062f002f0d61000000487800142f0048780013487900000000486f00582f4000586100000041ef005c2f4800502e872f0d610000004fef0024600442af003042af0018202f00187205b0816c3a2200e5814ab71820672a207718204a1067224879000000002f0a61000000202f00202200e5812eb718282f0a610000004fef000c52af001860bc4cdf2ce0defc002c4e75
 *   summary: 392 got vs 370 ref. The five part pointers live in one array so the trailing loop can index them the way the original does, with -20(A5,D0.L); 6.51 addresses the same array from A7 and reloads the base each iteration. The two mode==-1 selections for the window and the tolerance, the five-argument window test, the four field lookups with their distinct mode numbers, the kind override to 3, the wrap-format SPrintf and the space-separated append loop all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long GCOMMAND_PpvSelectionWindowMinutes;
extern long GCOMMAND_PpvSelectionToleranceMinutes;
extern long CONFIG_TimeWindowMinutes;
extern char COI_FMT_WRAP_CHAR_STRING_CHAR[];
extern char COI_STR_SINGLE_SPACE[];

extern long  COI_TestEntryWithinTimeWindow(char *entry, char *aux, short slot,
                                           long window, long fallback);
extern char *COI_GetAnimFieldPointerByMode(char *entry, short slot, short mode);
extern long  CLEANUP_TestEntryFlagYAndBit1(char *entry, long slot, long kind);
extern void  CLEANUP_UpdateEntryFlagBytes(char *entry, long slot);
extern void  GROUP_AE_JMPTBL_WDISP_SPrintf(char *buf, char *fmt, long a,
                                           char *s, long b);
extern void  GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, char *src);

void COI_FormatEntryDisplayText(char *entry, char *aux, long slot, char *out,
                                long mode)
{
    char  buf[8];
    char *wrapped;
    long  tolerance;
    long  window;
    char *parts[5];
    long  kind;
    long  i;

    if (mode == -1)
        window = GCOMMAND_PpvSelectionWindowMinutes;
    else
        window = 1440;

    if (mode == -1)
        tolerance = GCOMMAND_PpvSelectionToleranceMinutes;
    else
        tolerance = CONFIG_TimeWindowMinutes;

    kind = mode;

    if (COI_TestEntryWithinTimeWindow(entry, aux, (short)slot, window,
                                      tolerance) == 0)
        return;

    parts[0] = COI_GetAnimFieldPointerByMode(entry, (short)slot, 1);

    if (mode == -1) {
        parts[1] = parts[2] = parts[3] = 0;
        kind = 3;
    } else {
        parts[1] = COI_GetAnimFieldPointerByMode(entry, (short)slot, 3);
        parts[2] = COI_GetAnimFieldPointerByMode(entry, (short)slot, 4);
        parts[3] = COI_GetAnimFieldPointerByMode(entry, (short)slot, 2);
    }

    if (CLEANUP_TestEntryFlagYAndBit1(entry, slot, kind) != 0) {
        wrapped = COI_GetAnimFieldPointerByMode(entry, (short)slot, 6);
        GROUP_AE_JMPTBL_WDISP_SPrintf(buf, COI_FMT_WRAP_CHAR_STRING_CHAR, 19,
                                      wrapped, 20);
        parts[4] = buf;
        CLEANUP_UpdateEntryFlagBytes(entry, slot);
    } else {
        parts[4] = 0;
    }

    for (i = 0; i < 5; i++) {
        if (parts[i] != 0 && *parts[i] != 0) {
            GROUP_AI_JMPTBL_STRING_AppendAtNull(out, COI_STR_SINGLE_SPACE);
            GROUP_AI_JMPTBL_STRING_AppendAtNull(out, parts[i]);
        }
    }
}
