/* RESTORES: TEXTDISP_BuildChannelLabel
 * MODULE:   modules/groups/b/a/textdisp.s
 * STATUS:   behavioural
 *
 * 210 bytes in the original, 208 emitted, 13 differing regions.
 *
 * Reproduces: the group selection feeding the entry lookup, the entry name copied
 * from entry+1 (skipping a leading length or type byte), the empty-name fallback,
 * the ready flag cleared before the early returns and set only on success, the
 * two rejection tests (name of one character or less, or a space in the
 * second-to-last position), the optional "aligned on" prefix, and the three
 * appends into the shared label buffer.
 *
 * The final truncation is worth spelling out because it looks like an off-by-one
 * until you check the symbols. The original writes a NUL at
 *
 *     TEXTDISP_ChannelLabelBufferTerminatorByte[strlen(TEXTDISP_ChannelLabelBuffer)]
 *
 * and the terminator symbol sits at A089, one byte BELOW the buffer at A08A. So
 * indexing it by the full length lands on buffer[len-1] and drops the last
 * character. Writing buffer[strlen(buffer) - 1] = 0 would be equivalent but would
 * not match, and would hide that the assembly reaches the position through a
 * separate symbol.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffec                   LINK.W A5,#-20
 *   got:     9efc0014                   SUBA.W #20,A7
 *   summary: The A5-frame class; the name scratch moves to A7-relative.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit calls.
 */
#include <string.h>

extern unsigned char *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(long i, long mode);
extern void STRING_AppendAtNull(char *dst, char *src);
extern short TEXTDISP_CurrentMatchIndex;
extern short TEXTDISP_ActiveGroupId;
extern long  TEXTDISP_ChannelLabelReadyFlag;
extern char  TEXTDISP_ChannelLabelBuffer[];
extern char  TEXTDISP_ChannelLabelBufferTerminatorByte[];
extern char  Global_STR_ALIGNED_ON[];
extern char  Global_STR_ALIGNED_CHANNEL_1[];

void TEXTDISP_BuildChannelLabel(short mode)
{
    char name[18];
    unsigned char *entry;
    register long len;

    entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode((long)TEXTDISP_CurrentMatchIndex,
                                                        TEXTDISP_ActiveGroupId ? 1 : 2);
    if (entry)
        strcpy(name, (char *)entry + 1);
    else
        name[0] = 0;

    len = (long)strlen(name);
    TEXTDISP_ChannelLabelReadyFlag = 0;

    if (len <= 1)
        return;
    if (name[len - 2] == ' ')
        return;

    if (mode)
        STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, Global_STR_ALIGNED_ON);

    STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, Global_STR_ALIGNED_CHANNEL_1);
    STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, (char *)entry + 1);

    TEXTDISP_ChannelLabelBufferTerminatorByte[strlen(TEXTDISP_ChannelLabelBuffer)] = 0;
    TEXTDISP_ChannelLabelReadyFlag = 1;
}
