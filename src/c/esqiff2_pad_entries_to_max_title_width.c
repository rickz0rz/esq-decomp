/* RESTORES: ESQIFF2_PadEntriesToMaxTitleWidth
 * MODULE:   modules/groups/a/o/esqiff2.s
 * STATUS:   behavioural
 *
 * 214 bytes in the original and 214 emitted -- the SIXTH size coincidence of the
 * run, 11 differing regions. Not a near-match.
 *
 * Reproduces: the group-code match selecting which table and count to use, the
 * re-test of the same code inside the loop (the original does not cache the
 * decision), the title measured from entry+1, the pad computed against
 * TEXTDISP_MaxEntryTitleLength and skipped when non-positive, the fixed
 * ten-iteration space fill followed by a NUL written at the pad length, and the
 * copy-back.
 *
 * The padding mechanism is worth stating because it reads backwards at first: the
 * original builds a run of spaces, appends the EXISTING TITLE onto that buffer,
 * then copies the whole thing back over the title. That is a LEFT pad -- the
 * title ends up right-aligned in the field. An implementation that appended
 * spaces to the title would be the obvious reading, would be the same length, and
 * would render everything left-aligned instead.
 *
 * NOTE the space buffer is filled to a fixed 10 characters regardless of the pad
 * width, and only then truncated with a NUL at [pad]. If pad ever exceeded 10 the
 * NUL would land past the filled region on uninitialised stack. Reproduced as
 * written; the guard is presumably that MaxEntryTitleLength keeps pad small.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffe8                   LINK.W A5,#-24
 *   got:     9efc0010                   SUBA.W #16,A7
 *   summary: The A5-frame class -- most of the 11 regions, since the space buffer
 *            is addressed on every loop iteration.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the cross-unit append call.
 */
#include <string.h>

extern void STRING_AppendAtNull(char *dst, char *src);
extern char  TEXTDISP_SecondaryGroupCode;
extern char  TEXTDISP_PrimaryGroupCode;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern short TEXTDISP_MaxEntryTitleLength;
extern unsigned char *TEXTDISP_SecondaryEntryPtrTable[];
extern unsigned char *TEXTDISP_PrimaryEntryPtrTable[];

long ESQIFF2_PadEntriesToMaxTitleWidth(char groupCode)
{
    char spaces[11];
    unsigned char *entry;
    short count;
    register short i;
    register short pad;
    register short j;

    if (TEXTDISP_SecondaryGroupCode == groupCode)
        count = TEXTDISP_SecondaryGroupEntryCount;
    else if (groupCode == TEXTDISP_PrimaryGroupCode)
        count = TEXTDISP_PrimaryGroupEntryCount;
    else
        return 0;

    for (i = 0; i < count; i++) {
        if (groupCode == TEXTDISP_SecondaryGroupCode)
            entry = TEXTDISP_SecondaryEntryPtrTable[i];
        else
            entry = TEXTDISP_PrimaryEntryPtrTable[i];

        pad = TEXTDISP_MaxEntryTitleLength - (short)strlen((char *)entry + 1);
        if (pad > 0) {
            for (j = 0; j < 10; j++)
                spaces[j] = ' ';
            spaces[pad] = 0;
            STRING_AppendAtNull(spaces, (char *)entry + 1);
            strcpy((char *)entry + 1, spaces);
        }
    }
    return 0;
}
