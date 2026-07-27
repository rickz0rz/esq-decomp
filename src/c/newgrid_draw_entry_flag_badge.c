/* RESTORES: NEWGRID_DrawEntryFlagBadge
 * MODULE:   modules/groups/b/a/newgrid1.s
 * STATUS:   behavioural
 *
 * 172 bytes in the original, 168 emitted, 11 differing regions.
 *
 * Reproduces: the unconditional layout setup done before any test, the four-stage
 * qualification (entry present, bit 4 of byte 27, the flag-Y test, and a non-null
 * animation field), the flag-byte update, the six-argument detail layout on the
 * qualifying path, and the plain append on every other path.
 *
 * The layout parameters are set FIRST, before the entry is even checked for null.
 * That ordering matters -- the fallback append relies on the layout already being
 * configured, so hoisting the null check above the setup would leave the fallback
 * drawing with whatever the previous caller left behind.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc                   LINK.W A5,#-4
 *   got:     594f                       SUBQ.W #4,A7
 *   summary: The A5-frame class, in its mild form -- both keep a stack slot, only
 *            the base register differs.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the six cross-unit calls.
 */
extern void  NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(long w, long lines, long pen);
extern long  NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1(unsigned char *e, long row, long k);
extern void *NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(unsigned char *e, long row, long k);
extern void  NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes(unsigned char *e, long row);
extern void  NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource(void *dst, char *fmt, long a,
                                                           void *anim, long b, void *src);
extern void  NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(void *dst, void *src);
extern char  NEWGRID_EntryDetailFmtStr[];

void NEWGRID_DrawEntryFlagBadge(void *dst, unsigned char *entry, short row,
                                void *src, long pen)
{
    void *anim;

    NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612, 20, pen);

    if (entry && (entry[27] & 0x10)
        && NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1(entry, (long)row, 5)) {
        anim = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entry, (long)row, 6);
        if (anim) {
            NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes(entry, (long)row);
            NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource(dst, NEWGRID_EntryDetailFmtStr,
                                                          19, anim, 20, src);
            return;
        }
    }

    NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(dst, src);
}
