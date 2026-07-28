/* RESTORES: _TLIBA2_ResolveEntryWindowAndSlotCount
 * MODULE:   modules/groups/b/a/tliba2_p0_tliba2_resolveentrywindowandslotcount.s
 * STATUS:   behavioural
 *
 * Work out the time window and slot count for a listing entry, writing both into
 * the caller's two-long output block. There are two completely different ways to
 * get there and the first one that works wins:
 *
 *   1. PARSE IT OUT OF THE ENTRY TEXT. Only when bit 0 of `flags` is set and bit
 *      1 of the entry's own flag byte is set. Looks for a quote, then '(' after
 *      it, then ')' after that, then ':' -- and gives up to route 2 if ANY of the
 *      four is missing. On success it reads "(h:mm)" style numbers out in place,
 *      NUL-terminating at the ':' and again at the ')' and RESTORING both
 *      characters afterwards, so the entry text is left exactly as found. Returns
 *      the slot count as it stood on entry, which on this path is always 0.
 *
 *   2. COUNT SLOTS BY SCANNING. Walk forward from the given index while entries
 *      are absent or unset, counting as it goes; then, if nothing was found, take
 *      the first wildcard match and scan its secondary tables the same way. The
 *      count accumulates across both scans.
 *
 * The two scans differ in one detail worth keeping: the second also requires bit
 * 7 of the title flag byte to be clear before it stops, so a flagged title ends
 * the scan where an unflagged one continues it.
 *
 * Finally, if bit 0 of `flags` is set, the count is halved into out[0] and
 * 30 * (count % 2) goes into out[1] -- i.e. the count is a number of half-hour
 * slots and the remainder becomes 30 minutes.
 *
 * The group and entry blocks are the same shapes as in
 * textdisp_find_entry_match_index.c: a flag byte per entry at +7, a pointer per
 * entry at +56 (7 + 49 == 56, which is what fixes the 49 bound), and the entry's
 * bit array at +28.
 *
 * 460 against 480 -- UNDER by 20, and the direction is expected: the A5 frame
 * class removes the frame, and the two elided division-helper calls are 12 bytes
 * on their own (MOVEQ #2,D1 / JSR / MOVEQ #30,D0 / JSR). SHORTINT gives 468 and
 * is left off, the widths here being long throughout.
 *
 * SASC-MISMATCH: division-helper
 *   summary: -12 of the -20. The original CALLS MATH_DivS32 and MATH_Mulu32 to divide the count
 *            by 2 and multiply the remainder by 30, having ALREADY computed the
 *            same halving inline immediately before (ASR.L #1 with the
 *            negative-operand correction). SAS/C inlines both, so the two calls
 *            disappear. Those helpers take their arguments in D0/D1 and return a
 *            quotient in D0 AND a remainder in D1, which C cannot express as one
 *            call anyway -- `count / 2` and `count % 2` are the only way to say
 *            it, and they are what the original computes.
 *   tried:   nothing reaches it; a divmod returning two registers is not a C
 *            construct. `__asm` register parameters could pass the arguments but
 *            still could not observe the second return value.
 *   scope:   every function using these two helpers together.
 *   retest:  a compiler that emits the library call for a /2 on a long.
 */

struct TextDispGroup {
    unsigned char  pad[7];
    unsigned char  flags[49];
    unsigned char *text[49];
};

struct TextDispEntry {
    unsigned char  pad[28];
    unsigned char  bits[1];
};

extern struct TextDispEntry *TEXTDISP_SecondaryEntryPtrTable[];
extern struct TextDispGroup *TEXTDISP_SecondaryTitlePtrTable[];

extern char *TLIBA2_FindLastCharInString(char *s, long ch);
extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern long  TLIBA2_JMPTBL_ESQ_TestBit1Based(unsigned char *bits, long index);
extern long  TLIBA_FindFirstWildcardMatchIndex(struct TextDispGroup *g);

long TLIBA2_ResolveEntryWindowAndSlotCount(struct TextDispEntry *entry,
                                           struct TextDispGroup *group,
                                           long index, long *out, long flags)
{
    long count = 0;
    long found = 0;
    long wild;
    char *quote, *open, *close, *colon;
    struct TextDispEntry *wEntry;
    struct TextDispGroup *wGroup;

    if ((flags & 1) && (group->flags[index] & 2)) {
        quote = TLIBA2_FindLastCharInString((char *)group->text[index], 34L);
        if (quote) {
            open = TLIBA2_FindLastCharInString(quote, 40L);
            if (open) {
                close = TLIBA2_FindLastCharInString(open, 41L);
                if (close) {
                    colon = TLIBA2_FindLastCharInString(open, 58L);
                    if (colon) {
                        *colon = 0;
                        if (open[1] == 32)
                            out[0] = PARSE_ReadSignedLongSkipClass3_Alt(open + 2);
                        else
                            out[0] = PARSE_ReadSignedLongSkipClass3_Alt(open + 1);
                        *colon = ':';
                        *close = 0;
                        out[1] = PARSE_ReadSignedLongSkipClass3_Alt(colon + 1);
                        *close = ')';
                        return count;
                    }
                }
            }
        }
    }

    if (group->text[index]) {
        index++;
        count++;
    }

    while (index < 49) {
        if (TLIBA2_JMPTBL_ESQ_TestBit1Based(entry->bits, index) + 1 != 0) {
            found = 1;
            break;
        }
        if (group->text[index]) {
            found = 1;
            break;
        }
        index++;
        count++;
    }

    if (!found) {
        wild = TLIBA_FindFirstWildcardMatchIndex(group);
        if (wild + 1 != 0) {
            wEntry = TEXTDISP_SecondaryEntryPtrTable[wild];
            wGroup = TEXTDISP_SecondaryTitlePtrTable[wild];
            index = 1;
            while (index < 49) {
                if (TLIBA2_JMPTBL_ESQ_TestBit1Based(wEntry->bits, index) + 1 != 0)
                    break;
                if (wGroup->text[index] && !(wGroup->flags[index] & 0x80))
                    break;
                index++;
                count++;
            }
        }
    }

    if (flags & 1) {
        out[0] = count / 2;
        out[1] = 30 * (count % 2);
    }

    return count;
}
