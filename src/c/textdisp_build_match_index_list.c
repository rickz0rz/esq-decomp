/* RESTORES: TEXTDISP_BuildMatchIndexList
 * MODULE:   modules/groups/b/a/textdisp2.s
 * STATUS:   behavioural
 *
 * 402 bytes in the original, 388 emitted, 15 differing regions. SAS/C is the
 * more compact of the two here: the original spills the entry count and the
 * sports flag to the frame, while SAS/C keeps both in registers.
 *
 * Reproduces: the PPV/SBE tag cascade with its side effect on
 * TEXTDISP_SbeFilterActiveFlag, the SPT filter fallback to "*", the FIND1
 * comparison and its ASTERISK_3 substitution, the primary/secondary group
 * selection done twice (once for the count, again inside the loop), the three
 * entry filters on bit 3 of byte 27, bit 7 of byte 40 under command 'E' and bit
 * 4 of byte 27, and the byte-wide candidate index store.
 *
 * Two original-compiler artifacts that DO reproduce and are worth noting:
 *
 *   - the sports flag is built with the classic booleanize sequence
 *     4A00 57C1 4401 (TST.B / SEQ D1 / NEG.B D1) turning a zero test into 1,
 *     and SAS/C emits the identical three instructions.
 *   - strcmp() is inlined as a compare loop, and the original's version ends
 *     with a DEAD second BNE (66F6 then 6612) that can never be taken because Z
 *     is already set at that point. That is an artifact of the original code
 *     generator, not of the source; we do not reproduce it and should not try.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffec                   LINK.W A5,#-20
 *   got:     514f                       SUBQ.W #4,A7
 *   summary: The A5-frame class. Because the original's only frame slots are two
 *            spilled locals that SAS/C keeps in registers, this restoration comes
 *            out SMALLER rather than larger.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the six cross-unit calls.
 */
#include <string.h>

extern char ESQ_WildcardMatch(char *pat, char *s);
extern long TEXTDISP_ShouldOpenEditorForEntry(unsigned char *entry);
extern short TEXTDISP_ActiveGroupId;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern char *TEXTDISP_PrimaryTitlePtrTable[];
extern char *TEXTDISP_SecondaryTitlePtrTable[];
extern unsigned char *TEXTDISP_PrimaryEntryPtrTable[];
extern unsigned char *TEXTDISP_SecondaryEntryPtrTable[];
extern unsigned char TEXTDISP_CandidateIndexList[];
extern short TEXTDISP_SbeFilterActiveFlag;
extern short TEXTDISP_FindModeActiveFlag;
extern char TEXTDISP_Tag_PPV[];
extern char TEXTDISP_Tag_SBE[];
extern char TEXTDISP_Tag_SPORTS[];
extern char TEXTDISP_Tag_SPT_Filter[];
extern char TEXTDISP_Tag_FIND1[];
extern char Global_STR_ASTERISK_2[];
extern char Global_STR_ASTERISK_3[];

short TEXTDISP_BuildMatchIndexList(char *pattern, short cmd)
{
    register short count = 0;
    register short i;
    register short tagged;
    short isSports;
    long entryCount;
    unsigned char *entry;
    char *title;

    if (pattern == 0)
        return count;

    if (ESQ_WildcardMatch(TEXTDISP_Tag_PPV, pattern) == 0) {
        tagged = 1;
    } else if (ESQ_WildcardMatch(TEXTDISP_Tag_SBE, pattern) == 0) {
        TEXTDISP_SbeFilterActiveFlag = 1;
        tagged = 1;
    } else {
        tagged = 0;
    }

    isSports = (ESQ_WildcardMatch(TEXTDISP_Tag_SPORTS, pattern) == 0);
    if (ESQ_WildcardMatch(TEXTDISP_Tag_SPT_Filter, pattern) == 0)
        pattern = Global_STR_ASTERISK_2;

    if (strcmp(TEXTDISP_Tag_FIND1, pattern) == 0) {
        TEXTDISP_FindModeActiveFlag = 1;
        pattern = Global_STR_ASTERISK_3;
    } else {
        TEXTDISP_FindModeActiveFlag = 0;
    }

    count = 0;
    if (TEXTDISP_ActiveGroupId == 1)
        entryCount = TEXTDISP_PrimaryGroupEntryCount;
    else
        entryCount = TEXTDISP_SecondaryGroupEntryCount;

    for (i = 0; i < entryCount; i++) {
        if (TEXTDISP_ActiveGroupId == 1) {
            title = TEXTDISP_PrimaryTitlePtrTable[i];
            entry = TEXTDISP_PrimaryEntryPtrTable[i];
        } else {
            title = TEXTDISP_SecondaryTitlePtrTable[i];
            entry = TEXTDISP_SecondaryEntryPtrTable[i];
        }
        if (entry[27] & 8)
            continue;
        if (cmd == 'E' && !(entry[40] & 0x80))
            continue;
        if (tagged && (entry[27] & 0x10))
            ;
        else if (isSports && TEXTDISP_ShouldOpenEditorForEntry(entry))
            ;
        else if (ESQ_WildcardMatch(title, pattern))
            continue;
        TEXTDISP_CandidateIndexList[count] = (unsigned char)i;
        count++;
    }
    return count;
}
