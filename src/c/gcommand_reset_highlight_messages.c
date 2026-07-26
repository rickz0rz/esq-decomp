/* RESTORES: GCOMMAND_ResetHighlightMessages
 * MODULE:   modules/groups/a/u/gcommand3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fff82f074ab9000068ae672a2079000068ae21790000b30200142079000068ae21790000b30600182079000068ae21790000b30a001c7e002b7c0000a49afffc7004be806c18206dfffc426800344228003652877050d080d1adfffc60e27062720041f900005e9610c151c8fffc2e1f4e5d4e75
 *   got:     48e703144bf9000000004ab900000000672a20790000000021790000000000142079000000002179000000000018207900000000217900000000001c7e007004be806c10426d0034422d0036dafc00a0528760ea47f9000000007c62421b200653464a4066f64cdf28c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long *ESQPARS2_SnapshotLivePlane0Base;
struct MsgSlot { char pad[52]; short w; char b; };
extern struct MsgSlot GCOMMAND_HighlightMessageSlotTable[];
extern char ESQPARS2_BannerQueueBuffer[];
struct HighlightMsg { char pad[20]; long f20; long f24; long f28; };
extern struct HighlightMsg *GCOMMAND_ActiveHighlightMsgPtr;
extern long GCOMMAND_ActiveMsgSavedField20, GCOMMAND_ActiveMsgSavedField24, GCOMMAND_ActiveMsgSavedField28;

void GCOMMAND_ResetHighlightMessages(void)
{
    struct MsgSlot *s = GCOMMAND_HighlightMessageSlotTable;
    long i;
    short n;
    char *q;

    if (GCOMMAND_ActiveHighlightMsgPtr != 0) {
        GCOMMAND_ActiveHighlightMsgPtr->f20 = GCOMMAND_ActiveMsgSavedField20;
        GCOMMAND_ActiveHighlightMsgPtr->f24 = GCOMMAND_ActiveMsgSavedField24;
        GCOMMAND_ActiveHighlightMsgPtr->f28 = GCOMMAND_ActiveMsgSavedField28;
    }
    for (i = 0; i < 4; i++) {
        s->w = 0;
        s->b = 0;
        s = (struct MsgSlot *)((char *)s + 160);
    }
    q = ESQPARS2_BannerQueueBuffer;
    n = 98;
    do {
        *q++ = 0;
    } while (n--);
}
