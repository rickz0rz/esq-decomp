/* RESTORES: ESQSHARED_UpdateMatchingEntriesByTitle
 * MODULE:   modules/groups/a/p/esqshared_esqshared_replacetvratingtoken_esqshared_replacetvratingtoken.s
 * STATUS:   behavioural
 *
 * Walks a group's entries, and for every one whose title matches a wildcard
 * pattern, writes a listing string into one time slot -- rewriting a trailing
 * duration and a bracketed clock time on the way.
 *
 * THE SLOT ARGUMENT CARRIES A FLAG IN BIT 6. The caller passes one byte; bit
 * 0x40 is a "force" flag and the low six bits are the slot number. The flag is
 * extracted BEFORE the mask, so a caller that sets it does not corrupt the slot.
 * Slots outside 1..48 are rejected, and the compare is UNSIGNED, so a byte with
 * the high bit set fails the low test rather than the high one.
 *
 * The force flag inverts the meaning of the slot's occupancy bit. Without it,
 * an entry whose bit is already SET is skipped. With it, the entry is processed
 * and the bit is set. So the flag means "overwrite" rather than "fill".
 *
 * WILDCARD MATCH RETURNS ZERO FOR A MATCH. The original branches away on a
 * NONZERO result, so the whole body runs on zero. Reading it the usual way
 * round inverts the entire function.
 *
 * The group is chosen by comparing the caller's code against the secondary
 * group first and the primary second, and the secondary only wins if its
 * present flag is exactly 1. That test is repeated INSIDE the loop rather than
 * hoisted, which is why the table selection appears twice below.
 *
 * THE DURATION REWRITE KEYS OFF THE LAST SIX BYTES OF THE TEXT. Having appended
 * the filtered title, the code looks backwards from the terminator for a
 * parenthesised duration and recognises TWO layouts, distinguished only by
 * where the open parenthesis sits:
 *
 *   ...(h:mm)   '(' at end-6, ':' at end-4, ')' at end-1   -> hours present
 *   ...(:mm)    '(' at end-5, ':' at end-4, ')' at end-1   -> minutes only
 *
 * Both are tested, in that order, and each sets its own flag. The minutes are
 * always read from end-3 and end-2; the hours digit, when there is one, from
 * end-5. If neither layout matches, the whole rewrite is skipped.
 *
 * The rewrite builds its replacement in a 50-byte allocation and then copies it
 * back over the text starting at end-6 -- SIX bytes back regardless of which
 * layout matched, so the shorter form loses one character before the
 * parenthesis. That is the original's arithmetic.
 *
 * WHEN THERE ARE NO MINUTES the code does not skip the minutes text; it appends
 * the hours text, then DELETES THE LAST CHARACTER of the buffer and appends a
 * closing parenthesis over it. So "(2 hours " becomes "(2 hours)". The
 * back-up-one-and-append is the only place the trailing space is removed.
 *
 * The allocation is freed only if the pointer is non-null, and the free passes
 * the same 50-byte size the allocation used.
 *
 * THE BRACKETED CLOCK PATCH EDITS THE STRING IN PLACE AND IS FULL OF DIGITS
 * THAT MAY NOT BE DIGITS. Each of the four character positions after '[' is
 * checked against class-table bit 2 and contributes ZERO when it fails, so a
 * malformed time yields a number rather than an error. The offset is added to
 * the minutes, the minutes carry into the hours at 60, and the hours wrap at 12
 * -- by REPEATED SUBTRACTION, not by modulo, which is why both are loops.
 *
 * The hours are then written back tens-digit-first, and a leading zero is
 * rendered as a SPACE rather than '0'. The minutes are written back with two
 * separate divisions rather than one division and a remainder.
 *
 * ONE OF THE FOUR DIVISIONS IS A DIFFERENT INSTRUCTION. Three go through
 * MATH_DivS32; the tens digit of the hours uses an inline `DIVS #10` and stores
 * its quotient BACK over the hours variable. The C below reproduces that by
 * assigning `h = h / 10` before the test, which is what makes the following
 * comparison read the quotient rather than the original value.
 *
 * A _Return LABEL MEANS THE REFERENCE STOPS EARLY. The epilogue is branched to
 * from four places, so the disassembly gave it its own label and refbytes.py
 * extracts label-to-label -- the reference for this function ends BEFORE its
 * MOVEM/UNLK/RTS. Those are 8 bytes that any C restoration necessarily
 * includes, so 8 must be added to the reference before the delta means
 * anything. The figure below already has that correction applied and says so.
 *
 * 1360 ref vs 1384 got, 26 differing regions. Correcting the reference to 1368
 * for the missing epilogue, the candidate is 16 bytes over a 1368-byte
 * function. The 0x40 flag split, the unsigned 1..48 bound, both group
 * selections, the WildcardMatch zero test, TestBit1Based and SetBit1Based with
 * their +0x22 bitset address, both duration layout tests with their end-relative
 * offsets, the allocation and its matching free, all six SPrintf and
 * AppendAtNull calls, the delete-and-close-paren fixup, the copy back to end-6,
 * all four class-table digit guards, both wrap loops, the DIVS #10 with its
 * write-back, ReplaceOwnedString, DST_BuildBannerTimeWord,
 * AdjustBracketedHourInString and both flag ORs match in kind and size.
 *
 * WRITE strlen, NOT AN INDEX LOOP -- worth 20 bytes here, and for a reason
 * worth recording because it is the opposite of the usual one. The original
 * scans with `MOVEA.L A2,A0 / MOVEA.L A0,A1 / TST.B (A1)+ / BNE / SUBQ.L #1 /
 * SUBA.L A0,A1`. Written as `while (base[len] != 0) len++;` 6.51 does not emit
 * that scan AT ALL -- it restructures the loop around the later uses of the
 * index and the whole 32-byte region collapses to 12 bytes of stores. Calling
 * `strlen` puts the pointer scan back. So the index form was not merely
 * different, it was SHORTER and less faithful, which is the trap AGENTS.md
 * rule 1 warns about.
 *
 * SASC-MISMATCH: frame-base-vs-stack-base
 *   ref:     1b40ffe2 1b40ffe3 2b48ffe4   MOVE.B D0,-30(A5) and friends
 *   got:     1f40004c 1f40004d 2f480078   the same stores addressed from A7
 *   summary: the A5 class, at every one of this function's twenty-odd frame
 *            slots. Each A7-addressed store of a byte costs the same as the A5
 *            one, so this is not where the bytes go -- it is recorded because
 *            it is what makes a byte comparison of the frame region meaningless
 *            rather than because it is expensive.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

extern char  ESQSHARED_JMPTBL_ESQ_WildcardMatch(char *title, char *pattern);
extern short ESQSHARED_JMPTBL_ESQ_TestBit1Based(char *bits, long slot);
extern void  ESQSHARED_JMPTBL_ESQ_SetBit1Based(char *bits, long slot);
extern void  ESQSHARED_ApplyProgramTitleTextFilters(char *text, long b27);
extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                 long size, long flags);
extern void  ESQIFF_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                   void *p, long size);
extern void  GROUP_AW_JMPTBL_WDISP_SPrintf(char *dst, char *fmt, long v);
extern void  GROUP_AR_JMPTBL_STRING_AppendAtNull(char *dst, char *src);
extern char *ESQPARS_ReplaceOwnedString(char *newStr, char *old);
extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(char *s, long ch);
extern short ESQSHARED_JMPTBL_DST_BuildBannerTimeWord(long slot, long b498);
extern void  ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString(char *s, long w);

struct EsqEntry {
    char          pad0[27];
    unsigned char b27;                  /* +27 */
    char          pad28[6];
    char          bits[6];              /* +34 = 0x22 */
    unsigned char f40;                  /* +40 */
};

struct EsqTitle {
    char          pad0[7];
    unsigned char flags[49];            /* +7  */
    char         *slots[49];            /* +56 */
    char          pad252[246];
    unsigned char b498;                 /* +498 */
};

extern struct EsqEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern struct EsqTitle *TEXTDISP_PrimaryTitlePtrTable[];
extern struct EsqEntry *TEXTDISP_SecondaryEntryPtrTable[];
extern struct EsqTitle *TEXTDISP_SecondaryTitlePtrTable[];

extern unsigned char WDISP_CharClassTable[];
extern char  TEXTDISP_PrimaryGroupCode;
extern char  TEXTDISP_SecondaryGroupCode;
extern char  TEXTDISP_PrimaryGroupPresentFlag;
extern char  TEXTDISP_SecondaryGroupPresentFlag;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern char  CLOCK_FormatVariantCode;

extern char Global_STR_ESQPARS2_C_1[];
extern char Global_STR_ESQPARS2_C_2[];
extern char ESQPARS2_DurationFmt_DecimalWithSpace[];
extern char ESQPARS2_DurationFmt_OpenParenHours[];
extern char ESQPARS2_DurationFmt_OpenParenMinutes[];
extern char ESQPARS2_DurationFmt_CloseParen[];
extern char SCRIPT_StrHourSingularSuffix[];
extern char SCRIPT_StrHoursPluralSuffix[];
extern char SCRIPT_StrMinutesSuffix[];

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

long ESQSHARED_UpdateMatchingEntriesByTitle(char *pattern, char groupCode,
                                            char slotAndFlag, char value,
                                            char *text)
{
    struct EsqEntry *entry;
    struct EsqTitle *title;
    char  *end;
    char  *base;
    char  *buf;
    char  *mem;
    char  *p;
    char   force;
    char   slot;
    char   hasHours;
    char   hasMinutesOnly;
    char   b1[10];
    char   b2[10];
    short  i;
    short  count;
    short  bit;
    short  h;
    short  m;
    long   hours;
    long   minutes;
    long   len;
    long   d;

    force = slotAndFlag & 0x40;
    slot  = slotAndFlag & 0x3f;

    if ((unsigned char)slot < 1 || (unsigned char)slot > 48)
        return 0;

    if (TEXTDISP_SecondaryGroupCode == groupCode
        && TEXTDISP_SecondaryGroupPresentFlag == 1)
        count = TEXTDISP_SecondaryGroupEntryCount;
    else if (groupCode == TEXTDISP_PrimaryGroupCode)
        count = TEXTDISP_PrimaryGroupEntryCount;
    else
        return 0;

    for (i = 0; i < count; i++) {

        if (groupCode == TEXTDISP_SecondaryGroupCode
            && TEXTDISP_SecondaryGroupPresentFlag == 1) {
            entry = TEXTDISP_SecondaryEntryPtrTable[i];
            title = TEXTDISP_SecondaryTitlePtrTable[i];
        } else {
            entry = TEXTDISP_PrimaryEntryPtrTable[i];
            title = TEXTDISP_PrimaryTitlePtrTable[i];
        }

        if (ESQSHARED_JMPTBL_ESQ_WildcardMatch(title->pad0, pattern) != 0)
            continue;

        bit = ESQSHARED_JMPTBL_ESQ_TestBit1Based(entry->bits, (long)slot);

        if (force == 0 && bit != 0)
            continue;

        if (force != 0)
            ESQSHARED_JMPTBL_ESQ_SetBit1Based(entry->bits, (long)slot);

        title->flags[slot] = value;

        ESQSHARED_ApplyProgramTitleTextFilters(text, (long)entry->b27);

        base = text;
        len  = strlen(base);
        end  = base + len;

        hasMinutesOnly = hasHours = 0;

        if (end[-1] == 41 && end[-4] == 58 && end[-6] == 40)
            hasHours = 1;

        if (end[-1] == 41 && end[-4] == 58 && end[-5] == 40)
            hasMinutesOnly = 1;

        if (hasHours != 0 || hasMinutesOnly != 0) {

            minutes = hours = 0;
            buf = mem = 0;

            mem = buf = ESQIFF_JMPTBL_MEMORY_AllocateMemory(
                            Global_STR_ESQPARS2_C_1, 720L, 50L,
                            MEMF_PUBLIC | MEMF_CLEAR);

            if (hasHours != 0)
                hours = (long)end[-5] - 48;

            minutes = ((long)end[-3] - 48) * 10 + (long)end[-2] - 48;

            if (hours > 0) {
                GROUP_AW_JMPTBL_WDISP_SPrintf(
                    b1, ESQPARS2_DurationFmt_DecimalWithSpace, minutes);
                GROUP_AW_JMPTBL_WDISP_SPrintf(
                    b2, ESQPARS2_DurationFmt_OpenParenHours, hours);
                GROUP_AR_JMPTBL_STRING_AppendAtNull(buf, b2);

                if (hours == 1)
                    GROUP_AR_JMPTBL_STRING_AppendAtNull(
                        buf, SCRIPT_StrHourSingularSuffix);
                else
                    GROUP_AR_JMPTBL_STRING_AppendAtNull(
                        buf, SCRIPT_StrHoursPluralSuffix);
            } else {
                GROUP_AW_JMPTBL_WDISP_SPrintf(
                    b1, ESQPARS2_DurationFmt_OpenParenMinutes, minutes);
            }

            if (minutes > 0) {
                GROUP_AR_JMPTBL_STRING_AppendAtNull(buf, b1);
                GROUP_AR_JMPTBL_STRING_AppendAtNull(buf,
                                                    SCRIPT_StrMinutesSuffix);
            } else {
                d = strlen(buf);
                buf[d - 1] = 0;
                GROUP_AR_JMPTBL_STRING_AppendAtNull(
                    buf, ESQPARS2_DurationFmt_CloseParen);
            }

            {
                char *dst = end - 6;
                char *src = buf;
                while ((*dst++ = *src++) != 0)
                    ;
            }

            if (mem != 0)
                ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS2_C_2,
                                                      765L, mem, 50L);
        }

        title->slots[slot] = ESQPARS_ReplaceOwnedString(text,
                                                        title->slots[slot]);

        if ((unsigned char)CLOCK_FormatVariantCode > 0) {

            p = GROUP_AS_JMPTBL_STR_FindCharPtr(title->slots[slot], 91L);

            if (p != 0) {

                if (WDISP_CharClassTable[(long)p[1]] & 4)
                    h = (short)(((long)p[1] - 48) * 10);
                else
                    h = 0;

                if (WDISP_CharClassTable[(long)p[2]] & 4)
                    h = h + (short)((long)p[2] - 48);

                if (WDISP_CharClassTable[(long)p[4]] & 4)
                    m = (short)(((long)p[4] - 48) * 10);
                else
                    m = 0;

                if (WDISP_CharClassTable[(long)p[5]] & 4)
                    m = m + (short)((long)p[5] - 48);

                m = m + (short)CLOCK_FormatVariantCode;

                while (m > 59) {
                    m -= 60;
                    h += 1;
                }

                while (h > 12)
                    h -= 12;

                p[2] = (char)(((h - (h / 10) * 10)) + 48);

                h = h / 10;
                if (h > 0)
                    p[1] = (char)(h + 48);
                else
                    p[1] = 32;

                p[4] = (char)((m / 10) + 48);
                p[5] = (char)(((m - (m / 10) * 10)) + 48);
            }
        }

        ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString(
            title->slots[slot],
            (long)ESQSHARED_JMPTBL_DST_BuildBannerTimeWord(
                      (long)slot, (long)title->b498));

        if (title->flags[slot] & 0x10)
            entry->f40 |= 1;

        entry->f40 |= 0x80;
    }

    return 0;
}
