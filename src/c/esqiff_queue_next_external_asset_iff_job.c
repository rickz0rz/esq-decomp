/* RESTORES: ESQIFF_QueueNextExternalAssetIffJob
 * MODULE:   modules/groups/a/n/esqiff_p1.s
 * STATUS:   behavioural
 *
 * Picks the next logo or G-ads image to load from a text list and hands it to
 * the IFF task. It answers 1 when a job was queued and -1 when there was
 * nothing to do.
 *
 * THE THREE ENTRY GUARDS RUN UNDER Forbid AND EACH HAS ITS OWN Permit. The
 * quotas differ by source -- one logo brush is enough to refuse, but G-ads
 * needs two -- and the source select is re-read for each test rather than
 * cached, so a change between them is honoured.
 *
 * WHICH LIST IS SCANNED IS AN AND, NOT AN OR: the logo list is scanned only if
 * its data blob is loaded AND the source select is nonzero; the G-ads list only
 * if ITS blob is loaded AND the select is zero. Neither combination means there
 * is nothing to do.
 *
 * THE SCAN TERMINATES ON WRAPAROUND, not on a count: it reads entries until the
 * list line index comes back to where it started. An empty path does not end
 * the scan, it just skips to that test.
 *
 * THE LOGO PATH IS PROBED BY WILDCARD. A '!' in the path is replaced by '*' and
 * the string TRUNCATED there, then the basename is matched against the entry
 * table. So `CBS!05` becomes `CBS*` and matches any CBS entry. The truncation
 * writes the terminator at the byte AFTER the one it replaced, which is why the
 * loop breaks immediately after.
 *
 * THE G-ADS PATH IS ACCEPTED BY PREFIX REJECTION, the opposite way round: a
 * path starting with `DF0:` or `RAM:LOGOS/` is REJECTED (those match, and a
 * match leaves the found flag clear); anything else is accepted. Reading the
 * comparison's zero-means-equal convention backwards inverts the whole filter.
 *
 * THE POLL LIMIT IS COMPUTED AND NEVER USED. Both arms store a constant --
 * 0xfa00 for logos, 0x13880 for G-ads -- into a frame slot that nothing reads
 * afterwards. It is dead in the shipped program and is kept here because
 * removing it would hide that the original computed a timeout.
 *
 * THE RETRY LOOP CANNOT RETRY. The result word is set to 1 at the top of the
 * loop body and the two tests that would trigger a re-read or another pass both
 * ask whether it is -1. It never is, so the body runs exactly once, the
 * snapshot always matches the current path, and control falls to the exit. The
 * loop and both -1 tests are in the original and are reproduced; the timeout
 * machinery they belong to is not wired up.
 *
 * THE DUPLICATE CHECK ONLY EVER LOOKS AT THE LOGO HEAD. It selects a head by
 * source, but then compares that head against the LOGO head specifically -- so
 * on the G-ads path the equality fails and no duplicate is ever detected. Also
 * in the original.
 *
 * The descriptor type byte at +190 is 4 for logos and 5 for G-ads, and the
 * pending-descriptor global differs per source as well.
 *
 * 660 ref vs 672 got, 26 differing regions. All three quota guards with their
 * differing thresholds and their individual Permits, the two-part list
 * selection, the wraparound scan, the wildcard rewrite with its truncation,
 * both prefix comparisons with their lengths, the dead poll limit, the snapshot
 * copy, the logo-only duplicate check, both descriptor type bytes, the task
 * start and both -1 tests match in kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ff70 ... 2b40ff7a   LINK.W A5,#-144 / MOVE.L D0,-134(A5)
 *   got:     the found flag and the saved index kept in registers
 *   summary: the frame class. Three 40-byte buffers dominate the frame, so the
 *            12-byte difference is in the scalars around them.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>
#include "esq-exec.h"

struct IffNode {
    char          pad0[190];
    unsigned char b190;                 /* +190 */
};

extern void  ESQIFF_ReadNextExternalAssetPathEntry(char *buf);
extern char *GCOMMAND_FindPathSeparator(char *s);
extern short ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard(char *s);
extern long  ESQIFF_JMPTBL_STRING_CompareNoCaseN(char *a, char *b, long n);
extern void  ESQDISP_ProcessGridMessagesIfIdle(void);
extern struct IffNode *ESQIFF_JMPTBL_BRUSH_AllocBrushNode(char *path,
                                                          void *prev);
extern void  ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(void);

extern short CTASKS_IffTaskDoneFlag;
extern short ESQIFF_AssetSourceSelect;
extern long  ESQIFF_LogoBrushListCount;
extern long  ESQIFF_GAdsBrushListCount;
extern short ESQIFF_LogoListLineIndex;
extern short ESQIFF_ExternalAssetPathCommaFlag;
extern short ESQIFF_ExternalAssetStateTable;
extern short TEXTDISP_CurrentMatchIndex;
extern long  Global_REF_LONG_DF0_LOGO_LST_DATA;
extern long  Global_REF_LONG_GFX_G_ADS_DATA;
extern char *ESQIFF_LogoBrushListHead;
extern char *ESQIFF_GAdsBrushListHead;
extern struct IffNode *ESQIFF_PendingExternalBrushNode;
extern struct IffNode *CTASKS_PendingLogoBrushDescriptor;
extern struct IffNode *CTASKS_PendingGAdsBrushDescriptor;
extern char  ESQIFF_PATH_DF0_COLON[];
extern char  ESQIFF_PATH_RAM_COLON_LOGOS_SLASH[];

short ESQIFF_QueueNextExternalAssetIffJob(void)
{
    struct IffNode *node;
    char *head;
    char *p;
    char  path[40];
    char  probe[40];
    char  snapshot[40];
    long  duplicate;
    long  pollLimit;
    long  j;
    short found;
    short result;
    short startIdx;
    short savedIdx;

    duplicate = 0;

    Forbid();

    if (CTASKS_IffTaskDoneFlag == 0) {
        Permit();
        return 0;
    }

    if (ESQIFF_AssetSourceSelect != 0 && ESQIFF_LogoBrushListCount >= 1) {
        Permit();
        return 0;
    }

    if (ESQIFF_AssetSourceSelect == 0 && ESQIFF_GAdsBrushListCount >= 2) {
        Permit();
        return 0;
    }

    Permit();

    path[0] = 0;
    startIdx = ESQIFF_LogoListLineIndex;
    found = 0;

    if (!((Global_REF_LONG_DF0_LOGO_LST_DATA != 0
           && ESQIFF_AssetSourceSelect != 0)
          || (Global_REF_LONG_GFX_G_ADS_DATA != 0
              && ESQIFF_AssetSourceSelect == 0)))
        goto finalizeNoCandidate;

    savedIdx = TEXTDISP_CurrentMatchIndex;

    for (;;) {

        ESQIFF_ReadNextExternalAssetPathEntry(path);

        if (strlen(path) != 0) {

            if (ESQIFF_AssetSourceSelect != 0) {

                if (ESQIFF_ExternalAssetPathCommaFlag != 0) {
                    found = 1;
                    break;
                }

                for (j = 0; j < 40; j++) {
                    probe[j] = path[j];
                    if (probe[j] == 0)
                        break;
                    if (probe[j] == 33) {
                        probe[j]     = 42;
                        probe[j + 1] = 0;
                        break;
                    }
                }

                p = GCOMMAND_FindPathSeparator(probe);

                if (ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard(p) == 1) {
                    found = 1;
                    ESQIFF_ExternalAssetStateTable = TEXTDISP_CurrentMatchIndex;
                    break;
                }

                ESQDISP_ProcessGridMessagesIfIdle();

            } else {

                if (ESQIFF_JMPTBL_STRING_CompareNoCaseN(ESQIFF_PATH_DF0_COLON,
                                                        path, 4L) == 0)
                    break;

                if (ESQIFF_JMPTBL_STRING_CompareNoCaseN(
                        ESQIFF_PATH_RAM_COLON_LOGOS_SLASH, path, 11L) == 0)
                    break;

                found = 1;
                break;
            }
        }

        if (ESQIFF_LogoListLineIndex == startIdx)
            break;
    }

    TEXTDISP_CurrentMatchIndex = savedIdx;

    if (found == 0)
        goto finalizeNoCandidate;

    if (ESQIFF_AssetSourceSelect != 0)
        pollLimit = 0xfa00;
    else
        pollLimit = 0x13880;

    strcpy(snapshot, path);

    do {
        result = 1;

        ESQDISP_ProcessGridMessagesIfIdle();

        if (ESQIFF_AssetSourceSelect != 0)
            head = ESQIFF_LogoBrushListHead;
        else
            head = ESQIFF_GAdsBrushListHead;

        if (head != 0 && head == ESQIFF_LogoBrushListHead
            && strcmp(path, head) == 0)
            duplicate = 1;

        if (duplicate == 0) {

            node = ESQIFF_JMPTBL_BRUSH_AllocBrushNode(path, 0);
            ESQIFF_PendingExternalBrushNode = node;

            if (ESQIFF_AssetSourceSelect != 0) {
                node->b190 = 4;
                CTASKS_PendingLogoBrushDescriptor = node;
            } else {
                node->b190 = 5;
                CTASKS_PendingGAdsBrushDescriptor = node;
            }

            ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess();
        }

        ESQDISP_ProcessGridMessagesIfIdle();

        if (result == -1)
            ESQIFF_ReadNextExternalAssetPathEntry(path);

        if (strcmp(snapshot, path) == 0)
            goto finalizeNoCandidate;

    } while (result == -1);

finalizeNoCandidate:
    if (found == 0)
        result = -1;

    return result;
}
