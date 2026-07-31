/* RESTORES: TEXTDISP_BuildEntryShortName
 * MODULE:   modules/groups/b/a/textdisp3_p1_p1_p0.s
 * STATUS:   behavioural
 *
 * Produces a short display name for an entry: the alias if one is registered,
 * otherwise the entry's own name at +19 prefixed with the centre-align token.
 *
 * The output is EMPTIED FIRST (CLR.B (A2)) and stays empty on every path that
 * does not write it -- a null entry, a name of 8 characters or more, and an
 * empty name all leave the caller with "".
 *
 * The alias lookup returns a SHORT (the original EXT.L-widens the result before
 * comparing) and -1 means no alias. The alias's display text is at +4 of the
 * record, not +0.
 *
 * The length guard is `< 8 && != 0`, tested in that order, and both failures
 * leave the buffer empty rather than falling back to a raw copy.
 *
 * The two copies are inline strcpy (MOVE.B (A0)+,(A1)+ / BNE); the append at
 * the end is the shared STRING_AppendAtNull rather than a third copy.
 *
 * 132 ref vs 120 got. Both inline strcpy loops, the inline strlen, the MOVEQ #8
 * length bound, the MOVEQ #-1 alias test, the ASL.L #2 table index and the
 * append call all match in kind and size.
 *
 * SASC-MISMATCH: link-frame-and-spill
 *   ref:     4e55fff4 ... 2b50fffc 226dfffc ... 4e5d
 *            LINK.W A5,#-12 / MOVE.L (A0),-4(A5) / MOVEA.L -4(A5),A1 / UNLK
 *   got:     2250                 MOVEA.L (A0),A1
 *   summary: the original writes the alias record pointer into a frame slot and
 *            immediately reads it back into an address register, with nothing
 *            in between. 6.51 loads it straight. The frame plus the
 *            store/reload round trip is the 12 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: widen-before-vs-after-copy
 *   ref:     2e00 48c7 70ff be80    MOVE.L D0,D7 / EXT.L D7 / MOVEQ #-1 / CMP.L
 *   got:     2e00 70ff be40 ... 48c7
 *                                   the compare happens at word width first
 *   summary: the original widens the alias index and compares in long; 6.51
 *            compares the word and widens afterwards. Same test, same result.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

struct TextDispAliasRecord {
    char *name;                 /* +0 */
    char *display;              /* +4 */
};

struct TextDispNameEntry {
    char pad0[19];
    char name19[32];            /* +19 */
};

extern short TEXTDISP_FindAliasIndexByName(struct TextDispNameEntry *e);
extern void  STRING_AppendAtNull(char *dst, char *src);

extern struct TextDispAliasRecord *TEXTDISP_AliasPtrTable[];
extern char TEXTDISP_CenterAlignToken[];

void TEXTDISP_BuildEntryShortName(struct TextDispNameEntry *e, char *out)
{
    short idx;
    long  len;

    *out = 0;
    if (e == 0)
        return;

    idx = TEXTDISP_FindAliasIndexByName(e);
    if (idx != -1) {
        strcpy(out, TEXTDISP_AliasPtrTable[idx]->display);
    } else {
        len = (long)strlen(e->name19);
        if (len < 8 && len != 0) {
            strcpy(out, TEXTDISP_CenterAlignToken);
            STRING_AppendAtNull(out, e->name19);
        }
    }
}
