/* RESTORES: ESQIFF2_ParseGroupRecordAndRefresh
 * MODULE:   modules/groups/a/o/esqiff2_p1.s
 * STATUS:   behavioural
 *
 * Parses one serial group record into channel entries, but only if the record
 * actually CHANGED -- it compares the incoming length and checksum against the
 * ones stored for that group and returns immediately when both agree. That
 * short-circuit is why an idle feed costs nothing.
 *
 * THE PRIMARY-GROUP PATH FALLS THROUGH ON A MATCH. When the group code is the
 * primary one and the record is unchanged, the code does not return -- it drops
 * into the SECONDARY comparison, which then fails the code test and returns 0.
 * The C below preserves that shape. Turning the first block into an early
 * return is behaviourally identical only because the two group codes differ;
 * if a configuration ever set them equal, the fall-through would re-check the
 * record under the secondary state.
 *
 * ONLY THE PRIMARY PATH SETS THE REFRESH FLAG. Both clear their entry list, but
 * NEWGRID_RefreshStateFlag is written on the primary path alone. The secondary
 * group relies on the caller to notice.
 *
 * THE RECORD IS A TOKEN STREAM with four control bytes and everything else
 * literal:
 *
 *   0x01  start the TITLE field (index 3) and set the title flag
 *   0x11  start field 1
 *   0x12  end of entry -- emit the previous one and reset
 *   0x14  read SIX RAW BYTES into field 2, control bytes included
 *   0x00  end of record
 *
 * 0x14 IS THE ONE THAT CAN SWALLOW A TERMINATOR. It copies six bytes
 * unconditionally, so a truncated record loses its NUL and the parse runs into
 * whatever follows. The original has no guard and neither does this.
 *
 * THE FIRST 0x12 EMITS NOTHING. A record begins with a field before any
 * terminator, so the first end-of-entry marker only closes the header; the
 * `first` flag suppresses that emission and is cleared. Every later 0x12 emits.
 *
 * 0x12 ALSO READS THE NEXT BYTE as the new entry flag, so the byte after an
 * end-of-entry marker is consumed by the marker rather than by the loop.
 *
 * THE TITLE IS COPIED FROM FIELD 0 WHEN NO 0x01 WAS SEEN. That is what the
 * title flag records: an entry with an explicit title keeps it, one without
 * gets its field-0 text duplicated into the title buffer before emission.
 *
 * FIELD 0 IS INDEXED BY `fieldIdx * 10`, and the four field buffers are
 * therefore CONTIGUOUS in the data section even though the disassembly names
 * them separately. Field 1 is field 0 plus 10 and the title is plus 30. The C
 * indexes through the field-0 symbol exactly as the original does rather than
 * asserting a layout the linker would have to honour.
 *
 * 0x01 SKIPS THE TERMINATOR WHEN THE FIELD INDEX IS 2, which is the only place
 * that index appears. Nothing in this function sets it to 2, so the test is
 * dead here and must belong to a state some other caller can leave behind.
 *
 * A _Return LABEL MEANS THE REFERENCE STOPS EARLY. The epilogue has its own
 * label and is 10 bytes (MOVEM.L from the frame, UNLK, RTS), so the corrected
 * reference is 930.
 *
 * 920 ref vs 972 got, 26 differing regions -- 42 bytes over the corrected 930.
 * Both group comparisons with their length-and-checksum pairs, the fall-through,
 * the entry-count guards, the 0xff field-2 initialisation at both sites, all
 * five token arms with their distinct validate calls, the six-byte raw read,
 * the first-entry suppression, the conditional title copy, both
 * CreateGroupEntryAndTitle calls with their six arguments and the three closing
 * refresh calls match in kind and size.
 *
 * THE STRIDE-LOCAL TRICK DOES NOT APPLY HERE, and that is worth recording
 * because tliba1_draw_formatted_text_block.c shows the opposite. There, holding
 * the array stride in a local turned twelve shift-and-add sequences into eight
 * MULS and saved 36 bytes. Here the same change produces ZERO MULS either way
 * and costs 12 bytes -- 988 against the literal form's 976. The difference is
 * that this stride multiplies a value 6.51 can see is one of {0, 1, 3}, so it
 * folds each site to a constant regardless of how the 10 is spelled.
 *
 * So the rule from that file needs its bound stated: the trick works when the
 * INDEX is a running variable, not when the compiler can enumerate it. Measure
 * both; do not carry the result across functions.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffec ... 2b40fff4   LINK.W A5,#-20 / MOVE.L D0,-12(A5)
 *   got:     the fail and first flags kept in registers
 *   summary: the frame class. The original spills both loop flags and the
 *            saved byte; 6.51 keeps them in registers and pays at the five
 *            validate call sites, where each has to be reloaded across the
 *            call. Net 42 bytes over.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

extern long ESQIFF2_ValidateFieldIndexAndLength(long fieldIdx, long pos);
extern void ESQPARS_RemoveGroupEntryAndReleaseStrings(long which);
extern void ESQSHARED_CreateGroupEntryAndTitle(long groupCode, long entryFlag,
                                               char *f0, char *f1, char *f2,
                                               char *f3);
extern void ESQIFF2_PadEntriesToMaxTitleWidth(long groupCode);
extern void TEXTDISP_ApplySourceConfigAllEntries(void);
extern long ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache(void);

extern char  ESQIFF_ParseField0Buffer[];
extern char  ESQIFF_ParseField1Buffer[];
extern char  ESQIFF_ParseField2Buffer[];
extern char  ESQIFF_ParseField3Buffer[];
extern char  ESQIFF_ParseField0TailBuffer;
extern char  ESQIFF_ParseField1TailByte;
extern char  ESQIFF_ParseField3TailBuffer;

extern char  TEXTDISP_PrimaryGroupCode;
extern char  TEXTDISP_SecondaryGroupCode;
extern short TEXTDISP_PrimaryGroupRecordLength;
extern short TEXTDISP_SecondaryGroupRecordLength;
extern char  TEXTDISP_PrimaryGroupRecordChecksum;
extern char  TEXTDISP_SecondaryGroupRecordChecksum;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern short TEXTDISP_MaxEntryTitleLength;
extern short ESQIFF_RecordLength;
extern char  ESQIFF_RecordChecksumByte;
extern long  NEWGRID_RefreshStateFlag;

long ESQIFF2_ParseGroupRecordAndRefresh(char *rec)
{
    long  groupCode;
    long  fieldIdx;
    long  first;
    long  fail;
    short pos;
    short titleFlag;
    short i;
    char  entryFlag;
    char  c;

    groupCode = (long)(unsigned char)*rec++;

    if ((char)groupCode == TEXTDISP_PrimaryGroupCode) {

        if (TEXTDISP_PrimaryGroupRecordLength != ESQIFF_RecordLength
            || TEXTDISP_PrimaryGroupRecordChecksum
                   != ESQIFF_RecordChecksumByte) {

            TEXTDISP_PrimaryGroupRecordLength   = ESQIFF_RecordLength;
            TEXTDISP_PrimaryGroupRecordChecksum = ESQIFF_RecordChecksumByte;
            TEXTDISP_MaxEntryTitleLength        = 0;

            if ((unsigned short)TEXTDISP_PrimaryGroupEntryCount > 0) {
                ESQPARS_RemoveGroupEntryAndReleaseStrings(1L);
                NEWGRID_RefreshStateFlag = 1;
            }
            goto initParseState;
        }
    }

    if ((char)groupCode != TEXTDISP_SecondaryGroupCode)
        return 0;

    if (TEXTDISP_SecondaryGroupRecordLength == ESQIFF_RecordLength
        && TEXTDISP_SecondaryGroupRecordChecksum == ESQIFF_RecordChecksumByte)
        return 0;

    TEXTDISP_SecondaryGroupRecordLength   = ESQIFF_RecordLength;
    TEXTDISP_SecondaryGroupRecordChecksum = ESQIFF_RecordChecksumByte;
    TEXTDISP_MaxEntryTitleLength          = 0;

    if ((unsigned short)TEXTDISP_SecondaryGroupEntryCount > 0)
        ESQPARS_RemoveGroupEntryAndReleaseStrings(2L);

initParseState:
    entryFlag = 1;

    ESQIFF_ParseField0Buffer[0] = 0;
    ESQIFF_ParseField1Buffer[0] = 0;

    for (i = 0; i < 6; i++)
        ESQIFF_ParseField2Buffer[i] = 0xff;

    ESQIFF_ParseField3Buffer[0] = 0;

    fieldIdx  = 0;
    pos       = 0;
    first     = 1;
    fail      = 0;
    titleFlag = 0;

    for (;;) {

        c = *rec++;

        if (c == 0)
            break;
        if (fail)
            break;

        switch ((short)(unsigned char)c) {

        case 1:
            if (ESQIFF2_ValidateFieldIndexAndLength(fieldIdx,
                                                    (long)pos) == 0) {
                fail = 1;
                continue;
            }
            if (fieldIdx != 2)
                ESQIFF_ParseField0Buffer[fieldIdx * 10 + pos] = 0;
            fieldIdx  = 3;
            pos       = 0;
            titleFlag = 1;
            continue;

        case 17:
            if (ESQIFF2_ValidateFieldIndexAndLength(fieldIdx,
                                                    (long)pos) == 0) {
                fail = 1;
                continue;
            }
            ESQIFF_ParseField0Buffer[fieldIdx * 10 + pos] = 0;
            fieldIdx = 1;
            pos      = 0;
            continue;

        case 18:
            if (ESQIFF2_ValidateFieldIndexAndLength(fieldIdx,
                                                    (long)pos) == 0) {
                fail = 1;
                continue;
            }
            ESQIFF_ParseField0Buffer[fieldIdx * 10 + pos] = 0;

            if (first) {
                first = 0;
            } else {
                if (titleFlag == 0)
                    strcpy(ESQIFF_ParseField3Buffer, ESQIFF_ParseField0Buffer);

                ESQIFF_ParseField0TailBuffer = 0;
                ESQIFF_ParseField1TailByte   = 0;
                ESQIFF_ParseField3TailBuffer = 0;

                ESQSHARED_CreateGroupEntryAndTitle(
                    groupCode, (long)(unsigned char)entryFlag,
                    ESQIFF_ParseField0Buffer, ESQIFF_ParseField1Buffer,
                    ESQIFF_ParseField2Buffer, ESQIFF_ParseField3Buffer);

                titleFlag = 0;
            }

            ESQIFF_ParseField0Buffer[0] = 0;
            ESQIFF_ParseField1Buffer[0] = 0;

            for (i = 0; i < 6; i++)
                ESQIFF_ParseField2Buffer[i] = 0xff;

            ESQIFF_ParseField3Buffer[0] = 0;

            fieldIdx  = 0;
            pos       = 0;
            entryFlag = *rec++;
            continue;

        case 20:
            if (ESQIFF2_ValidateFieldIndexAndLength(fieldIdx,
                                                    (long)pos) == 0) {
                fail = 1;
                continue;
            }
            ESQIFF_ParseField0Buffer[fieldIdx * 10 + pos] = 0;

            for (pos = 0; pos < 6; pos++)
                ESQIFF_ParseField2Buffer[pos] = *rec++;
            continue;

        default:
            if (ESQIFF2_ValidateFieldIndexAndLength(fieldIdx,
                                                    (long)pos) == 0) {
                fail = 1;
                continue;
            }
            ESQIFF_ParseField0Buffer[fieldIdx * 10 + pos] = c;
            pos++;
            continue;
        }
    }

    if (ESQIFF2_ValidateFieldIndexAndLength(fieldIdx, (long)pos) == 0)
        return 0;

    ESQIFF_ParseField0Buffer[fieldIdx * 10 + pos] = 0;

    ESQIFF_ParseField0TailBuffer = 0;
    ESQIFF_ParseField1TailByte   = 0;
    ESQIFF_ParseField3TailBuffer = 0;

    ESQSHARED_CreateGroupEntryAndTitle(
        groupCode, (long)(unsigned char)entryFlag, ESQIFF_ParseField0Buffer,
        ESQIFF_ParseField1Buffer, ESQIFF_ParseField2Buffer,
        ESQIFF_ParseField3Buffer);

    ESQIFF2_PadEntriesToMaxTitleWidth(groupCode);
    TEXTDISP_ApplySourceConfigAllEntries();

    return ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache();
}
