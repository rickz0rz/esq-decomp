/* RESTORES: TEXTDISP_AddSourceConfigEntry
 * MODULE:   modules/groups/b/a/textdisp.s
 * STATUS:   behavioural
 *
 * 160 bytes in the original and 160 emitted, 6 differing regions -- and here the
 * residual is only register allocation and the frame, so the size agreement is
 * real rather than coincidental.
 *
 * Reproduces: the table slot address computed from the count BEFORE the
 * allocation is attempted and parked on the stack across the call, the
 * allocation of a six-byte entry with MEMF_CLEAR, the count incremented only on
 * success, the owned-string install through ReplaceOwnedString, the case-folded
 * tag comparison that sets the flag byte to 8 on a match, and the unconditional
 * OR of that byte into the global mask -- which on the non-matching path ORs in
 * whatever MEMF_CLEAR left, i.e. zero.
 *
 * The entry is written with explicit offsets rather than a struct, deliberately.
 * With DATA=FAR a wrong struct offset is invisible to cdiff (see the caveat in
 * diskio_write_buffered_bytes.c), so for a two-field record read straight off the
 * listing, explicit offsets are the more honest encoding: they cannot silently
 * disagree with the assembly the way a guessed struct can.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff8                   LINK.W A5,#-8
 *   got:     594f                       SUBQ.W #4,A7
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */
#include <exec/memory.h>

extern void *MEMORY_AllocateMemory(char *who, long line, long size, long flags);
extern char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(char *newstr, char *old);
extern long  STRING_CompareNoCase(char *a, char *b);
extern long  TEXTDISP_SourceConfigEntryCount;
extern unsigned char *TEXTDISP_SourceConfigEntryTable[];
extern char *TEXTDISP_PtrPrevueSportsTag;
extern unsigned char TEXTDISP_SourceConfigFlagMask;
extern char Global_STR_TEXTDISP_C_4[];

void TEXTDISP_AddSourceConfigEntry(char *name, char *tag)
{
    unsigned char *e;

    /* entry is 6 bytes: an owned string pointer at +0 and a flag byte at +4 */
    TEXTDISP_SourceConfigEntryTable[TEXTDISP_SourceConfigEntryCount] =
        MEMORY_AllocateMemory(Global_STR_TEXTDISP_C_4, 1229, 6,
                              MEMF_PUBLIC | MEMF_CLEAR);

    e = TEXTDISP_SourceConfigEntryTable[TEXTDISP_SourceConfigEntryCount];
    if (e == 0)
        return;

    TEXTDISP_SourceConfigEntryCount++;

    *(char **)e = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(name, *(char **)e);

    if (STRING_CompareNoCase(tag, TEXTDISP_PtrPrevueSportsTag) == 0)
        e[4] = 8;

    TEXTDISP_SourceConfigFlagMask |= e[4];
}
