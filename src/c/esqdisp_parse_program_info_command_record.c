/* RESTORES: ESQDISP_ParseProgramInfoCommandRecord
 * MODULE:   modules/groups/a/n/esqdispb_p0.s
 * STATUS:   behavioural
 *
 * Applies an incoming program-info command to every matching entry in a group.
 * The record is a group byte, a two-digit field width, and then a sequence of
 * name/field pairs delimited by control bytes 18 and 4.
 *
 * THE FIELD WIDTH IS PARSED, NOT COUNTED, and it is the bound on EVERY optional
 * field below. Each `n > k` test asks whether the sender supplied that many
 * characters. A width under 6 aborts the whole record; a width of exactly 6
 * means the two-character tag falls back to a constant instead of being read.
 *
 * THE PARSE IS DESTRUCTIVE. The delimiter byte 4 is overwritten with a NUL so
 * that the preceding name becomes a C string for the comparison. The caller's
 * buffer is modified.
 *
 * FIVE OF THE FLAGS LIVE IN THE LOW BYTE OF A WORD, and this is the part that
 * is easy to get wrong. The frame slot the original BSETs at -31(A5) is the
 * SECOND byte of the word it loaded at -32(A5) -- the entry field at +46. So
 * those five bits are not a separate variable; they are bits 0..4 of the word
 * that is then passed to FillProgramInfoHeaderFields. Treating -31 as its own
 * flags byte produces a function that compiles, matches roughly, and passes a
 * value with five bits missing.
 *
 * Writing them as `w46 |= 1` / `w46 &= ~1` on the short reproduces the
 * original's BSET and BCLR exactly -- 14 of each in the reference and 14 of
 * each here -- so 6.51 does narrow the operation to the byte on its own.
 *
 * THE TWO HEX FIELDS ARE VALIDATED DIFFERENTLY. The first accepts 0..15, the
 * second only 1..3, and both fall back to 255. The first field's LOW bound is
 * dead: the original compares an unsigned byte against 0 with `BCS`, which can
 * never be taken, so only the upper bound can reject. The second's low bound of
 * 1 is real. The C below writes only the tests that can fire, which is why the
 * two look asymmetric.
 *
 * WHEN THE GROUP MATCHES NEITHER TABLE the entry-table pointer is left
 * UNINITIALISED and the count stays 0. The `count <= 0` guard is what keeps the
 * function from dereferencing it. That guard is load-bearing, not defensive.
 *
 * A record whose name matches SEVERAL entries updates all of them -- the inner
 * loop does not stop at the first match.
 *
 * A _Return LABEL MEANS THE REFERENCE STOPS EARLY. The epilogue is branched to
 * from three places and has its own label, so refbytes.py extracts up to it and
 * the reference excludes the 8-byte MOVEM/UNLK/RTS that any C restoration
 * includes. Corrected, the reference is 1112.
 *
 * 1104 ref vs 1168 got, 26 differing regions -- so 56 bytes over a corrected
 * 1112. The group selection, the two-digit width parse, the width guards, the
 * destructive delimiter rewrite, the name comparison, all seven casefold
 * sequences with their BTST #1, both hex fields with their BTST #7 and their
 * distinct bounds, the tag copy and its constant fallback, all fourteen
 * BSET/BCLR flag updates and the six-argument fill call match in kind and size.
 *
 * SASC-MISMATCH: repeated-lea-of-the-class-table
 *   ref:     41f9........ 2248 d2c0 0811....   LEA table,A0 / MOVEA.L A0,A1 /
 *                                              ADDA.L D0,A1 / BTST
 *   got:     0839........ a BTST on an absolute address, no LEA
 *   summary: same divergence as the two gcommand parsers -- DATA=FAR lets 6.51
 *            test the bit in place. Nine sites here, and the original is again
 *            inconsistent about whether it keeps the base in A0 or copies it to
 *            A1 first, so the per-site cost varies.
 *   scope:   program-wide, at every indexed global read under DATA=FAR.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

struct EsqDispEntry {
    char          pad0[12];
    char          name[28];             /* +12 */
    unsigned char flags40;              /* +40 */
    char          pad41[5];
    short         w46;                  /* +46, low byte carries five flags */
};

extern long ESQIFF_JMPTBL_MATH_Mulu32(long a, long b);
extern long ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(long ch);
extern void ESQFUNC_JMPTBL_STRING_CopyPadNul(char *dst, char *src, long n);
extern void ESQDISP_FillProgramInfoHeaderFields(struct EsqDispEntry *e,
                                                long flags, long w46,
                                                long hex1, long hex2,
                                                char *tag);

extern struct EsqDispEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern struct EsqDispEntry *TEXTDISP_SecondaryEntryPtrTable[];

extern unsigned char WDISP_CharClassTable[];
extern char  ESQDISP_ProgramInfoZeroTag[];
extern char  TEXTDISP_PrimaryGroupCode;
extern char  TEXTDISP_SecondaryGroupCode;
extern char  TEXTDISP_PrimaryGroupPresentFlag;
extern char  TEXTDISP_SecondaryGroupPresentFlag;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern short TEXTDISP_SecondaryGroupEntryCount;

void ESQDISP_ParseProgramInfoCommandRecord(char *rec)
{
    struct EsqDispEntry **table;
    struct EsqDispEntry  *entry;
    char *segStart;
    char *field;
    char  tag[3];
    unsigned char flags1;
    unsigned char hex1;
    unsigned char hex2;
    short w46;
    long  groupCode;
    long  count;
    long  n;
    long  j;
    long  c;

    count = 0;

    groupCode = (long)(unsigned char)*rec++;

    if ((long)TEXTDISP_SecondaryGroupCode == groupCode
        && TEXTDISP_SecondaryGroupPresentFlag == 1) {
        count = TEXTDISP_SecondaryGroupEntryCount;
        table = TEXTDISP_SecondaryEntryPtrTable;
    } else if (groupCode == (long)TEXTDISP_PrimaryGroupCode) {
        count = TEXTDISP_PrimaryGroupEntryCount;
        table = TEXTDISP_PrimaryEntryPtrTable;
    }

    if (WDISP_CharClassTable[(long)*rec] & 4)
        n = ESQIFF_JMPTBL_MATH_Mulu32((long)*rec - 48, 10L);
    else
        n = 0;
    rec++;

    if (WDISP_CharClassTable[(long)*rec] & 4)
        n = n + (long)*rec - 48;
    rec++;

    if (count <= 0)
        return;

    if (n < 6)
        return;

    tag[2] = 0;

    while (*rec == 18) {

        rec++;
        segStart = rec;
        field    = 0;

        for (j = 0; j < 6; j++) {
            rec++;
            if (*rec == 4) {
                *rec++ = 0;
                field  = rec;
                rec   += n;
                break;
            }
        }

        if (field == 0)
            continue;

        for (j = 0; j < count; j++) {

            if (strcmp(table[j]->name, segStart) != 0)
                continue;

            entry  = table[j];
            flags1 = entry->flags40;
            w46    = entry->w46;

            if (n > 0) {
                if (WDISP_CharClassTable[(long)field[0]] & 2)
                    c = (long)field[0] - 32;
                else
                    c = (long)field[0];
                if (c == 89)
                    flags1 |= 2;
                else
                    flags1 &= ~2;
            }

            if (n > 1) {
                if (WDISP_CharClassTable[(long)field[1]] & 2)
                    c = (long)field[1] - 32;
                else
                    c = (long)field[1];
                if (c == 89)
                    flags1 |= 4;
                else
                    flags1 &= ~4;
            }

            if (n > 2 && (WDISP_CharClassTable[(long)field[2]] & 0x80))
                hex1 = (unsigned char)ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(
                           (long)field[2]);
            else
                hex1 = 0xff;

            if (hex1 > 15)
                hex1 = 0xff;

            if (n > 3 && (WDISP_CharClassTable[(long)field[3]] & 0x80))
                hex2 = (unsigned char)ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(
                           (long)field[3]);
            else
                hex2 = 0xff;

            if (hex2 < 1 || hex2 > 3)
                hex2 = 0xff;

            if (n > 5)
                ESQFUNC_JMPTBL_STRING_CopyPadNul(tag, field + 4, 2L);
            else
                strcpy(tag, ESQDISP_ProgramInfoZeroTag);

            if (n > 6) {
                if (WDISP_CharClassTable[(long)field[6]] & 2)
                    c = (long)field[6] - 32;
                else
                    c = (long)field[6];
                if (c == 89)
                    w46 |= 1;
                else
                    w46 &= ~1;
            }

            if (n > 7) {
                if (WDISP_CharClassTable[(long)field[7]] & 2)
                    c = (long)field[7] - 32;
                else
                    c = (long)field[7];
                if (c == 89)
                    w46 |= 2;
                else
                    w46 &= ~2;
            }

            if (n > 8) {
                if (WDISP_CharClassTable[(long)field[8]] & 2)
                    c = (long)field[8] - 32;
                else
                    c = (long)field[8];
                if (c == 89)
                    w46 |= 4;
                else
                    w46 &= ~4;
            }

            if (n > 9) {
                if (WDISP_CharClassTable[(long)field[9]] & 2)
                    c = (long)field[9] - 32;
                else
                    c = (long)field[9];
                if (c == 89)
                    w46 |= 8;
                else
                    w46 &= ~8;
            }

            if (n > 10) {
                if (WDISP_CharClassTable[(long)field[10]] & 2)
                    c = (long)field[10] - 32;
                else
                    c = (long)field[10];
                if (c == 89)
                    w46 |= 16;
                else
                    w46 &= ~16;
            }

            ESQDISP_FillProgramInfoHeaderFields(entry, (long)flags1,
                                                (long)w46, (long)hex1,
                                                (long)hex2, tag);
        }
    }
}
