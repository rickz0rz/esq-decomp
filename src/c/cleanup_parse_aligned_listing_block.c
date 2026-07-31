/* RESTORES: CLEANUP_ParseAlignedListingBlock
 * MODULE:   modules/groups/a/e/cleanup4_p1_cleanup_parsealignedlistingblock.s
 * STATUS:   behavioural
 *
 * Parses one aligned listing block out of a serial record into the object-info
 * records. 2036 bytes, three phases:
 *
 *   1. SCAN. Every entry in the primary or secondary table whose name matches the
 *      block text goes into `slots[]`, up to ten of them. No match at all is a
 *      return of 2.
 *   2. POPULATE. The FIRST slot is filled from the block, field by field, using
 *      the offsets SCRIPT_BuildTokenIndexMap found for a nine-separator template.
 *      Its sub-entries follow, each with its own seven-separator template.
 *   3. MERGE. Slots 1..9 get a copy of the finished record, including its
 *      sub-entries. Same fan-out as coi_load_oi_data_file.c.
 *
 * A SUB-ENTRY FIELD THAT THE BLOCK DOES NOT CARRY INHERITS FROM THE RECORD, and
 * which record field it inherits is NOT the matching one. Sub-entry text6 falls
 * back to record text12, text14 to text20, text2 to text8, text10 to text16. That
 * crossing looks like a transcription error and is not -- the offsets are read
 * straight out of the original's `MOVEA.L 12(A1),A0` / `20(A2),A1` / `8(A2),A1` /
 * `16(A2),A1` pattern.
 *
 * The two BuildTokenIndexMap calls differ in their LAST argument: the record
 * template passes fillMissing = 1, the sub-entry template passes 0. That is why
 * the sub-entry code has to test each offset against -1 and the record code does
 * not.
 *
 * The record's own token map is called with the escape-14 count still on the
 * stack, because the original leaves COI_CountEscape14BeforeNull's two arguments
 * there and pushes the next seven on top, popping all nine with one
 * `LEA 36(A7),A7`. That is a stack-management detail with no C expression, so this
 * restoration simply makes both calls and lets 6.51 manage its own stack.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....                JSR (d16,PC)
 *   got:     61000000                BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame-and-large-locals
 *   ref:     4e55ff80                LINK.W A5,#-128
 *   got:     A7-relative locals
 *   summary: 128 bytes of locals off A5 in the original, off A7 here, and the
 *            function makes about 150 local accesses.
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: 2116 against 2036, +80 over 71 regions -- 3.9%. NOT itemised.
 *            Recorded as a known-unknown per AGENTS.md rule 3; the
 *            frame class touches every local access, so casm.py cannot hold the
 *            streams in alignment.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>
#include <string.h>

struct OiSub {
    short numField;             /*  0 */
    char *text2;                /*  2 */
    char *text6;                /*  6 */
    char *text10;               /* 10 */
    char *text14;               /* 14 */
    char *text18;               /* 18 */
    char *text22;               /* 22 */
    long  value26;              /* 26 */
};

struct OiRec {
    char  code[4];              /*  0 */
    char *text4;                /*  4 */
    char *text8;                /*  8 */
    char *text12;               /* 12 */
    char *text16;               /* 16 */
    char *text20;               /* 20 */
    char *text24;               /* 24 */
    char *text28;               /* 28 */
    long  value32;              /* 32 */
    short subCount;             /* 36 */
    struct OiSub **subs;        /* 38 */
};

struct TextEntry {
    char  pad0[12];
    char  name[36];             /* 12 */
    struct OiRec *rec;          /* 48 */
};

extern unsigned char TEXTDISP_SecondaryGroupCode;
extern unsigned char TEXTDISP_SecondaryGroupPresentFlag;
extern short         TEXTDISP_SecondaryGroupEntryCount;
extern unsigned char TEXTDISP_PrimaryGroupCode;
extern short         TEXTDISP_PrimaryGroupEntryCount;
extern struct TextEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern struct TextEntry *TEXTDISP_SecondaryEntryPtrTable[];

extern unsigned char CTASKS_PendingSecondaryOiDiskId;
extern unsigned char CTASKS_SecondaryOiWritePendingFlag;
extern unsigned char CTASKS_PendingPrimaryOiDiskId;
extern unsigned char CTASKS_PrimaryOiWritePendingFlag;
extern short ESQIFF_RecordLength;
extern char  CLOCK_STR_MISSING_TITLE_TEMPLATE[];

extern short COI_CountEscape14BeforeNull(char *p, long len);
extern short GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(char *input, short *out,
                                                       long tokenCount,
                                                       char *tokenTable,
                                                       long maxScan,
                                                       long terminator,
                                                       long fillMissing);
extern char  ESQ_WildcardMatch(char *pattern, char *text);
extern void  COI_ClearAnimObjectStrings(struct TextEntry *e);
extern void  COI_FreeSubEntryTableEntries(struct TextEntry *e);
extern void  COI_AllocSubEntryTable(struct TextEntry *e);
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(char *newText,
                                                        char *oldText);
extern void  CLEANUP_FormatEntryStringTokens(char **a, char **b, char *src);
extern long  GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);

long CLEANUP_ParseAlignedListingBlock(char *block)
{
    char  separators[9];
    char  subSeparators[7];
    short fieldMap[9];
    short subFieldMap[7];
    short slots[10];
    struct TextEntry *entry;
    struct TextEntry *entry2;
    struct OiRec *rec;
    struct OiRec *rec2;
    struct OiSub *sub;
    struct OiSub *sub2;
    char *src;
    long  pos;
    long  fieldCount;
    long  tokenResult;
    unsigned char diskId;
    short entryCount;
    short found;
    short idx;
    short i;
    short j;

    diskId = 0;
    separators[0] = 22;
    separators[1] = 23;
    separators[2] = 3;
    separators[3] = 4;
    separators[4] = 16;
    separators[5] = 5;
    separators[6] = 15;
    separators[7] = 6;
    separators[8] = 20;
    subSeparators[0] = 22;
    subSeparators[1] = 23;
    subSeparators[2] = 16;
    subSeparators[3] = 5;
    subSeparators[4] = 15;
    subSeparators[5] = 6;
    subSeparators[6] = 20;
    tokenResult = pos = fieldCount = 0;

    for (i = 0; i < 10; i++)
        slots[i] = -1;

    diskId = (unsigned char)(block[0] & 0xFF);
    pos = pos + 1;

    if (diskId == TEXTDISP_SecondaryGroupCode &&
        TEXTDISP_SecondaryGroupPresentFlag == 1) {
        entryCount = TEXTDISP_SecondaryGroupEntryCount;
        CTASKS_PendingSecondaryOiDiskId = diskId;
        CTASKS_SecondaryOiWritePendingFlag = 1;
    } else if (diskId == TEXTDISP_PrimaryGroupCode) {
        entryCount = TEXTDISP_PrimaryGroupEntryCount;
        CTASKS_PendingPrimaryOiDiskId = diskId;
        CTASKS_PrimaryOiWritePendingFlag = 1;
    } else {
        return 1;
    }

    if (block[pos] == 49)
        pos = pos + 1;

    fieldCount = COI_CountEscape14BeforeNull(&block[pos],
                                            (long)ESQIFF_RecordLength - pos);
    tokenResult = GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(
        &block[pos], fieldMap, 9L, separators,
        (long)ESQIFF_RecordLength - pos, 0L, 1L);

    /* --- 1. scan for every entry the block text matches -------------------- */
    found = 0;
    for (i = 0; i < entryCount; i++) {
        if (found >= 10)
            break;
        if (diskId == TEXTDISP_SecondaryGroupCode &&
            TEXTDISP_SecondaryGroupPresentFlag == 1)
            entry = TEXTDISP_SecondaryEntryPtrTable[i];
        else
            entry = TEXTDISP_PrimaryEntryPtrTable[i];

        if (ESQ_WildcardMatch(entry->name, &block[pos]) == 0) {
            slots[found] = i;
            found = found + 1;
        }
    }

    if (slots[0] == -1)
        return 2;

    /* --- 2. populate the first match from the block ------------------------ */
    if (diskId == TEXTDISP_SecondaryGroupCode &&
        TEXTDISP_SecondaryGroupPresentFlag == 1)
        entry = TEXTDISP_SecondaryEntryPtrTable[slots[0]];
    else
        entry = TEXTDISP_PrimaryEntryPtrTable[slots[0]];

    COI_ClearAnimObjectStrings(entry);
    COI_FreeSubEntryTableEntries(entry);

    rec = entry->rec;
    rec->text4 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
        &block[pos + fieldMap[2]], rec->text4);
    rec->code[0] = block[pos + fieldMap[3]];
    rec->code[1] = block[pos + fieldMap[3] + 1];
    rec->code[2] = block[pos + fieldMap[3] + 2];
    rec->code[3] = 0;
    rec->text12 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
        &block[pos + fieldMap[3] + fieldMap[4]], rec->text12);
    rec->text20 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
        &block[pos + fieldMap[5]], rec->text20);
    rec->text8 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
        &block[pos + fieldMap[6]], rec->text8);
    rec->text16 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
        &block[pos + fieldMap[7]], rec->text16);
    rec->subCount = (short)fieldCount;

    if (block[pos + fieldMap[0]] != 0) {
        CLEANUP_FormatEntryStringTokens(&rec->text24, &rec->text28,
                                        &block[pos + fieldMap[0]]);
    } else {
        rec->text24 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0,
                                                                 rec->text24);
        rec->text28 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
            CLOCK_STR_MISSING_TITLE_TEMPLATE, rec->text28);
    }

    if (block[pos + fieldMap[1]] != 0)
        rec->value32 = GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(
            &block[pos + fieldMap[1]]);
    else
        rec->value32 = -1;

    pos = pos + fieldMap[7];
    if (rec->text16 != 0)
        pos = pos + strlen(rec->text16);
    pos = pos + 1;

    COI_AllocSubEntryTable(entry);

    for (j = 0; j < rec->subCount; j++) {
        sub = rec->subs[j];
        sub->numField = (short)(unsigned char)block[pos];
        pos = pos + 1;
        GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(
            &block[pos], subFieldMap, 7L, subSeparators,
            (long)ESQIFF_RecordLength - pos, 0L, 0L);

        if (subFieldMap[2] == -1)
            src = rec->text12;
        else
            src = &block[pos + subFieldMap[2]];
        sub->text6 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(src, sub->text6);

        if (subFieldMap[3] == -1)
            src = rec->text20;
        else
            src = &block[pos + subFieldMap[3]];
        sub->text14 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(src,
                                                                 sub->text14);

        if (subFieldMap[4] == -1)
            src = rec->text8;
        else
            src = &block[pos + subFieldMap[4]];
        sub->text2 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(src, sub->text2);

        if (subFieldMap[5] == -1)
            src = rec->text16;
        else
            src = &block[pos + subFieldMap[5]];
        sub->text10 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(src,
                                                                 sub->text10);

        if (subFieldMap[0] == -1) {
            sub->text18 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                rec->text24, sub->text18);
            sub->text22 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                rec->text28, sub->text22);
        } else {
            CLEANUP_FormatEntryStringTokens(&sub->text18, &sub->text22,
                                            &block[pos + subFieldMap[0]]);
        }

        if (subFieldMap[1] == -1)
            sub->value26 = rec->value32;
        else
            sub->value26 = GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(
                &block[pos + subFieldMap[1]]);

        pos = pos + subFieldMap[6];
    }

    /* --- 3. fan the finished record out to the other matches --------------- */
    idx = 1;
    for (;;) {
        if (slots[idx] == -1)
            return 0;
        if (idx >= 10)
            return 0;

        if (diskId == TEXTDISP_SecondaryGroupCode &&
            TEXTDISP_SecondaryGroupPresentFlag == 1)
            entry2 = TEXTDISP_SecondaryEntryPtrTable[slots[idx]];
        else
            entry2 = TEXTDISP_PrimaryEntryPtrTable[slots[idx]];

        rec = entry->rec;
        rec2 = entry2->rec;
        idx = idx + 1;

        COI_ClearAnimObjectStrings(entry2);
        COI_FreeSubEntryTableEntries(entry2);

        rec2->text4 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(rec->text4,
                                                                 rec2->text4);
        rec2->code[0] = rec->code[0];
        rec2->code[1] = rec->code[1];
        rec2->code[2] = rec->code[2];
        rec2->code[3] = rec->code[3];
        rec2->text12 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(rec->text12,
                                                                  rec2->text12);
        rec2->text20 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(rec->text20,
                                                                  rec2->text20);
        rec2->text8 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(rec->text8,
                                                                 rec2->text8);
        rec2->text16 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(rec->text16,
                                                                  rec2->text16);
        rec2->subCount = rec->subCount;
        rec2->text24 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(rec->text24,
                                                                  rec2->text24);
        rec2->text28 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(rec->text28,
                                                                  rec2->text28);
        rec2->value32 = rec->value32;

        COI_AllocSubEntryTable(entry2);

        for (j = 0; j < rec->subCount; j++) {
            sub = rec->subs[j];
            sub2 = rec2->subs[j];
            sub2->numField = sub->numField;
            sub2->text6 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                sub->text6, sub2->text6);
            sub2->text14 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                sub->text14, sub2->text14);
            sub2->text2 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                sub->text2, sub2->text2);
            sub2->text10 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                sub->text10, sub2->text10);
            sub2->text18 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                sub->text18, sub2->text18);
            sub2->text22 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                sub->text22, sub2->text22);
            sub2->value26 = sub->value26;
        }
    }
}
