/* RESTORES: _PARSEINI_ParseRangeKeyValue
 * MODULE:   modules/groups/b/a/parseini_p1_2_parseini_parserangekeyvalue.s
 * STATUS:   behavioural
 *
 * Parse one `key = value` line from the range/colour section of an INI file and
 * apply it. Splits the line in place at the '=' -- NUL-terminating both halves
 * and trimming each on its own delimiter set -- then dispatches on the key:
 *
 *   TABLE = DONE    hand the finished table to the validator and reset the
 *                   current row to -1, ending the section
 *   COLORn = v      select row n (0..15) and store v+1 as its entry count,
 *                   or -1 if v is outside 1..63
 *   a = b           with a row selected, store hex value b at slot a of that row
 *
 * THE TABLE LAYOUT IS UNUSUAL AND THE ADDRESSING PROVES IT. Row n lives at
 * n * 128, and its data words start at +32 -- but the per-row COUNT for row n is
 * read from byte offset n * 2, i.e. from the first 32 bytes of the table, which
 * is row 0's own pad area. So the counts array and row 0's header occupy the same
 * storage. Modelled as `struct RangeRow` with both fields so the two addressing
 * modes are stated rather than hidden behind casts, and indexed as
 * `table[0].count[n]` versus `table[n].v[a]` to keep that visible.
 *
 * Every parsed number is truncated to a SHORT before being tested -- the original
 * takes a long back from the parse helper and immediately does TST.W / CMP.W, so
 * the sign and range checks see the low word only. Declaring the locals `short`
 * reproduces that; using longs would test a different value.
 *
 * The '=' search runs on the RAW line before any trimming, so a key containing
 * leading whitespace still splits correctly; the trimming happens afterwards on
 * each half. That ordering is why the pointer bookkeeping looks redundant.
 *
 * 488 against 492, and the struct layout is CHECKED rather than assumed: the
 * size-independent LEA (d16,An),Am count (AGENTS.md rule 2, the only test that
 * can see a wrong offset -- cdiff masks relocated fields) is 0 in the reference
 * against 1 here. Equal counts would mean addressing memory exactly as the
 * original does; the single excess is `key + 5`, where the original uses
 * ADDQ.L #5,A0 and 6.51 emits an LEA. The table addressing itself contributes
 * none, which is the part that mattered.
 *
 * SASC-MISMATCH: pointer-bump-idiom
 *   ref:     ADDQ.L #5,A0                (2 bytes)
 *   got:     LEA 5(A0),A0                (4 bytes)
 *   summary: -4 overall, so the excess above is more than paid for elsewhere by
 *            the A5 frame class. Not itemised beyond the LEA, which is the one
 *            difference worth naming because it is the fidelity proxy.
 *   tried:   SHORTINT is byte-identical here (488 either way), so the option is
 *            not load-bearing and is left off.
 *   scope:   small pointer offsets generally.
 *   retest:  a compiler that emits ADDQ for a small constant pointer bump.
 */

struct RangeRow {
    short count[16];   /* +0  -- only meaningful in row 0; see above */
    short v[48];       /* +32 -- 128 bytes per row total */
};

extern long PARSEINI_CurrentRangeTableIndex;
extern char PARSEINI_DelimSpaceTab_RangeKey[];
extern char PARSEINI_DelimSpaceSemicolonTab_RangeValue[];
extern char PARSEINI_TAG_TABLE[];
extern char PARSEINI_TAG_DONE[];
extern char PARSEINI_TAG_COLOR[];

extern char *PARSEINI_JMPTBL_STR_FindCharPtr(char *s, long ch);
extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(char *s);
extern char *PARSEINI_JMPTBL_STR_FindAnyCharPtr(char *s, char *set);
extern long  PARSEINI_JMPTBL_STRING_CompareNoCaseN(char *a, char *b, long n);
extern void  PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable(struct RangeRow *t);
extern long  SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern long  PARSEINI_ParseHexValueFromString(char *s);

void PARSEINI_ParseRangeKeyValue(char *line, struct RangeRow *table)
{
    char *key = line;
    char *value;
    char *end;
    char *p;
    short index;
    short slot;
    short hex;

    if (line)
        value = PARSEINI_JMPTBL_STR_FindCharPtr(line, 61L);   /* '=' */
    else
        value = 0;

    if (key && value) {
        key = NEWGRID2_JMPTBL_STR_SkipClass3Chars(key);
        end = PARSEINI_JMPTBL_STR_FindAnyCharPtr(key, PARSEINI_DelimSpaceTab_RangeKey);
        if (end)
            *end = 0;

        *value++ = 0;
        value = NEWGRID2_JMPTBL_STR_SkipClass3Chars(value);
        end = PARSEINI_JMPTBL_STR_FindAnyCharPtr(
                  value, PARSEINI_DelimSpaceSemicolonTab_RangeValue);
        if (end)
            *end = 0;
    }

    if (!key || !value)
        return;

    if (PARSEINI_JMPTBL_STRING_CompareNoCaseN(key, PARSEINI_TAG_TABLE, 5L) == 0
        && PARSEINI_JMPTBL_STRING_CompareNoCaseN(value, PARSEINI_TAG_DONE, 4L) == 0) {
        PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable(table);
        PARSEINI_CurrentRangeTableIndex = -1;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCaseN(key, PARSEINI_TAG_COLOR, 5L) == 0) {
        p = key + 5;
        index = 0;
        if (p && *p)
            index = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(p);

        if (index < 0 || index >= 16) {
            PARSEINI_CurrentRangeTableIndex = -1;
        } else {
            PARSEINI_CurrentRangeTableIndex = index;
            table[0].count[index] = 0;
        }

        if (PARSEINI_CurrentRangeTableIndex < 0
            || PARSEINI_CurrentRangeTableIndex >= 16)
            return;

        slot = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(value);
        if (slot < 1 || slot > 63)
            slot = -1;
        else
            slot++;
        table[0].count[PARSEINI_CurrentRangeTableIndex] = slot;
        return;
    }

    if (PARSEINI_CurrentRangeTableIndex < 0
        || PARSEINI_CurrentRangeTableIndex >= 16)
        return;
    if (table[0].count[PARSEINI_CurrentRangeTableIndex] <= 0)
        return;

    slot = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(key);
    hex  = PARSEINI_ParseHexValueFromString(value);

    if (slot <= 0)
        return;
    if (slot >= table[0].count[PARSEINI_CurrentRangeTableIndex])
        return;
    if (hex < 0)
        return;
    if (hex >= 0x1000)
        return;

    table[PARSEINI_CurrentRangeTableIndex].v[slot] = hex;
}
