/* RESTORES: COI_WriteOiDataFile
 * MODULE:   modules/groups/a/e/coi_p1.s
 * STATUS:   behavioural
 *
 * The writer half of `df0:OI_%02lx.dat`, 1698 bytes, and the mirror image of
 * coi_load_oi_data_file.c. Header line, then one record line per entry, then one
 * line per sub-entry, then a Ctrl-Z end marker.
 *
 * Every field goes out as "if the pointer is non-null, write strlen of it", with
 * an unconditional delimiter between fields. That is why the body is long and
 * shallow: twenty-two write calls for the record line and sixteen for each
 * sub-entry, all the same shape.
 *
 * THE ENTRY NAME'S NULL TEST IS PROVABLY DEAD. The original tests the ADDRESS of
 * `entry->name`, which is an array member and can never be zero, and branches
 * past the write. Per AGENTS.md that means the source held the address in a
 * pointer local first, so this restoration does the same (`namePtr`) rather than
 * testing the array -- testing it directly lets the compiler drop the branch and
 * costs the match.
 *
 * DUPLICATE ENTRIES ARE SKIPPED, and the test is a wildcard match against every
 * EARLIER entry's name, not an equality check. The loop keeps running after it
 * finds a match instead of breaking -- it re-tests `dup` at the top of each
 * pass -- so the shape is a `for` with the guard inside, which is what the
 * original's two branches at `.find_duplicate_entry` do.
 *
 * The header's second field is the literal 2, not a variable: the original pushes
 * `PEA 2.W` as the format argument.
 *
 * MEASURED: 1612 emitted against 1698 in the original, -86 over 49 regions.
 *
 * SASC-MISMATCH: register-argument-divide
 *   ref:     7202 4eba....         MOVEQ #2,D1 / JSR MATH_DivS32
 *   got:     the remainder computed inline
 *   summary: the filename's parity digit is MATH_DivS32's REMAINDER, which no C
 *            return value can carry, so it is written as `%`.
 *   scope:   program-wide wherever MATH_DivS32's remainder is used.
 *   retest:  a compiler whose divide helper IS this routine.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....              JSR (d16,PC)
 *   got:     61000000              BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ff68 ... 4e5d     LINK.W A5,#-152 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: NOT itemised. Thirty-eight near-identical write blocks make a
 *            per-hunk listing thirty-eight copies of one register-allocation
 *            difference. Recorded as a known-unknown per AGENTS.md rule 3.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>
#include <dos/dos.h>
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

extern unsigned char CTASKS_SecondaryOiWritePendingFlag;
extern unsigned char CTASKS_PendingSecondaryOiDiskId;
extern unsigned char CTASKS_PrimaryOiWritePendingFlag;
extern unsigned char CTASKS_PendingPrimaryOiDiskId;

extern char Global_STR_DF0_OI_PERCENT_2_LX_DAT_1[];
extern char COI_FMT_LONG_DEC_A[];
extern char COI_FMT_LONG_DEC_B[];
extern char COI_FMT_LONG_DEC_C[];
extern char COI_FMT_LONG_DEC_PAD2[];
extern char COI_FMT_DEC_A[];
extern char COI_FMT_DEC_B[];
extern char COI_FieldDelimiterTab[];
extern char COI_RecordTerminatorCrLf[];
extern char COI_STR_COLON_A[];
extern char COI_STR_COLON_B[];
extern char CLOCK_FileEofMarkerCtrlZ[];

extern void  GROUP_AE_JMPTBL_WDISP_SPrintf(char *dst, char *fmt, long a);
extern long  DISKIO_OpenFileWithBuffer(char *name, long mode);
extern void  DISKIO_WriteBufferedBytes(long fh, char *p, long n);
extern void  DISKIO_CloseBufferedFileAndFlush(long fh);
extern char  ESQ_WildcardMatch(char *pattern, char *text);

long COI_WriteOiDataFile(unsigned char diskId)
{
    char  nameBuf[40];
    char  scratch[40];
    struct TextEntry *entry;
    struct TextEntry *other;
    struct OiRec *rec;
    struct OiSub *sub;
    char *namePtr;
    long  fh;
    long  dup;
    short entryCount;
    short parity;
    short i;
    short j;

    if (TEXTDISP_PrimaryGroupEntryCount > 200)
        return 1;

    if (diskId == TEXTDISP_SecondaryGroupCode &&
        TEXTDISP_SecondaryGroupPresentFlag == 1) {
        CTASKS_SecondaryOiWritePendingFlag = 1;
        CTASKS_PendingSecondaryOiDiskId = diskId;
        entryCount = TEXTDISP_SecondaryGroupEntryCount;
    } else if (diskId == TEXTDISP_PrimaryGroupCode) {
        CTASKS_PrimaryOiWritePendingFlag = 1;
        CTASKS_PendingPrimaryOiDiskId = diskId;
        entryCount = TEXTDISP_PrimaryGroupEntryCount;
    } else {
        return 1;
    }

    parity = (short)(diskId % 2);
    GROUP_AE_JMPTBL_WDISP_SPrintf(nameBuf, Global_STR_DF0_OI_PERCENT_2_LX_DAT_1,
                                  (long)parity);
    fh = DISKIO_OpenFileWithBuffer(nameBuf, MODE_NEWFILE);
    if (fh == 0)
        return -3;

    GROUP_AE_JMPTBL_WDISP_SPrintf(scratch, COI_FMT_LONG_DEC_A, (long)diskId);
    DISKIO_WriteBufferedBytes(fh, scratch, strlen(scratch));
    DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
    GROUP_AE_JMPTBL_WDISP_SPrintf(scratch, COI_FMT_DEC_A, 2L);
    DISKIO_WriteBufferedBytes(fh, scratch, strlen(scratch));
    DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, 2L);

    for (i = 0; i < entryCount; i++) {
        if (diskId == TEXTDISP_SecondaryGroupCode &&
            TEXTDISP_SecondaryGroupPresentFlag == 1)
            entry = TEXTDISP_SecondaryEntryPtrTable[i];
        else
            entry = TEXTDISP_PrimaryEntryPtrTable[i];

        /* Skip an entry an EARLIER one already covers by wildcard. */
        dup = 0;
        for (j = 0; j < i; j++) {
            if (dup != 0)
                break;
            if (diskId == TEXTDISP_SecondaryGroupCode &&
                TEXTDISP_SecondaryGroupPresentFlag == 1)
                other = TEXTDISP_SecondaryEntryPtrTable[j];
            else
                other = TEXTDISP_PrimaryEntryPtrTable[j];
            dup = (ESQ_WildcardMatch(entry->name, other->name) == 0);
        }
        if (dup != 0)
            continue;

        rec = entry->rec;

        namePtr = entry->name;
        if (namePtr != 0)
            DISKIO_WriteBufferedBytes(fh, namePtr, strlen(namePtr));

        DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
        if (rec->text24 != 0)
            DISKIO_WriteBufferedBytes(fh, rec->text24, strlen(rec->text24));
        DISKIO_WriteBufferedBytes(fh, COI_STR_COLON_A, 1L);
        if (rec->text28 != 0)
            DISKIO_WriteBufferedBytes(fh, rec->text28, strlen(rec->text28));

        DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
        GROUP_AE_JMPTBL_WDISP_SPrintf(scratch, COI_FMT_LONG_DEC_B, rec->value32);
        DISKIO_WriteBufferedBytes(fh, scratch, strlen(scratch));
        DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);

        if (rec->text4 != 0)
            DISKIO_WriteBufferedBytes(fh, rec->text4, strlen(rec->text4));
        DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
        DISKIO_WriteBufferedBytes(fh, rec->code, strlen(rec->code));
        DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);

        if (rec->text12 != 0)
            DISKIO_WriteBufferedBytes(fh, rec->text12, strlen(rec->text12));
        DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
        if (rec->text16 != 0)
            DISKIO_WriteBufferedBytes(fh, rec->text16, strlen(rec->text16));
        DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
        if (rec->text20 != 0)
            DISKIO_WriteBufferedBytes(fh, rec->text20, strlen(rec->text20));
        DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
        if (rec->text8 != 0)
            DISKIO_WriteBufferedBytes(fh, rec->text8, strlen(rec->text8));

        DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
        GROUP_AE_JMPTBL_WDISP_SPrintf(scratch, COI_FMT_LONG_DEC_C,
                                      (long)rec->subCount);
        DISKIO_WriteBufferedBytes(fh, scratch, strlen(scratch));
        DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, 2L);

        for (j = 0; j < rec->subCount; j++) {
            sub = rec->subs[j];

            GROUP_AE_JMPTBL_WDISP_SPrintf(scratch, COI_FMT_LONG_DEC_PAD2,
                                          (long)sub->numField);
            DISKIO_WriteBufferedBytes(fh, scratch, strlen(scratch));
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);

            if (sub->text18 != 0)
                DISKIO_WriteBufferedBytes(fh, sub->text18, strlen(sub->text18));
            DISKIO_WriteBufferedBytes(fh, COI_STR_COLON_B, 1L);
            if (sub->text22 != 0)
                DISKIO_WriteBufferedBytes(fh, sub->text22, strlen(sub->text22));

            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
            GROUP_AE_JMPTBL_WDISP_SPrintf(scratch, COI_FMT_DEC_B, sub->value26);
            DISKIO_WriteBufferedBytes(fh, scratch, strlen(scratch));
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);

            if (sub->text6 != 0)
                DISKIO_WriteBufferedBytes(fh, sub->text6, strlen(sub->text6));
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
            if (sub->text10 != 0)
                DISKIO_WriteBufferedBytes(fh, sub->text10, strlen(sub->text10));
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
            if (sub->text14 != 0)
                DISKIO_WriteBufferedBytes(fh, sub->text14, strlen(sub->text14));
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1L);
            if (sub->text2 != 0)
                DISKIO_WriteBufferedBytes(fh, sub->text2, strlen(sub->text2));

            DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, 2L);
        }
    }

    DISKIO_WriteBufferedBytes(fh, CLOCK_FileEofMarkerCtrlZ, 1L);
    DISKIO_CloseBufferedFileAndFlush(fh);
    return 0;
}
