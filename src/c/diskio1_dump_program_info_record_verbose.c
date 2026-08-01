/* RESTORES: _DISKIO1_DumpProgramInfoRecordVerbose
 * MODULE:   modules/groups/a/g/diskio1_p1.s  (with _DISKIO1_DumpProgramInfoAttrTable)
 * STATUS:   behavioural
 *
 * Writes every one of the 48 program slots of one program-info record: the slot
 * number, its clock label, its attribute byte, the attribute flags spelled out,
 * and the slot's string. It is a diagnostic and returns nothing.
 *
 * NO CALLER. Nothing outside modules/groups/a/g/diskio1_p1.s names either
 * routine in it. The module sits between two live dumpers and is dead.
 *
 * IT PRINTS BOTH HEADER LINES BEFORE IT TESTS THE RECORD FOR NULL. The original
 * passes the pointer to two formatter calls and only then does `MOVE.L A3,D0 /
 * BNE`, so a null record still prints its number and an empty `%s`. Moving the
 * test up would read as an improvement and would change the output.
 *
 * SLOT 0 IS NEVER TOUCHED. Every loop runs 1..48, so `attr[0]` and `str[0]`
 * exist only to make the indices line up with the clock table, which is indexed
 * the same way.
 *
 * BIT 0 OF THE ATTRIBUTE BYTE IS A WHOLE-BYTE COMPARISON, not a bit test -- the
 * same shape the two source-record dumpers use, and the same trap. "NONE" prints
 * only when the byte is exactly 1.
 *
 * THE CLOCK LABEL IS READ THROUGH TWO INDIRECTIONS.
 * `_Global_REF_STR_CLOCK_FORMAT` is a single DC.L that HOLDS the table base, so
 * the original does `MOVEA.L sym,A0 / ADDA.L D0,A0 / MOVE.L (A0)`. Declaring it
 * `char *X[]` would make the symbol BE the table and lose a load, which is the
 * defect written up in AGENTS.md that emptied every time-slot label on screen.
 * `char **` is the correct declaration and is what the other readers use.
 *
 * SASC-MISMATCH: stack-argument-reuse
 *   ref:     LEA 12(A7),A7 after two calls   one pop for two argument lists
 *   got:     ADDQ.W #8,A7 / ADDQ.W #4,A7     6.51 balances after every call
 *   summary: the original overwrites the outgoing-argument slots in place with
 *            MOVE.L A3,(A7) and pops once. 6.51 pushes and pops per call. Same
 *            arguments, same order.
 *   scope:   every multi-call diagnostic dumper in DISKIO1.
 *   retest:  a compiler that keeps an outgoing-argument area alive across calls.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba  JSR (d16,PC)
 *   got:     6100  BSR.W
 *   summary: 6.51 emits BSR.W for every call whoever the callee is. Same size,
 *            same displacement, same effect.
 *   scope:   program-wide.
 *   retest:  a compiler that picks the encoding per callee.
 */

#ifndef DISKIOPROGINFOREC_DEFINED
#define DISKIOPROGINFOREC_DEFINED
struct DiskioProgInfoRec {
    char           pad0[7];         /* +0                        */
    unsigned char  attr[49];        /* +7    indexed 1..48        */
    char          *str[49];         /* +56   indexed 1..48        */
    unsigned char  typeA[49];       /* +252  read by the sibling  */
    unsigned char  typeB[49];       /* +301  read by the sibling  */
    unsigned char  typeC[49];       /* +350  read by the sibling  */
};
#endif

extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...);

extern char **Global_REF_STR_CLOCK_FORMAT;

extern char DISKIO_FMT_PROGRAM_INFO_PCT_LD[];
extern char DISKIO_FMT_PROG_SRCE_PCT_S_VerboseProgramInfo[];
extern char DISKIO_STR_NewlineOnly_A[];
extern char DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX[];
extern char DISKIO_STR_NONE_VerboseProgramAttrFlags[];
extern char DISKIO_STR_MOVIE_VerboseProgramAttrFlags[];
extern char DISKIO_STR_ALTHILITE_PROG_VerboseProgramAttrFlags[];
extern char DISKIO_STR_TAG_PROG_VerboseProgramAttrFlags[];
extern char DISKIO_STR_0X10[];
extern char DISKIO_STR_0X20_VerboseProgramAttrFlags[];
extern char DISKIO_STR_0X40[];
extern char DISKIO_STR_PREV_DAYS_DATA_VerboseProgramAttrFlags[];
extern char DISKIO_STR_ProgramAttrCloseAndProgPrefix[];
extern char DISKIO_FMT_PCT_S_VerboseProgramStringLine[];
extern char DISKIO_STR_NullLine[];
extern char DISKIO_STR_NewlineOnly_B[];

void DISKIO1_DumpProgramInfoRecordVerbose(struct DiskioProgInfoRec *rec,
                                          long num)
{
    register long i;

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROGRAM_INFO_PCT_LD, num);

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROG_SRCE_PCT_S_VerboseProgramInfo, rec);

    /* The null test comes AFTER both calls above. That is the original's order. */
    if (rec == 0) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NewlineOnly_A);
        return;
    }

    for (i = 1; i < 49; i++) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX, i,
            Global_REF_STR_CLOCK_FORMAT[i], (long)rec->attr[i]);

        /* A whole-byte comparison, not a bit test. */
        if (rec->attr[i] == 1)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_NONE_VerboseProgramAttrFlags);

        if (rec->attr[i] & 2)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_MOVIE_VerboseProgramAttrFlags);

        if (rec->attr[i] & 4)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_ALTHILITE_PROG_VerboseProgramAttrFlags);

        if (rec->attr[i] & 8)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_TAG_PROG_VerboseProgramAttrFlags);

        if (rec->attr[i] & 0x10)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_0X10);

        if (rec->attr[i] & 0x20)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_0X20_VerboseProgramAttrFlags);

        if (rec->attr[i] & 0x40)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_0X40);

        if (rec->attr[i] & 0x80)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_PREV_DAYS_DATA_VerboseProgramAttrFlags);

        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_ProgramAttrCloseAndProgPrefix);

        if (rec->str[i] != 0)
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_FMT_PCT_S_VerboseProgramStringLine, rec->str[i]);
        else
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NullLine);
    }

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NewlineOnly_B);
}
