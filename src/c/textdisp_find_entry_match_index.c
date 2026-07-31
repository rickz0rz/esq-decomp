/* RESTORES: _TEXTDISP_FindEntryMatchIndex
 * MODULE:   modules/groups/b/a/textdisp3_p1_p1_textdisp_findentrymatchindex_textdisp_findentrymatchindex.s
 * STATUS:   behavioural
 *
 * Search the active group's 49 entries for the first one whose text matches the
 * caller's search string, returning its index or 49 for "no match". `mode`
 * selects where the scan starts:
 *
 *   1  resume after the previous match, falling back to the group default
 *   2  start one past the current half-hour slot
 *   3  resume from one BEFORE the previous match, same fallback
 *   *  start at 1
 *
 * Modes 1 and 3 ask DISPLIB_FindPreviousValidEntryIndex where to resume and then
 * REJECT its answer unless the resumed entry has bit 7 of its flag byte clear;
 * on rejection they fall back to the same default as mode 2 minus the +1. That
 * double condition is the reason both arms are written out rather than folded.
 *
 * THE 49 IS AN ARRAY BOUND, NOT A MAGIC NUMBER. The group block addresses a byte
 * per entry at +7 and a pointer per entry at +56, and 7 + 49 == 56 exactly -- so
 * the flags array is 49 bytes and the text-pointer array starts immediately
 * after it. That is why the scan and the "no match" return share the constant.
 * Hence struct TextDispGroup below rather than cast-and-add arithmetic.
 *
 * Matching is done on a QUOTED SPAN, not the raw string, and both sides are
 * temporarily NUL-terminated in place and restored afterwards -- including on
 * every early exit from the loop, which is why the restore is a labelled tail
 * rather than sitting inside the `if`. The comparison is exact-and-equal-length
 * (STRING_CompareNoCase) when the search string was quoted, and a case-folded
 * substring search otherwise.
 *
 * A match needs BOTH flags: the control-token check (tokenOk) and the text
 * comparison (textMatch). Either alone continues the scan.
 *
 * NEEDS SHORTINT: 732 bytes against 718 with it, 748 without. Declared in
 * src/c/scopts.txt, which exists because a BEHAVIOURAL file cannot carry an
 * options column in replacements.txt (that manifest is the byte-exact gate) --
 * before scopts.txt this compiled without the option and nothing said so.
 *
 * SASC-MISMATCH: dispatch-arm-layout
 *   summary: +14 over 718, spread across many small regions that largely cancel
 *            (casm.py: swings of +10/+20 against -24/-18 around the mode-dispatch
 *            arms). The code generator ordered the three mode arms and their
 *            shared fallbacks differently; no single idiom accounts for the
 *            residual, and per AGENTS.md rule 3 it is recorded as a
 *            known-unknown rather than attributed by guesswork.
 *   tried:   with and without SHORTINT (748 / 732). The mode tests are written in
 *            the original's order (2, then 1, then 3) as an if/else chain, which
 *            is what produces its independent MOVEQ/CMP.W per test rather than a
 *            switch's chained subtract -- a switch here is measurably worse.
 *   scope:   this function. The A5-frame and cross-unit-call classes also apply
 *            and cap it at behavioural regardless.
 *   retest:  a compiler that reserves A5; re-measure the residual before
 *            theorising about the arm ordering.
 */

#include <string.h>

struct TextDispGroup {
    unsigned char  pad[7];
    unsigned char  flags[49];
    unsigned char *text[49];
};

struct TextDispEntry {
    unsigned char  pad[28];
    unsigned char  bits[1];
};

extern short TEXTDISP_ActiveGroupId;
extern short CLOCK_HalfHourSlotIndex;
extern short TEXTDISP_CurrentMatchIndex;

extern unsigned char *TEXTDISP_FindControlToken(unsigned char *s);
extern long TEXTDISP_FindQuotedSpan(unsigned char *s, unsigned char **span,
                                    unsigned char *tok, long *quoted);
extern long STRING_CompareNoCase(unsigned char *a, unsigned char *b);
extern struct TextDispGroup *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(long i, long mode);
extern struct TextDispEntry *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(long i, long mode);
extern long TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(struct TextDispEntry *e,
                                                              struct TextDispGroup *g,
                                                              long count);
extern long TLIBA2_JMPTBL_ESQ_TestBit1Based(unsigned char *bits, long index);
extern long TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(unsigned char *hay,
                                                     unsigned char *needle);

long TEXTDISP_FindEntryMatchIndex(unsigned char *input, short mode, char flagMask)
{
    struct TextDispGroup *group;
    struct TextDispEntry *entry;
    unsigned char *inSpan, *entSpan;
    unsigned char *inTok, *entTok;
    unsigned char *entryText;
    unsigned char  savedInChar, savedEntChar;
    long inQuoted, entQuoted;
    long inLen, entLen;
    long tokenOk, textMatch;
    short idx;

    inSpan = entSpan = 0;
    tokenOk = textMatch = 0;

    if (!*input)
        return 49;

    if (TEXTDISP_ActiveGroupId == 1)
        idx = CLOCK_HalfHourSlotIndex;
    else
        idx = 1;

    if (TEXTDISP_ActiveGroupId == 1) {
        group = TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(TEXTDISP_CurrentMatchIndex, 1L);
        entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(TEXTDISP_CurrentMatchIndex, 1L);
    } else {
        group = TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(TEXTDISP_CurrentMatchIndex, 2L);
        entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(TEXTDISP_CurrentMatchIndex, 2L);
    }

    if (mode == 2) {
        if (TEXTDISP_ActiveGroupId == 1)
            idx = CLOCK_HalfHourSlotIndex + 1;
        else
            idx = 1;
    } else if (mode == 1) {
        idx = TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(entry, group, idx);
        if (idx == 0 || (group->flags[idx] & 0x80)) {
            if (TEXTDISP_ActiveGroupId == 1)
                idx = CLOCK_HalfHourSlotIndex;
            else
                idx = 1;
        }
    } else if (mode == 3) {
        idx = TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(entry, group, idx - 1);
        if (idx == 0 || (group->flags[idx] & 0x80)) {
            if (TEXTDISP_ActiveGroupId == 1)
                idx = CLOCK_HalfHourSlotIndex;
            else
                idx = 1;
        }
    } else {
        idx = 1;
    }

    inTok = TEXTDISP_FindControlToken(input);
    inLen = TEXTDISP_FindQuotedSpan(input, &inSpan, inTok, &inQuoted);
    savedInChar = inSpan[inLen];
    inSpan[inLen] = 0;

    while (idx < 49) {
        if (group->text[idx]
            && (group->flags[idx] & flagMask) == flagMask
            && TLIBA2_JMPTBL_ESQ_TestBit1Based(entry->bits, idx) + 1 == 0) {

            entryText = group->text[idx];
            entTok = TEXTDISP_FindControlToken(entryText);
            textMatch = tokenOk = 0;

            if (!inTok)
                tokenOk = 1;
            else if (entTok && *inTok == *entTok)
                tokenOk = 1;

            if (tokenOk == 1) {
                entLen = TEXTDISP_FindQuotedSpan(entryText, &entSpan, entTok, &entQuoted);
                savedEntChar = entSpan[entLen];
                entSpan[entLen] = 0;

                if (inQuoted) {
                    if (entQuoted && inLen == entLen)
                        textMatch = (STRING_CompareNoCase(inSpan, entSpan) == 0);
                } else if (inLen <= entLen) {
                    textMatch = (TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(entSpan, inSpan) != 0);
                }

                entSpan[entLen] = savedEntChar;
            }

            if (textMatch && tokenOk)
                break;
        }
        idx++;
    }

    inSpan[inLen] = savedInChar;
    return idx;
}
