/* RESTORES: UNKNOWN_ParseListAndUpdateEntries
 * MODULE:   modules/submodules/unknown.s   (1 of its 12 labels)
 * STATUS:   behavioural
 *
 * The 'w' record handler, and the larger half of the RBF weather protocol. It
 * reads a list of forecast records off the serial buffer and fills the four
 * WDISP_StatusDayEntry slots the banner draws from.
 *
 * Despite living in `submodules/`, this is ESQ's OWN code and not SAS/C
 * runtime -- the same point esqproto_parse.c makes about its neighbours.
 *
 * THE WIRE FORMAT, read off the entry rather than guessed:
 *
 *     list name, up to 11 bytes, terminated by 18 (0x12)
 *     one byte  -> TLIBA1_DayEntryModeCounter
 *     then, per record, while the leading byte is '+':
 *         3 bytes   day of year, decimal
 *         1 byte    kind, or '?'
 *         3 bytes   high, or '?' in the first column
 *         3 bytes   low,  or '?' in the first column
 *         1 byte    the next record's leading byte
 *
 * A record whose day matches no slot is SKIPPED, and the skip is 7 bytes --
 * exactly 1 + 3 + 3, the three fields it did not read. That arithmetic is the
 * check that the field widths above are right.
 *
 * '?' MEANS TWO DIFFERENT THINGS. In the kind column it becomes 1; in the two
 * temperature columns it becomes -999, which is the sentinel
 * wdisp_draw_weather_status_day_entry.c already tests for. The original really
 * does use different constants for the same character, so this is not a
 * simplification waiting to happen.
 *
 * THE SLOTS ARE PRIMED BEFORE ANY RECORD IS READ. Each of the four gets
 * forecast = 1 and a day-of-year of today + slot + 1, normalised through
 * DST_NormalizeDayOfYear. So a list that names no day at all still leaves four
 * consecutive dated slots behind.
 *
 * THE SEARCH LOOP READS ONE SLOT PAST THE ARRAY, and that is faithful. The
 * original tests for equality FIRST and only then checks whether the index has
 * reached 4, so slot 4 -- twenty bytes past the end of a four-slot table -- is
 * compared before the loop stops. It cannot matter: an index of 4 fails the
 * `<= 3` test immediately after and the record is skipped either way. The C
 * below keeps the same order rather than hoisting the bound test, because
 * hoisting it would change which bytes are read.
 *
 * THE DAY VALUE IS TRUNCATED TO A WORD BEFORE THE COMPARISON. The original
 * parses a long and then does MOVE.L D6,D0 / EXT.L D0, which keeps the low
 * word and sign-extends it. A four-digit day would therefore match on its low
 * word alone. Written as `(long)(short)` so the narrowing is visible.
 *
 * SASC-MISMATCH: argument-slot-reuse
 *   ref:     the CopyPadNul block and the ReadSignedLong block overlap -- the
 *            original pushes 12 bytes, then 4 more, and pops all 16 at once
 *            with `LEA 16(A7),A7`
 *   got:     each call builds and pops its own block
 *   summary: same arguments reach both callees. The original saves the pops by
 *            letting the blocks overlap. Six sites in this function.
 *   scope:   several call-pair sites in the program; esqproto_parse.c records
 *            the same divergence.
 *   retest:  a compiler that defers argument-stack cleanup across calls.
 *
 * THE ENTRY ADDRESS IS RECOMPUTED PER FIELD, ON PURPOSE. The original has
 * EIGHT `_MATH_Mulu32(index, 20)` call sites -- one in the search loop and one
 * in each arm of the four field stores -- and never keeps the entry pointer in
 * a register across them. AGENTS.md's guidance table says hoisting
 * `p = &table[i]` collapses repeated index multiplies, and it does; that is why
 * the first attempt at this function came out 106 bytes SHORT of the reference
 * with no structural disagreement. Two things had to change to get the
 * multiply back:
 *
 *   - the stride lives in a LOCAL. Written against the literal 20, SAS/C
 *     strength-reduces `idx * 20` into shifts and adds and emits no call at
 *     all. This is the same lever AGENTS.md records for
 *     tliba1_draw_formatted_text_block.c, in the direction that ADDS code.
 *   - the address is spelled out at every site through the ENTRY macro rather
 *     than hoisted into `e`.
 *
 * The result is eight `__CXM33` calls where the original has eight
 * `_MATH_Mulu32` calls, and those are the same routine: unknown22_p0.s exports
 * MATH_Mulu32 under SAS/C's name, and in a maximum-C build both resolve to
 * lib_math_helpers.c.
 *
 * 648 bytes against 602. `tools/casm.py` itemises the whole +46 and says so on
 * its last line, so nothing here is unattributed. 23 of the 49 aligned hunks
 * are byte-identical; the rest are small idiom differences, the largest single
 * item being +12. The two structural ones are the missing LINK/UNLK frame
 * (SAS/C addresses locals off A7 here) and the argument-slot-reuse entry
 * above.
 */
struct WDayEntry {                  /* 20 bytes */
    long f0;                        /* 0  day of year, normalised */
    long kind;                      /* 4  brush selector, 1 when '?' */
    long high;                      /* 8  -999 = unknown */
    long low;                       /* 12 -999 = unknown */
    long forecast;                  /* 16 non-zero = multi-line forecast */
};

extern struct WDayEntry WDISP_StatusDayEntry0[];
extern char  WDISP_StatusListMatchPattern[];
extern unsigned char TLIBA1_DayEntryModeCounter;
extern short CLOCK_CurrentDayOfYear;
extern short CLOCK_CurrentYearValue;

extern char  ESQ_WildcardMatch(char *pattern, char *text);
extern short DST_NormalizeDayOfYear(short day, short year);
extern void  STRING_CopyPadNul(char *dst, char *src, long n);
extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s);

/* One entry address, recomputed from the index every time -- see the header. */
#define ENTRY(i) ((struct WDayEntry *)((char *)WDISP_StatusDayEntry0 \
                                       + (i) * stride))

void UNKNOWN_ParseListAndUpdateEntries(char *buf)
{
    char  name[13];
    char  field[8];
    char *src = buf;
    struct WDayEntry *e;
    long  stride = 20;
    long  idx;
    long  day;
    short i;
    char  c;
    unsigned char marker;

    i = 0;
    for (;;) {
        c = *src++;
        name[i] = c;
        if (c == 18)
            break;
        if (i >= 10)
            break;
        i++;
    }
    name[i] = 0;

    if (name[0] == 0)
        return;
    if (ESQ_WildcardMatch(WDISP_StatusListMatchPattern, name) != 0)
        return;

    for (i = 0; i < 4; i++) {
        e = &WDISP_StatusDayEntry0[i];
        e->forecast = 1;
        e->f0 = DST_NormalizeDayOfYear((short)(CLOCK_CurrentDayOfYear + i + 1),
                                       CLOCK_CurrentYearValue);
    }

    TLIBA1_DayEntryModeCounter = (unsigned char)*src++;
    marker = (unsigned char)*src++;

    while (marker == '+') {
        STRING_CopyPadNul(field, src, 3L);
        field[3] = 0;
        day = PARSE_ReadSignedLongSkipClass3_Alt(field);
        src += 3;

        /* Equality first, bound second -- see the header. */
        idx = 0;
        for (;;) {
            if ((long)(short)day == ENTRY(idx)->f0)
                break;
            if (idx >= 4)
                break;
            idx++;
        }
        if (idx < 0 || idx > 3)
            marker = 0;

        if (marker != '+') {
            src += 7;
            marker = (unsigned char)*src++;
            continue;
        }

        ENTRY(idx)->forecast = 0;

        STRING_CopyPadNul(field, src, 1L);
        field[1] = 0;
        if (field[0] == '?')
            ENTRY(idx)->kind = 1;
        else
            ENTRY(idx)->kind = PARSE_ReadSignedLongSkipClass3_Alt(field);
        src += 1;

        STRING_CopyPadNul(field, src, 3L);
        field[3] = 0;
        if (field[0] == '?')
            ENTRY(idx)->high = -999;
        else
            ENTRY(idx)->high = PARSE_ReadSignedLongSkipClass3_Alt(field);
        src += 3;

        STRING_CopyPadNul(field, src, 3L);
        field[3] = 0;
        if (field[0] == '?')
            ENTRY(idx)->low = -999;
        else
            ENTRY(idx)->low = PARSE_ReadSignedLongSkipClass3_Alt(field);
        src += 3;

        marker = (unsigned char)*src++;
    }
}
