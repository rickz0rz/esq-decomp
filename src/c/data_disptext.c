/* RESTORES: (data module -- no function)
 * MODULE:   data/disptext.s
 * STATUS:   behavioural
 *
 * Nine strings, one flag and the month tables, 136 bytes. See
 * src/c/data_displib.c for why a data module can be replaced at all, and
 * AGENTS.md for the rules.
 *
 * 136 IS A MULTIPLE OF 4, so the object gains no padding and the DATA hunk keeps
 * its size.
 *
 * THE FLAG SITS AT OFFSET 18, WHICH IS EVEN BUT NOT 4-ALIGNED. Three one-space
 * strings occupy 12..17, and the original puts `DC.L 1` straight after them with
 * no CNOP -- legal on a 68000, which needs only word alignment for a long. This
 * is the first data module where the C compiler's own alignment could disagree
 * with the assembly, and it does not: SAS/C 6.51 aligns a long to two bytes and
 * places it at 18 as well. Do not assume that for a wider type; measure with
 * `python3 tools/objbytes.py` as here.
 *
 * THE LAST SYMBOL IS ONE LABEL OVER TWO TABLES, and its name says so. Twelve
 * month lengths as bytes, then twelve cumulative day offsets as longs, indexed
 * from the same base. Written as a struct, which is what keeps the two halves
 * together -- two separate arrays would be two objects and C says nothing about
 * where they land. The struct starts at 76 and its long half at 88, both
 * 4-aligned, so nothing has to be arranged.
 *
 * DAY OFFSETS ARE THE NON-LEAP CUMULATIVE TOTALS: 0, 31, 59, 90 ... 334. They
 * are the sums of the byte table above them and must stay consistent with it.
 */

struct DateTimeTables {
    unsigned char monthLength[12];      /* +0  */
    long          dayOffset[12];        /* +12 */
};

char Global_STR_DISPTEXT_C_1[12] = "DISPTEXT.c";

char DISPTEXT_STR_SINGLE_SPACE_MEASURE[2] = " ";
char DISPTEXT_STR_SINGLE_SPACE_APPEND[2]  = " ";
char DISPTEXT_STR_SINGLE_SPACE_DELIM[2]   = " ";

long DISPTEXT_InitBuffersPending = 1;

char Global_STR_DISPTEXT_C_2[12] = "DISPTEXT.c";
char Global_STR_DISPTEXT_C_3[12] = "DISPTEXT.c";
char Global_STR_DISPTEXT_C_4[12] = "DISPTEXT.c";
char Global_STR_DISPTEXT_C_5[12] = "DISPTEXT.c";

char DISPTEXT_STR_SINGLE_SPACE_PREFIX_1[2]    = " ";
char DISPTEXT_STR_SINGLE_SPACE_PREFIX_2[2]    = " ";
char DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX[2] = " ";

struct DateTimeTables DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES = {
    { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 },
    { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 }
};
