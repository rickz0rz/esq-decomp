/* RESTORES: COI_LoadOiDataFile
 * MODULE:   modules/groups/a/e/coi_p2.s
 * STATUS:   behavioural
 *
 * Loads `df0:OI_%02lx.dat` and parses it into the object-info records hanging off
 * the primary or secondary entry tables. 2356 bytes, and the shape is:
 *
 *   header line  -> disk id and a FILE FORMAT number after a tab
 *   record lines -> one OiRec, matched to an entry by wildcard on the entry name
 *   sub lines    -> OiRec.n36 OiSub rows per record
 *
 * Each record is applied TWICE. The first pass finds the first entry whose name
 * matches the record text and fills its OiRec in from the file. The second pass
 * then walks the REMAINING entries, matches each one against the FIRST matched
 * entry's name, and copies the finished record across. That is why the second
 * pass reads its strings from the record rather than from the file: it is a fan
 * out, not a re-parse.
 *
 * `seen[]` is 302 bytes, one per entry, and stops an entry being filled twice
 * when several records match it. Note the first pass calls
 * COI_AllocSubEntryTable and runs the sub-entry loop EVEN WHEN the entry was
 * already seen -- it only skips the field population. That is the original's
 * control flow, and it means the sub-entry loop then reads the record pointer
 * left over from the previous iteration.
 *
 * FILE FORMAT 2 differs from the default only in how many leading tab-separated
 * fields the line has, so both paths call SCRIPT_BuildTokenIndexMap with the
 * same token count and a different starting point in the separator table.
 *
 * THE DEFAULT-FORMAT RECORD CALL OVERRUNS BOTH OF ITS ARRAYS BY TWO, in the
 * original, and this restoration reproduces it. The call passes
 * `&separators[2]` and `&fieldMap[2]` while still asking for 11 tokens, so
 * BuildTokenIndexMap reads separators[11..12] and writes fieldMap[11..12].
 * In the original those four bytes land on the zeroed head of the field map and
 * on the parse-position local, which is reassigned immediately afterwards, so
 * nothing observable changes. The sub-entry path does NOT have this bug -- it
 * reduces its token count from 8 to 6 when it shifts the base. The arrays here
 * are declared two elements long to keep the overrun inside this function's own
 * locals instead of depending on how the compiler orders the frame.
 *
 * SASC-MISMATCH: register-argument-divide
 *   ref:     7202 4eba....                    MOVEQ #2,D1 / JSR MATH_DivS32
 *   got:     the remainder computed inline
 *   summary: the disk-id parity comes from MATH_DivS32's REMAINDER in D1, which
 *            no C return value can carry, so it is written as `%`.
 *   scope:   program-wide wherever MATH_DivS32's remainder is used.
 *   retest:  a compiler whose divide helper IS this routine.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....                        JSR (d16,PC)
 *   got:     61000000                        BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame-and-large-locals
 *   ref:     4e55fd78                        LINK.W A5,#-648
 *   got:     A7-relative locals
 *   summary: 648 bytes of locals, addressed off A5 in the original and off A7
 *            here. Every local access carries the difference.
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: 2424 against 2356, +68 over 63 regions -- 2.9%. NOT itemised. The
 *            frame class touches every one of the ~200 local accesses in this
 *            function, so casm.py cannot keep the streams aligned long enough
 *            for its per-hunk figures to mean anything. Recorded as a
 *            known-unknown per AGENTS.md rule 3.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>

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

extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;

extern char Global_STR_DF0_OI_PERCENT_2_LX_DAT_2[];
extern char Global_STR_PERCENT_S_1[];
extern char COI_STR_LINEFEED_CR_1[];
extern char COI_STR_LINEFEED_CR_2[];
extern char COI_STR_DEFAULT_TOKEN_TEMPLATE_A[];

extern void  WDISP_SPrintf(char *dst, char *fmt, long a);
extern long  DISKIO_LoadFileToWorkBuffer(char *name);
extern char *STR_FindCharPtr(char *s, long c);
extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern void  SCRIPT_BuildTokenIndexMap(char *input, short *out,
                                                       long tokenCount,
                                                       char *tokenTable,
                                                       long maxScan,
                                                       long terminator,
                                                       long fillMissing);
extern char *ESQPARS_ReplaceOwnedString(char *newText,
                                                        char *oldText);
extern void  CLEANUP_FormatEntryStringTokens(char **a, char **b, char *src);
extern char  ESQ_WildcardMatch(char *pattern, char *text);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                     void *p, long size);
extern void  COI_AllocSubEntryTable(struct TextEntry *entry);

long COI_LoadOiDataFile(unsigned char diskId)
{
    char  separators[13];       /* 11 real, plus the two the default path reads */
    short fieldMap[13];         /* 11 real, plus the two it writes */
    char  subSeparators[8];
    short subFieldMap[8];
    char  lineBuf[150];
    char  nameBuf[80];
    char  seen[302];
    struct TextEntry *entry;
    struct TextEntry *entry2;
    struct OiRec *rec;
    struct OiRec *rec2;
    struct OiSub *sub;
    struct OiSub *sub2;
    char *tabPtr;
    char *work;
    long  fileFormat;
    long  fileLen;
    long  recBase;
    long  pos;
    short entryCount;
    short parity;
    short subIndex;
    short i;
    short record;
    long  k;

    separators[0] = 9;
    separators[1] = 9;
    separators[2] = 9;
    separators[3] = 9;
    separators[4] = 9;
    separators[5] = 9;
    separators[6] = 9;
    separators[7] = 9;
    separators[8] = 9;
    separators[9] = 13;
    separators[10] = 10;
    subSeparators[0] = 9;
    subSeparators[1] = 9;
    subSeparators[2] = 9;
    subSeparators[3] = 9;
    subSeparators[4] = 9;
    subSeparators[5] = 9;
    subSeparators[6] = 13;
    subSeparators[7] = 10;
    separators[11] = separators[12] = 0;

    pos = recBase = 0;

    parity = (short)((diskId - (diskId / 2) * 2));
    WDISP_SPrintf(nameBuf, Global_STR_DF0_OI_PERCENT_2_LX_DAT_2,
                                  (long)parity);
    if (DISKIO_LoadFileToWorkBuffer(nameBuf) == -1)
        return -1;

    fileLen = Global_REF_LONG_FILE_SCRATCH;
    work = Global_PTR_WORK_BUFFER;

    if (diskId == TEXTDISP_SecondaryGroupCode &&
        TEXTDISP_SecondaryGroupPresentFlag == 1) {
        entryCount = TEXTDISP_SecondaryGroupEntryCount;
    } else if (diskId == TEXTDISP_PrimaryGroupCode) {
        entryCount = TEXTDISP_PrimaryGroupEntryCount;
    } else {
        MEMORY_DeallocateMemory("COI.c", 1198,
                                                Global_PTR_WORK_BUFFER,
                                                fileLen + 1);
        return -1;
    }

    /* --- header line: copy it out, split off the format number ------------- */
    recBase = pos = 0;
    while (STR_FindCharPtr(
               COI_STR_LINEFEED_CR_1,
               Global_PTR_WORK_BUFFER[recBase + pos]) == 0) {
        lineBuf[pos] = Global_PTR_WORK_BUFFER[recBase + pos];
        pos = pos + 1;
    }
    lineBuf[pos] = 0;

    tabPtr = STR_FindCharPtr(lineBuf, 9);
    if (tabPtr != 0) {
        *tabPtr = 0;
        tabPtr = tabPtr + 1;
        fileFormat = PARSE_ReadSignedLongSkipClass3_Alt(tabPtr);
    } else {
        fileFormat = 0;
    }

    if (PARSE_ReadSignedLongSkipClass3_Alt(lineBuf) !=
        (long)diskId)
        return -1;

    while (STR_FindCharPtr(
               COI_STR_LINEFEED_CR_2,
               Global_PTR_WORK_BUFFER[recBase + pos]) != 0) {
        Global_PTR_WORK_BUFFER[recBase + pos] = 0;
        pos = pos + 1;
    }

    for (k = 0; k < 302; k++)
        seen[k] = 0;

    /* --- one pass per record ----------------------------------------------- */
    for (record = 0; record < entryCount; record++) {
        recBase = recBase + pos;

        if (fileFormat == 2) {
            SCRIPT_BuildTokenIndexMap(
                &Global_PTR_WORK_BUFFER[recBase], &fieldMap[0], 11,
                &separators[0], fileLen, 26, 1);
        } else {
            for (k = 0; k < 11; k++)
                fieldMap[k] = 0;
            /* &fieldMap[2] with 11 tokens: see the overrun note in the header */
            SCRIPT_BuildTokenIndexMap(
                &Global_PTR_WORK_BUFFER[recBase], &fieldMap[2], 11,
                &separators[2], fileLen, 26, 1);
        }

        pos = fieldMap[10];

        for (i = 0; i < entryCount; i++) {
            if (diskId == TEXTDISP_SecondaryGroupCode &&
                TEXTDISP_SecondaryGroupPresentFlag == 1)
                entry = TEXTDISP_SecondaryEntryPtrTable[i];
            else
                entry = TEXTDISP_PrimaryEntryPtrTable[i];

            if (ESQ_WildcardMatch(entry->name,
                                  &Global_PTR_WORK_BUFFER[recBase]) != 0)
                continue;

            if (seen[i] == 0) {
                rec = entry->rec;
                rec->text4 = ESQPARS_ReplaceOwnedString(
                    &Global_PTR_WORK_BUFFER[recBase + fieldMap[0]], rec->text4);
                rec->code[0] = Global_PTR_WORK_BUFFER[recBase + fieldMap[1]];
                rec->code[1] = Global_PTR_WORK_BUFFER[recBase + fieldMap[1] + 1];
                rec->code[2] = Global_PTR_WORK_BUFFER[recBase + fieldMap[1] + 2];
                rec->code[3] = 0;
                rec->text12 = ESQPARS_ReplaceOwnedString(
                    &Global_PTR_WORK_BUFFER[recBase + fieldMap[1] + fieldMap[2]],
                    rec->text12);
                rec->text16 = ESQPARS_ReplaceOwnedString(
                    &Global_PTR_WORK_BUFFER[recBase + fieldMap[3]], rec->text16);
                rec->text20 = ESQPARS_ReplaceOwnedString(
                    &Global_PTR_WORK_BUFFER[recBase + fieldMap[4]], rec->text20);
                rec->text8 = ESQPARS_ReplaceOwnedString(
                    &Global_PTR_WORK_BUFFER[recBase + fieldMap[5]], rec->text8);

                if (fieldMap[0] > 0 &&
                    &Global_PTR_WORK_BUFFER[recBase + fieldMap[0]] != 0) {
                    CLEANUP_FormatEntryStringTokens(
                        &rec->text24, &rec->text28,
                        &Global_PTR_WORK_BUFFER[recBase + fieldMap[0]]);
                } else {
                    rec->text24 = ESQPARS_ReplaceOwnedString(
                        0, rec->text24);
                    rec->text28 = ESQPARS_ReplaceOwnedString(
                        COI_STR_DEFAULT_TOKEN_TEMPLATE_A, rec->text28);
                }

                if (fieldMap[1] != 0 &&
                    &Global_PTR_WORK_BUFFER[recBase + fieldMap[1]] != 0) {
                    rec->value32 =
                        PARSE_ReadSignedLongSkipClass3_Alt(
                            &Global_PTR_WORK_BUFFER[recBase + fieldMap[1]]);
                } else {
                    rec->value32 = -1;
                }

                WDISP_SPrintf(
                    lineBuf, Global_STR_PERCENT_S_1,
                    (long)&Global_PTR_WORK_BUFFER[recBase + fieldMap[8]]);
                rec->subCount = (short)
                    PARSE_ReadSignedLongSkipClass3_Alt(lineBuf);
            }

            COI_AllocSubEntryTable(entry);

            for (subIndex = 0; subIndex < rec->subCount; subIndex++) {
                sub = rec->subs[subIndex];
                recBase = recBase + pos;

                if (fileFormat == 2) {
                    SCRIPT_BuildTokenIndexMap(
                        &Global_PTR_WORK_BUFFER[recBase], &subFieldMap[0], 8,
                        &subSeparators[0], fileLen, 26, 1);
                } else {
                    for (k = 0; k < 8; k++)
                        subFieldMap[k] = 0;
                    SCRIPT_BuildTokenIndexMap(
                        &Global_PTR_WORK_BUFFER[recBase], &subFieldMap[2], 6,
                        &subSeparators[2], fileLen, 26, 1);
                }

                if (seen[i] == 0) {
                    sub->numField = (short)
                        PARSE_ReadSignedLongSkipClass3_Alt(
                            &Global_PTR_WORK_BUFFER[recBase]);
                    sub->text6 = ESQPARS_ReplaceOwnedString(
                        &Global_PTR_WORK_BUFFER[recBase + subFieldMap[2]],
                        sub->text6);
                    sub->text10 = ESQPARS_ReplaceOwnedString(
                        &Global_PTR_WORK_BUFFER[recBase + subFieldMap[3]],
                        sub->text10);
                    sub->text14 = ESQPARS_ReplaceOwnedString(
                        &Global_PTR_WORK_BUFFER[recBase + subFieldMap[4]],
                        sub->text14);
                    sub->text2 = ESQPARS_ReplaceOwnedString(
                        &Global_PTR_WORK_BUFFER[recBase + subFieldMap[5]],
                        sub->text2);

                    if (subFieldMap[0] > 0 &&
                        &Global_PTR_WORK_BUFFER[recBase + subFieldMap[0]] != 0) {
                        CLEANUP_FormatEntryStringTokens(
                            &sub->text18, &sub->text22,
                            &Global_PTR_WORK_BUFFER[recBase + subFieldMap[0]]);
                    } else {
                        sub->text18 = ESQPARS_ReplaceOwnedString(
                            rec->text24, sub->text18);
                        sub->text22 = ESQPARS_ReplaceOwnedString(
                            rec->text28, sub->text22);
                    }

                    if (subFieldMap[1] > 0 &&
                        &Global_PTR_WORK_BUFFER[recBase + subFieldMap[1]] != 0) {
                        sub->value26 =
                            PARSE_ReadSignedLongSkipClass3_Alt(
                                &Global_PTR_WORK_BUFFER[recBase +
                                                        subFieldMap[1]]);
                    } else {
                        sub->value26 = rec->value32;
                    }
                }

                pos = subFieldMap[7];
            }

            if (seen[i] == 0)
                seen[i] = 1;
            break;
        }

        /* --- fan the finished record out to the remaining matches ---------- */
        for (i = i + 1; i < entryCount; i++) {
            if (diskId == TEXTDISP_SecondaryGroupCode &&
                TEXTDISP_SecondaryGroupPresentFlag == 1)
                entry2 = TEXTDISP_SecondaryEntryPtrTable[i];
            else
                entry2 = TEXTDISP_PrimaryEntryPtrTable[i];

            if (ESQ_WildcardMatch(entry->name, entry2->name) != 0)
                continue;
            if (seen[i] != 0)
                continue;

            seen[i] = 1;
            rec2 = entry2->rec;
            rec2->text4 = ESQPARS_ReplaceOwnedString(
                rec->text4, rec2->text4);
            rec2->code[0] = rec->code[0];
            rec2->code[1] = rec->code[1];
            rec2->code[2] = rec->code[2];
            rec2->code[3] = rec->code[3];
            rec2->text12 = ESQPARS_ReplaceOwnedString(
                rec->text12, rec2->text12);
            rec2->text16 = ESQPARS_ReplaceOwnedString(
                rec->text16, rec2->text16);
            rec2->text20 = ESQPARS_ReplaceOwnedString(
                rec->text20, rec2->text20);
            rec2->text8 = ESQPARS_ReplaceOwnedString(
                rec->text8, rec2->text8);
            rec2->text24 = ESQPARS_ReplaceOwnedString(
                rec->text24, rec2->text24);
            rec2->text28 = ESQPARS_ReplaceOwnedString(
                rec->text28, rec2->text28);
            rec2->value32 = rec->value32;
            rec2->subCount = rec->subCount;

            COI_AllocSubEntryTable(entry2);

            for (subIndex = 0; subIndex < rec2->subCount; subIndex++) {
                sub2 = rec2->subs[subIndex];
                sub = rec->subs[subIndex];
                sub2->numField = sub->numField;
                sub2->text6 = ESQPARS_ReplaceOwnedString(
                    sub->text6, sub2->text6);
                sub2->text10 = ESQPARS_ReplaceOwnedString(
                    sub->text10, sub2->text10);
                sub2->text14 = ESQPARS_ReplaceOwnedString(
                    sub->text14, sub2->text14);
                sub2->text2 = ESQPARS_ReplaceOwnedString(
                    sub->text2, sub2->text2);
                sub2->text18 = ESQPARS_ReplaceOwnedString(
                    sub->text18, sub2->text18);
                sub2->text22 = ESQPARS_ReplaceOwnedString(
                    sub->text22, sub2->text22);
                sub2->value26 = sub->value26;
            }
        }
    }

    MEMORY_DeallocateMemory("COI.c", 1443, work,
                                            fileLen + 1);
    return 0;
}
