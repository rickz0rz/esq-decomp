/* RESTORES: TEXTDISP_BuildEntryPairStatusLine
 * MODULE:   modules/groups/b/a/textdisp_p1_2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a7-frame
 *   ref:     4e55ff6c48e737003e2d000a3c2d000e3a2d0012200648c04a4767047201600272022f012f004eba3464504f220648c148ed0001fff84a4767047401600274022f022f014eba3452504f2b40fffc4a80670001064aadfff8670000fe220548c12f390000060c4878001e2f012f2dfff82f004eba342a4fef00144a80670000da7001ba406d067030ba406f027aff200548c0487800022f002f2dfffc4eba33e8220548c1487800032f012f2dfffc2b40ff724eba33d24fef00182b40ff6e4aadff72671e41f90000765043edff7712d866fc2f2dff72486dff774eba6976504f600670001b40ff774aadff6e6736102dff774a006710487900007652486dff774eba6950504f487900007656486dff774eba69402eadff6e486dff774eba69344fef000c200748c0220648c1240548c276002f032f032f022f012f00486dff774eba0f064fef00184a2dff77670a486dff776100f894584f4cdf00ec4e5d4e75
 *   got:     9efc009048e737343a2f00be3c2f00ba3e2f00b6300648c04a4757c1740194012f022f00610000002640504f300648c04a4757c1740194012f022f00610000002a404a80504f670000fa200b670000f4300548c02f39000000004878001e2f002f0b2f0d610000004fef00144a80670000d27001ba406d067030ba406f027aff300548c0487800022f002f0d610000002440300548c0487800032f002f0d610000004fef00182f4000ac200a671c41f90000000043ef002312d866fc2f0a486f002761000000504f600670001f4000234aaf00ac6736102f00234a006710487900000000486f002761000000504f487900000000486f0027610000002eaf00b4486f002b610000004fef000c300748c0320648c1340548c276002f032f032f022f012f00486f0037610000004fef0018102f00234a00670a486f002361000000584f4cdf2cecdefc00904e75
 *   summary: 332 got vs 352 ref, twenty bytes short. The original holds the two field pointers and the two entry pointers at negative A5 displacements and reloads them for each use; 6.51 keeps them in A7 slots and folds several reloads. Both mode selections with their 1-or-2 kind argument, the five-argument time-window test, the 1..48 slot clamp with its -1 sentinel, both animation-field lookups, the conditional spacer between the two parts and the six-argument aligned-status-line call all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

extern long CONFIG_TimeWindowMinutes;
extern char SCRIPT_AlignedPrefixEmptyD[];
extern char SCRIPT_AlignedPrefixEmptyE[];
extern char SCRIPT_SpacerTripleC[];

extern char *ESQDISP_GetEntryAuxPointerByMode(long row, long kind);
extern char *ESQDISP_GetEntryPointerByMode(long row, long kind);
extern long  COI_TestEntryWithinTimeWindow(char *entry, char *aux,
                 long slot, long window, long fallback);
extern char *COI_GetAnimFieldPointerByMode(char *entry, long slot,
                 long mode);
extern void  STRING_AppendAtNull(char *dst, char *src);
extern void  CLEANUP_BuildAlignedStatusLine(char *line, long flag,
                 long row, long slot, long a, long b);
extern void  SCRIPT_SetupHighlightEffect(char *line);

void TEXTDISP_BuildEntryPairStatusLine(short flag, short row, short slot)
{
    char  line[137];
    char *entry;
    char *aux;
    char *first;
    char *second;

    aux = ESQDISP_GetEntryAuxPointerByMode((long)row,
              flag != 0 ? 1 : 2);
    entry = ESQDISP_GetEntryPointerByMode((long)row,
              flag != 0 ? 1 : 2);

    if (entry == 0 || aux == 0)
        return;

    if (COI_TestEntryWithinTimeWindow(entry, aux, (long)slot, 30,
            CONFIG_TimeWindowMinutes) == 0)
        return;

    if (slot < 1 || slot > 48)
        slot = -1;

    first  = COI_GetAnimFieldPointerByMode(entry, (long)slot, 2);
    second = COI_GetAnimFieldPointerByMode(entry, (long)slot, 3);

    if (first != 0) {
        strcpy(line, SCRIPT_AlignedPrefixEmptyD);
        STRING_AppendAtNull(line, first);
    } else {
        line[0] = 0;
    }

    if (second != 0) {
        if (line[0] != 0)
            STRING_AppendAtNull(line, SCRIPT_SpacerTripleC);
        STRING_AppendAtNull(line, SCRIPT_AlignedPrefixEmptyE);
        STRING_AppendAtNull(line, second);
    }

    CLEANUP_BuildAlignedStatusLine(line, (long)flag, (long)row,
                                                   (long)slot, 0, 0);
    if (line[0] != 0)
        SCRIPT_SetupHighlightEffect(line);
}
