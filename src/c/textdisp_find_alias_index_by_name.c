/* RESTORES: TEXTDISP_FindAliasIndexByName
 * MODULE:   modules/groups/b/a/textdisp3.s
 * STATUS:   behavioural
 *
 * Looks up an alias by the name field of the supplied record, comparing
 * case-insensitively over exactly the length of each candidate alias -- so a
 * stored alias is matched as a prefix of the supplied name, not as an equal
 * string. Returns the index, or -1.
 *
 * The name is copied to a local first. The copy is a plain byte loop terminated
 * by the NUL, which is what an inline strcpy of a char array emits.
 *
 * 100 bytes in the original, 108 emitted. The inline strcpy, the inline strlen of
 * each candidate, and the whole loop structure reproduce; the +8 is three small
 * items.
 *
 * SASC-MISMATCH: index-through-address-register
 *   ref:     41f9xxxx d1c0 2450 2052   LEA table,A0 / ADDA.L D0,A0 / MOVEA.L (A0),A2
 *   got:     41f9xxxx 2248 d3c0 ...    an extra MOVEA.L A0,A1 first
 *   summary: +4. The original folds the index into A0 directly; 6.51 keeps the
 *            table base and computes into a second register. Same family as
 *            gcommand_consume_banner_queue_entry.c, opposite direction.
 *
 * SASC-MISMATCH: return-width
 *   ref:     2007         MOVE.L D7,D0
 *   got:     3007 48c0    MOVE.W D7,D0 / EXT.L D0
 *   summary: +2. Returning the short loop counter as a long. The original copies
 *            the whole register; 6.51 widens explicitly. Related to the
 *            char-widen-move-width class in ladfunc_parse_hex_digit.c -- the
 *            original is consistently happy to move a full register where only
 *            part is meaningful.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   summary: +2 in the epilogue; ADDA.W where the original has UNLK.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the one cross-unit call.
 */
#include <string.h>

extern long STRING_CompareNoCaseN(char *a, char *b, long n);

extern short TEXTDISP_AliasCount;
extern char *TEXTDISP_AliasPtrTable[];

struct AliasQuery {
    char pad[12];
    char name[1];       /* 12 */
};

long TEXTDISP_FindAliasIndexByName(struct AliasQuery *query)
{
    char name[21];
    short i;

    strcpy(name, query->name);

    for (i = 0; i < TEXTDISP_AliasCount; i++) {
        if (STRING_CompareNoCaseN(name, TEXTDISP_AliasPtrTable[i],
                                  (long)strlen(TEXTDISP_AliasPtrTable[i])) == 0)
            return i;
    }

    return -1;
}
