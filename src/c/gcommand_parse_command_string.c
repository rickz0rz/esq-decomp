/* RESTORES: GCOMMAND_ParseCommandString
 * MODULE:   modules/groups/a/s/gcommand_p1.s
 * STATUS:   behavioural
 *
 * Parses the Digital Mplex configuration command: a POSITIONAL string in which
 * each field is identified by where it sits, not by a name or a separator.
 *
 * THE LENGTH PREFIX IS THE FIRST TWO CHARACTERS, and it is parsed as a number
 * rather than counted. The first two bytes are copied into a scratch buffer,
 * terminated, and handed to the numeric reader; the result PLUS TWO becomes the
 * limit. Every field afterwards is read only if the cursor is still below that
 * limit, so a short prefix silently truncates the command and the remaining
 * globals keep the defaults FLIB2_LoadDigitalMplexDefaults just installed.
 *
 * The cursor ADVANCES EVEN WHEN THE FIELD IS SKIPPED. Each block is `if (below
 * the limit) { ... }` followed by an unconditional increment, so a field that
 * fails validation does not shift the ones after it. That is why the code below
 * repeats `i++` outside every guard rather than folding it into the body.
 *
 * The thirteen fields, in order, with the width each consumes:
 *
 *   1  Y/N, casefolded        DigitalMplexEnabledFlag
 *   1  digit 0..9             MplexModeCycleCount
 *   2  number 0..99           MplexSearchRowLimit
 *   2  number 0..29           MplexClockOffsetMinutes
 *   1  digit 1..3             MplexMessageTextPen
 *   1  hex digit              MplexMessageFramePen
 *   1  digit 1..3             MplexEditorLayoutPen
 *   1  hex digit              MplexEditorRowPen
 *   1  digit 1..3             MplexDetailLayoutPen
 *   1  digit 1..3             MplexDetailInitialLineIndex
 *   1  hex digit              MplexDetailRowPen
 *   1  F/B/L/N, casefolded    MplexWorkflowMode
 *   1  Y/N, casefolded        MplexDetailLayoutFlag
 *
 * THE TWO-DIGIT FIELDS ARE VALIDATED TWICE, and both halves are load-bearing.
 * The numeric reader is permissive -- it skips a character class and would
 * accept a sign or stray text -- so the original ALSO checks bit 2 of the
 * character-class table for each of the two digits individually. Dropping
 * either check accepts input the original rejects.
 *
 * CASEFOLDING IS DONE THROUGH THE CLASS TABLE, NOT BY RANGE. Bit 1 marks a
 * lowercase letter and the code subtracts 32; there is no `>= 'a'` compare
 * anywhere. The table is indexed by a SIGN-EXTENDED char, so a byte above 127
 * indexes BEFORE the table. That is the original's behaviour and the C below
 * reproduces it by leaving the char signed.
 *
 * The tail is whatever follows the last field, and its start is
 * `max(cursor, limit)` -- so an over-long prefix pushes the tail past where the
 * cursor stopped. It is split on byte 0x12 into an "at" part and a "listings"
 * part, each appended to its own owned string. The 127-byte clamp is applied to
 * the FIRST part only, and only after the split terminator has been written, so
 * the length being clamped is the post-split length.
 *
 * When the split marker is absent or is the last character, only the "at" part
 * is appended and the listings pointer is left alone.
 *
 * THE SUFFIX PATCH WRITES ONE BYTE PAST WHERE IT LOOKS. Having found the format
 * token in the assembled "at" template, the original computes the offset, ADDS
 * ONE, and stores 's' there -- so it overwrites the character AFTER the match
 * start, not the match start. `d += 1` below is deliberate.
 *
 * Every path ends by calling GCOMMAND_LoadMplexFile, including both early
 * guards. The null and empty-string checks are not early returns; they jump to
 * a shared tail that still loads the file.
 *
 * 1132 ref vs 1124 got, 26 differing regions over 1132 bytes. All thirteen
 * field blocks with their individual bounds, both class-table digit checks on
 * each two-digit field, all three casefold sequences with their BTST #1, the
 * three hex fields with their BTST #7, the tail split with its CLR.B (A0)+, the
 * strlen scan, the 127 clamp, all three ReplaceOwnedString calls and the suffix
 * patch match in kind and size.
 *
 * SASC-MISMATCH: repeated-lea-of-the-class-table
 *   ref:     41f9........ 2248 d2c0 0811....   LEA table,A0 / MOVEA.L A0,A1 /
 *                                              ADDA.L D0,A1 / BTST
 *            -- the original sometimes keeps the table base in A0 and indexes
 *               through a COPY in A1, and sometimes indexes A0 directly
 *   got:     0839........ a single BTST on an absolute address, no LEA at all
 *   summary: DATA=FAR gives 6.51 an absolute long for the table, so it tests the
 *            bit in place instead of forming an address. Fewer instructions,
 *            same effect. The original's own choice is inconsistent between the
 *            two-digit blocks, which is why the LEA count differs per block
 *            rather than uniformly.
 *   scope:   program-wide, at every indexed global read under DATA=FAR.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

extern void  FLIB2_LoadDigitalMplexDefaults(void);
extern void  GCOMMAND_LoadMplexFile(void);
extern void  GROUP_AW_JMPTBL_STRING_CopyPadNul(char *dst, char *src, long n);
extern long  ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern long  LADFUNC_ParseHexDigit(long ch);
extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(char *s, long ch);
extern char *GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(char *hay, char *needle);
extern char *ESQPARS_ReplaceOwnedString(char *newStr, char *old);

extern unsigned char WDISP_CharClassTable[];
extern char GCOMMAND_MplexParseScratchSeedWord[];
extern char GCOMMAND_FMT_PCT_T_MplexTemplateParse[];

extern char  GCOMMAND_DigitalMplexEnabledFlag;
extern long  GCOMMAND_MplexModeCycleCount;
extern long  GCOMMAND_MplexSearchRowLimit;
extern long  GCOMMAND_MplexClockOffsetMinutes;
extern long  GCOMMAND_MplexMessageTextPen;
extern long  GCOMMAND_MplexMessageFramePen;
extern long  GCOMMAND_MplexEditorLayoutPen;
extern long  GCOMMAND_MplexEditorRowPen;
extern long  GCOMMAND_MplexDetailLayoutPen;
extern long  GCOMMAND_MplexDetailInitialLineIndex;
extern long  GCOMMAND_MplexDetailRowPen;
extern char  GCOMMAND_MplexWorkflowMode;
extern char  GCOMMAND_MplexDetailLayoutFlag;
extern char *GCOMMAND_MplexListingsTemplatePtr;
extern char *GCOMMAND_MplexAtTemplatePtr;

void GCOMMAND_ParseCommandString(char *cmd)
{
    char  scratch[4];
    char  marker;
    char *split;
    char *suffix;
    char *tail;
    long  i;
    long  limit;
    long  c;
    long  v;
    long  len;

    memcpy(scratch, GCOMMAND_MplexParseScratchSeedWord, 4);

    c = 0;
    v = 0;
    marker = 0x12;
    suffix = split = 0;

    FLIB2_LoadDigitalMplexDefaults();

    if (cmd != 0 && *cmd != 0) {

        GROUP_AW_JMPTBL_STRING_CopyPadNul(scratch, cmd, 2L);
        scratch[2] = 0;
        limit = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch) + 2;

        i = 2;

        /* Y/N -> DigitalMplexEnabledFlag */
        if (i < limit) {
            if (WDISP_CharClassTable[(long)cmd[i]] & 2)
                c = (long)cmd[i] - 32;
            else
                c = (long)cmd[i];
            if ((char)c == 'Y' || (char)c == 'N')
                GCOMMAND_DigitalMplexEnabledFlag = (char)c;
        }
        i++;

        /* digit 0..9 -> MplexModeCycleCount */
        if (i < limit) {
            v = (long)cmd[i] - 48;
            if (v >= 0 && v <= 9)
                GCOMMAND_MplexModeCycleCount = v;
        }
        i++;

        /* number 0..99 -> MplexSearchRowLimit */
        if (i < limit) {
            scratch[0] = cmd[i];
            scratch[1] = cmd[i + 1];
            scratch[2] = 0;
            v = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);
            if (v >= 0 && v <= 99
                && (WDISP_CharClassTable[(long)scratch[0]] & 4)
                && (WDISP_CharClassTable[(long)scratch[1]] & 4))
                GCOMMAND_MplexSearchRowLimit = v;
        }
        i += 2;

        /* number 0..29 -> MplexClockOffsetMinutes */
        if (i < limit) {
            scratch[0] = cmd[i];
            scratch[1] = cmd[i + 1];
            scratch[2] = 0;
            v = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);
            if (v >= 0 && v <= 29
                && (WDISP_CharClassTable[(long)scratch[0]] & 4)
                && (WDISP_CharClassTable[(long)scratch[1]] & 4))
                GCOMMAND_MplexClockOffsetMinutes = v;
        }
        i += 2;

        /* digit 1..3 -> MplexMessageTextPen */
        if (i < limit) {
            v = (long)cmd[i] - 48;
            if (v >= 1 && v <= 3)
                GCOMMAND_MplexMessageTextPen = v;
        }
        i++;

        /* hex digit -> MplexMessageFramePen */
        if (i < limit) {
            c = (long)cmd[i];
            if (WDISP_CharClassTable[c] & 0x80)
                GCOMMAND_MplexMessageFramePen =
                    (long)(unsigned char)LADFUNC_ParseHexDigit(c);
        }
        i++;

        /* digit 1..3 -> MplexEditorLayoutPen */
        if (i < limit) {
            v = (long)cmd[i] - 48;
            if (v >= 1 && v <= 3)
                GCOMMAND_MplexEditorLayoutPen = v;
        }
        i++;

        /* hex digit -> MplexEditorRowPen */
        if (i < limit) {
            c = (long)cmd[i];
            if (WDISP_CharClassTable[c] & 0x80)
                GCOMMAND_MplexEditorRowPen =
                    (long)(unsigned char)LADFUNC_ParseHexDigit(c);
        }
        i++;

        /* digit 1..3 -> MplexDetailLayoutPen */
        if (i < limit) {
            v = (long)cmd[i] - 48;
            if (v >= 1 && v <= 3)
                GCOMMAND_MplexDetailLayoutPen = v;
        }
        i++;

        /* digit 1..3 -> MplexDetailInitialLineIndex */
        if (i < limit) {
            v = (long)cmd[i] - 48;
            if (v >= 1 && v <= 3)
                GCOMMAND_MplexDetailInitialLineIndex = v;
        }
        i++;

        /* hex digit -> MplexDetailRowPen */
        if (i < limit) {
            c = (long)cmd[i];
            if (WDISP_CharClassTable[c] & 0x80)
                GCOMMAND_MplexDetailRowPen =
                    (long)(unsigned char)LADFUNC_ParseHexDigit(c);
        }
        i++;

        /* F/B/L/N -> MplexWorkflowMode */
        if (i < limit) {
            if (WDISP_CharClassTable[(long)cmd[i]] & 2)
                c = (long)cmd[i] - 32;
            else
                c = (long)cmd[i];
            if ((char)c == 'F' || (char)c == 'B' || (char)c == 'L'
                || (char)c == 'N')
                GCOMMAND_MplexWorkflowMode = (char)c;
        }
        i++;

        /* Y/N -> MplexDetailLayoutFlag */
        if (i < limit) {
            if (WDISP_CharClassTable[(long)cmd[i]] & 2)
                c = (long)cmd[i] - 32;
            else
                c = (long)cmd[i];
            if ((char)c == 'Y' || (char)c == 'N')
                GCOMMAND_MplexDetailLayoutFlag = (char)c;
        }
        i++;

        if (i <= limit)
            i = limit;

        tail = cmd + i;

        if (*tail != 0) {

            split = GROUP_AS_JMPTBL_STR_FindCharPtr(tail, (long)marker);

            if (split != 0 && *split != 0) {

                *split++ = 0;

                len = strlen(cmd + i);
                if (len > 127)
                    cmd[i + 127] = 0;

                if (cmd[i] != 0)
                    GCOMMAND_MplexAtTemplatePtr = ESQPARS_ReplaceOwnedString(
                        cmd + i, GCOMMAND_MplexAtTemplatePtr);

                if (split != 0 && *split != 0)
                    GCOMMAND_MplexListingsTemplatePtr =
                        ESQPARS_ReplaceOwnedString(
                            split, GCOMMAND_MplexListingsTemplatePtr);

            } else if (cmd[i] != 0) {
                GCOMMAND_MplexAtTemplatePtr = ESQPARS_ReplaceOwnedString(
                    cmd + i, GCOMMAND_MplexAtTemplatePtr);
            }
        }

        suffix = 0;
        if (GCOMMAND_MplexAtTemplatePtr != 0
            && *GCOMMAND_MplexAtTemplatePtr != 0)
            suffix = GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(
                GCOMMAND_MplexAtTemplatePtr,
                GCOMMAND_FMT_PCT_T_MplexTemplateParse);

        if (suffix != 0 && *suffix != 0) {
            v = (suffix - GCOMMAND_MplexAtTemplatePtr) + 1;
            GCOMMAND_MplexAtTemplatePtr[v] = 's';
        }
    }

    GCOMMAND_LoadMplexFile();
}
