/* RESTORES: GCOMMAND_CopyGfxToWorkIfAvailable
 * MODULE:   modules/groups/a/t/gcommand2.s
 * STATUS:   behavioural
 *
 * Copies the graphics volume into WORK:, but only if both volumes are actually
 * present. Presence is tested by taking a shared lock and immediately releasing
 * it -- the lock is never held across the copy.
 *
 * The lock handle is zeroed after each UnLock even though nothing reads it again;
 * that is in the original and is kept.
 *
 * 116 bytes in the original -- 114 of code plus a trailing DC.W 0 -- against 114
 * emitted plus one alignment NOP. Size-exact, and the only divergences are the
 * two A6 habits.
 *
 * SASC-MISMATCH: a6-in-save-mask
 *   summary: A6 added to the MOVEM mask. Same four bytes, no cost. Sixth sighting.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     2c790000d930   DOSBase loaded after the first argument is set up
 *   got:     the same load hoisted above it
 *   summary: +6 / -6, no net cost. The load moves rather than disappearing,
 *            because both compilers load it exactly once here.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit calls.
 */
#include <proto/dos.h>

extern long GROUP_AT_JMPTBL_DOS_SystemTagList(char *cmd, void *tags);
extern void GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0(void);
extern void GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1(void);

extern char GCOMMAND_PATH_GFX_COLON[];
extern char GCOMMAND_STR_WORK_COLON[];
extern char GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_LOGO_DOT_LS[];
extern char GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_WORK_COLON_[];

void GCOMMAND_CopyGfxToWorkIfAvailable(void)
{
    long lock;
    long rc;

    lock = 0;
    rc = 0;

    lock = Lock(GCOMMAND_PATH_GFX_COLON, -2L);
    if (lock == 0)
        return;
    UnLock(lock);
    lock = 0;

    lock = Lock(GCOMMAND_STR_WORK_COLON, -2L);
    if (lock == 0)
        return;
    UnLock(lock);
    lock = 0;

    rc = GROUP_AT_JMPTBL_DOS_SystemTagList(
             GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_LOGO_DOT_LS, 0L);
    rc = GROUP_AT_JMPTBL_DOS_SystemTagList(
             GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_WORK_COLON_, 0L);
    GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0();
    GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1();
}
