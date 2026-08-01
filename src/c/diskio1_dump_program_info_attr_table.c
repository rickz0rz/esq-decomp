/* RESTORES: _DISKIO1_DumpProgramInfoAttrTable
 * MODULE:   modules/groups/a/g/diskio1_p1.s  (with _DISKIO1_DumpProgramInfoRecordVerbose)
 * STATUS:   behavioural
 *
 * Writes the attribute table of one program-info record. It is the shorter
 * sibling of _DISKIO1_DumpProgramInfoRecordVerbose above it: same 48 slots, same
 * attribute flags, but it SKIPS an empty slot and it prints three extra type
 * fields per slot through an escaped-string helper.
 *
 * NO CALLER, and the entry point had NO LABEL. Adding one is byte-neutral. It
 * stops the routine above absorbing this body, which is why the worklist read
 * modules/groups/a/g/diskio1_p1.s as one 338-byte function rather than two.
 *
 * THE SKIP TEST IS AN AND, AND IT IS EASY TO GET WRONG. The original reads
 * `CMPI #1,attr / BNE print / TST.L str / BEQ next`, so a slot is skipped only
 * when the attribute byte is exactly 1 AND the string pointer is null. Either
 * one alone still prints.
 *
 * THE NULL-RECORD TEST COMES BEFORE THE SECOND HEADER LINE HERE, which is the
 * opposite of the sibling. The sibling prints both header lines and then tests;
 * this one prints the number, tests, and only then prints the record string. The
 * two routines are otherwise parallel, so the difference looks like a typo and
 * is not -- it is what the branch targets say.
 *
 * THE FLAG STRINGS ARE A DIFFERENT SET. Bits 4, 6 and 7 name SPORTSPROG,
 * REPEATPROG and a ProgramInfoAttrTable-suffixed string where the sibling names
 * DISKIO_STR_0X10, DISKIO_STR_0X40 and a VerboseProgramAttrFlags-suffixed one.
 * One name for one thing does not hold across these two tables.
 *
 * THE BUFFER IS 41 BYTES AND ONLY THE LAST IS EVER CLEARED. `CLR.B -5(A5)` runs
 * ONCE before the loop, and the buffer starts at -45(A5), so it is `buf[40] = 0`
 * -- a terminator for the 40-byte pad the copy helper fills. The helper is asked
 * for exactly 40 bytes and does not terminate, so this one store is what keeps
 * the buffer a string for all 48 iterations.
 *
 * THE TAG-NONE PATH IS AN INLINE STRCPY. The original is
 * `MOVE.B (A0)+,(A1)+ / BNE`, which is what SAS/C emits for strcpy, so strcpy is
 * written rather than a hand loop -- see AGENTS.md on strlen/strcmp/strcpy.
 *
 * SASC-MISMATCH: stack-argument-reuse
 *   ref:     LEA 12(A7),A7 / LEA 16(A7),A7   one pop per argument group
 *   got:     a push and a matching pop per call
 *   summary: the original overwrites outgoing-argument slots in place and pops
 *            once per group. 6.51 balances after every call. Same arguments.
 *   scope:   every multi-call diagnostic dumper in DISKIO1.
 *   retest:  a compiler that keeps an outgoing-argument area alive across calls.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba  JSR (d16,PC)
 *   got:     6100  BSR.W
 *   summary: 6.51 emits BSR.W for every call whoever the callee is.
 *   scope:   program-wide.
 *   retest:  a compiler that picks the encoding per callee.
 */
#include <string.h>

#ifndef DISKIOPROGINFOREC_DEFINED
#define DISKIOPROGINFOREC_DEFINED
struct DiskioProgInfoRec {
    char           pad0[7];         /* +0                 */
    unsigned char  attr[49];        /* +7    indexed 1..48 */
    char          *str[49];         /* +56   indexed 1..48 */
    unsigned char  typeA[49];       /* +252  indexed 1..48 */
    unsigned char  typeB[49];       /* +301  indexed 1..48 */
    unsigned char  typeC[49];       /* +350  indexed 1..48 */
};
#endif

extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...);
extern void GROUP_AG_JMPTBL_STRING_CopyPadNul(char *dst, char *src, long len);
extern void GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch(char *s);

extern char **Global_REF_STR_CLOCK_FORMAT;

extern char DISKIO_FMT_PROGRAM_INFO_PCT_D[];
extern char DISKIO_STR_NewlineOnly_C[];
extern char DISKIO_FMT_PROG_SRCE_PCT_S_ProgramInfoAttrTable[];
extern char DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR[];
extern char DISKIO_STR_NONE_ProgramInfoAttrTable[];
extern char DISKIO_STR_MOVIE_ProgramInfoAttrTable[];
extern char DISKIO_STR_ALTHILITE_PROG_ProgramInfoAttrTable[];
extern char DISKIO_STR_TAG_PROG_ProgramInfoAttrTable[];
extern char DISKIO_STR_SPORTSPROG[];
extern char DISKIO_STR_0X20_ProgramInfoAttrTable[];
extern char DISKIO_STR_REPEATPROG[];
extern char DISKIO_STR_PREV_DAYS_DATA_ProgramInfoAttrTable[];
extern char DISKIO_STR_ProgramAttrCloseAndProgQuotedPrefix[];
extern char DISKIO_TAG_NONE[];
extern char DISKIO_FMT_ProgramStringSuffixWithTypeFields[];

void DISKIO1_DumpProgramInfoAttrTable(struct DiskioProgInfoRec *rec, long num)
{
    char buf[41];
    register long i;

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROGRAM_INFO_PCT_D, num);

    if (rec == 0) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NewlineOnly_C);
        return;
    }

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROG_SRCE_PCT_S_ProgramInfoAttrTable, rec);

    /* Cleared once, not per slot. The copy helper pads 40 bytes and does not
     * terminate, so this is the terminator for every iteration below. */
    buf[40] = 0;

    for (i = 1; i < 49; i++) {
        /* Skipped only when BOTH hold. */
        if (rec->attr[i] == 1 && rec->str[i] == 0)
            continue;

        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR, i,
            Global_REF_STR_CLOCK_FORMAT[i]);

        /* A whole-byte comparison, not a bit test. */
        if (rec->attr[i] == 1)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_NONE_ProgramInfoAttrTable);

        if (rec->attr[i] & 2)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_MOVIE_ProgramInfoAttrTable);

        if (rec->attr[i] & 4)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_ALTHILITE_PROG_ProgramInfoAttrTable);

        if (rec->attr[i] & 8)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_TAG_PROG_ProgramInfoAttrTable);

        if (rec->attr[i] & 0x10)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_SPORTSPROG);

        if (rec->attr[i] & 0x20)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_0X20_ProgramInfoAttrTable);

        if (rec->attr[i] & 0x40)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_REPEATPROG);

        if (rec->attr[i] & 0x80)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_PREV_DAYS_DATA_ProgramInfoAttrTable);

        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_ProgramAttrCloseAndProgQuotedPrefix);

        if (rec->str[i] != 0)
            GROUP_AG_JMPTBL_STRING_CopyPadNul(buf, rec->str[i], 40);
        else
            strcpy(buf, DISKIO_TAG_NONE);

        GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch(buf);

        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_FMT_ProgramStringSuffixWithTypeFields, (long)rec->typeA[i],
            (long)rec->typeB[i], (long)rec->typeC[i]);
    }
}
