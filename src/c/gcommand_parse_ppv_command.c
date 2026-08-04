/* RESTORES: GCOMMAND_ParsePPVCommand
 * MODULE:   modules/groups/a/s/gcommand_p2.s
 * STATUS:   behavioural
 *
 * The pay-per-view sibling of gcommand_parse_command_string.c. Same positional
 * scheme, same two-character length prefix, same casefold-through-the-class-
 * table idiom, same cursor-advances-even-when-skipped rule. Read that file
 * first; only the differences are written up here.
 *
 * FOURTEEN fields rather than thirteen:
 *
 *   1  Y/N, casefolded        DigitalPpvEnabledFlag
 *   1  digit 0..9             PpvModeCycleCount
 *   3  number 0..999          PpvSelectionWindowMinutes
 *   3  number 0..999          PpvSelectionToleranceMinutes
 *   1  digit 1..3             PpvMessageTextPen
 *   1  hex digit              PpvMessageFramePen
 *   1  digit 1..3             PpvEditorLayoutPen
 *   1  hex digit              PpvEditorRowPen
 *   1  digit 1..3             PpvShowtimesLayoutPen
 *   1  digit 1..3             PpvShowtimesInitialLineIndex
 *   1  hex digit              PpvShowtimesRowPen
 *   1  F/B/L/N, casefolded    PpvShowtimesWorkflowMode
 *   1  Y/N, casefolded        PpvDetailLayoutFlag
 *   2  number, unbounded      PpvShowtimesRowSpan
 *
 * The two numeric fields are THREE digits wide here, not two, and each gets
 * three separate class-table checks rather than two.
 *
 * THE LAST FIELD'S BOUND CHECK CANNOT REJECT ANYTHING. The original reads the
 * value, branches to the store when it is non-negative, and otherwise compares
 * it against 96 and skips the store only if it is GREATER. A value that reached
 * that compare is negative by construction, so it can never exceed 96 and the
 * store always runs. The bound is dead in the shipped program.
 *
 * KEEPING THAT DEAD BOUND COSTS 12 BYTES AND IS STILL THE RIGHT CALL, and the
 * three spellings were measured against each other:
 *
 *   if (v >= 0)                     1200 bytes, no MOVEQ #96 emitted
 *   if (v >= 0 || v <= 96)          1208 bytes, no MOVEQ #96 emitted
 *   if (!(v < 0 && v > 96))         1208 bytes, no MOVEQ #96 emitted
 *   if (v >= 0 || v <= bound)       1212 bytes, MOVEQ #96 EMITTED
 *
 * against a reference of 1182 that contains `7060` -- MOVEQ #96,D0 -- exactly
 * once. Only the last form puts that instruction in the output, and it does so
 * for the reason AGENTS.md gives for the zero-local trick: comparing against a
 * literal lets 6.51 reason about the value and fold the unreachable arm,
 * comparing against a local holding that literal does not. It is the same lever
 * applied to a nonzero constant.
 *
 * So the file pays 4 bytes over the cheapest correct spelling to carry an
 * instruction the shipped program actually has. AGENTS.md rule 1 -- prefer the
 * candidate that contains the original's instructions over the one with the
 * better headline number -- decides it, and this is the case the rule is for:
 * the smallest candidate is the LEAST faithful of the four.
 *
 * TWO MORE DIFFERENCES IN THE TAIL, both of which look like transcription slips
 * and are not.
 *
 * First, the split test compares `*split` against THE MARKER, not against zero.
 * The Mplex parser tests it against zero. Since the search returned a pointer to
 * the marker, the two agree in every reachable case -- but they are different
 * instructions and the original uses the marker here.
 *
 * Second, and this one is observable: the fallback path TESTS one pointer and
 * APPENDS a different one. It tests `cmd[tailStart]` for emptiness and then
 * passes `cmd + cursor` to the append. Those two indices are equal only when
 * the cursor stopped exactly at the tail start. When the prefix declared a
 * length beyond where the fields ended, tailStart is the larger of the two and
 * the appended string begins EARLIER than the string that was tested. Written
 * out below exactly as the original has it.
 *
 * The successful split path also scans the tail length a SECOND time, after the
 * 127-byte clamp, and appends only when that second length is above zero. The
 * first scan measures for the clamp; the second decides whether there is
 * anything left to append. They are not the same number once the clamp fires.
 *
 * 1182 ref vs 1212 got, 26 differing regions over 1182 bytes. All fourteen
 * field blocks with their individual bounds, the three class-table digit checks
 * on each of the two three-digit fields, all four casefold sequences with their
 * BTST #1, the three hex fields with their BTST #7, the MOVEQ #96 dead bound,
 * the marker-valued split test, the CLR.B (A0)+ split, both strlen scans, the
 * 127 clamp and all three ReplaceOwnedString calls match in kind and size.
 *
 * SASC-MISMATCH: repeated-lea-of-the-class-table
 *   ref:     41f9........ 2248 d2c0 0811....   LEA table,A0 / MOVEA.L A0,A1 /
 *                                              ADDA.L D0,A1 / BTST
 *   got:     0839........ a single BTST on an absolute address, no LEA at all
 *   summary: same divergence as gcommand_parse_command_string.c, and the
 *            dominant one here too. DATA=FAR gives 6.51 an absolute long for
 *            the table, so it tests the bit in place. The original reloads the
 *            table base for some blocks and reuses a copy in A1 for others,
 *            which is why the per-block cost is uneven rather than constant.
 *   scope:   program-wide, at every indexed global read under DATA=FAR.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

extern void  FLIB2_LoadDigitalPpvDefaults(void);
extern void  GCOMMAND_LoadPPVTemplate(void);
extern void  STRING_CopyPadNul(char *dst, char *src, long n);
extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern long  LADFUNC_ParseHexDigit(long ch);
extern char *STR_FindCharPtr(char *s, long ch);
extern char *ESQPARS_ReplaceOwnedString(char *newStr, char *old);

extern unsigned char WDISP_CharClassTable[];
extern char GCOMMAND_PpvParseScratchSeedLong[];

extern char  GCOMMAND_DigitalPpvEnabledFlag;
extern long  GCOMMAND_PpvModeCycleCount;
extern long  GCOMMAND_PpvSelectionWindowMinutes;
extern long  GCOMMAND_PpvSelectionToleranceMinutes;
extern long  GCOMMAND_PpvMessageTextPen;
extern long  GCOMMAND_PpvMessageFramePen;
extern long  GCOMMAND_PpvEditorLayoutPen;
extern long  GCOMMAND_PpvEditorRowPen;
extern long  GCOMMAND_PpvShowtimesLayoutPen;
extern long  GCOMMAND_PpvShowtimesInitialLineIndex;
extern long  GCOMMAND_PpvShowtimesRowPen;
extern char  GCOMMAND_PpvShowtimesWorkflowMode;
extern char  GCOMMAND_PpvDetailLayoutFlag;
extern long  GCOMMAND_PpvShowtimesRowSpan;
extern char *GCOMMAND_PPVPeriodTemplatePtr;
extern char *GCOMMAND_PPVListingsTemplatePtr;

void GCOMMAND_ParsePPVCommand(char *cmd)
{
    char  scratch[4];
    char  marker;
    char *split;
    long  i;
    long  t;
    long  limit;
    long  c;
    long  v;
    long  len;
    long  bound;

    memcpy(scratch, GCOMMAND_PpvParseScratchSeedLong, 4);

    c = 0;
    v = 0;
    marker = 0x12;
    bound = 96;
    split = 0;

    FLIB2_LoadDigitalPpvDefaults();

    if (cmd != 0 && *cmd != 0) {

        STRING_CopyPadNul(scratch, cmd, 2L);
        scratch[2] = 0;
        limit = PARSE_ReadSignedLongSkipClass3_Alt(scratch) + 2;

        i = 2;

        /* Y/N -> DigitalPpvEnabledFlag */
        if (i < limit) {
            if (WDISP_CharClassTable[(long)cmd[i]] & 2)
                c = (long)cmd[i] - 32;
            else
                c = (long)cmd[i];
            if ((char)c == 'Y' || (char)c == 'N')
                GCOMMAND_DigitalPpvEnabledFlag = (char)c;
        }
        i++;

        /* digit 0..9 -> PpvModeCycleCount */
        if (i < limit) {
            v = (long)cmd[i] - 48;
            if (v >= 0 && v <= 9)
                GCOMMAND_PpvModeCycleCount = v;
        }
        i++;

        /* number 0..999 -> PpvSelectionWindowMinutes */
        if (i < limit) {
            scratch[0] = cmd[i];
            scratch[1] = cmd[i + 1];
            scratch[2] = cmd[i + 2];
            scratch[3] = 0;
            v = PARSE_ReadSignedLongSkipClass3_Alt(scratch);
            if (v >= 0 && v <= 999
                && (WDISP_CharClassTable[(long)scratch[0]] & 4)
                && (WDISP_CharClassTable[(long)scratch[1]] & 4)
                && (WDISP_CharClassTable[(long)scratch[2]] & 4))
                GCOMMAND_PpvSelectionWindowMinutes = v;
        }
        i += 3;

        /* number 0..999 -> PpvSelectionToleranceMinutes */
        if (i < limit) {
            scratch[0] = cmd[i];
            scratch[1] = cmd[i + 1];
            scratch[2] = cmd[i + 2];
            scratch[3] = 0;
            v = PARSE_ReadSignedLongSkipClass3_Alt(scratch);
            if (v >= 0 && v <= 999
                && (WDISP_CharClassTable[(long)scratch[0]] & 4)
                && (WDISP_CharClassTable[(long)scratch[1]] & 4)
                && (WDISP_CharClassTable[(long)scratch[2]] & 4))
                GCOMMAND_PpvSelectionToleranceMinutes = v;
        }
        i += 3;

        /* digit 1..3 -> PpvMessageTextPen */
        if (i < limit) {
            v = (long)cmd[i] - 48;
            if (v >= 1 && v <= 3)
                GCOMMAND_PpvMessageTextPen = v;
        }
        i++;

        /* hex digit -> PpvMessageFramePen */
        if (i < limit) {
            c = (long)cmd[i];
            if (WDISP_CharClassTable[c] & 0x80)
                GCOMMAND_PpvMessageFramePen =
                    (long)(unsigned char)LADFUNC_ParseHexDigit(c);
        }
        i++;

        /* digit 1..3 -> PpvEditorLayoutPen */
        if (i < limit) {
            v = (long)cmd[i] - 48;
            if (v >= 1 && v <= 3)
                GCOMMAND_PpvEditorLayoutPen = v;
        }
        i++;

        /* hex digit -> PpvEditorRowPen */
        if (i < limit) {
            c = (long)cmd[i];
            if (WDISP_CharClassTable[c] & 0x80)
                GCOMMAND_PpvEditorRowPen =
                    (long)(unsigned char)LADFUNC_ParseHexDigit(c);
        }
        i++;

        /* digit 1..3 -> PpvShowtimesLayoutPen */
        if (i < limit) {
            v = (long)cmd[i] - 48;
            if (v >= 1 && v <= 3)
                GCOMMAND_PpvShowtimesLayoutPen = v;
        }
        i++;

        /* digit 1..3 -> PpvShowtimesInitialLineIndex */
        if (i < limit) {
            v = (long)cmd[i] - 48;
            if (v >= 1 && v <= 3)
                GCOMMAND_PpvShowtimesInitialLineIndex = v;
        }
        i++;

        /* hex digit -> PpvShowtimesRowPen */
        if (i < limit) {
            c = (long)cmd[i];
            if (WDISP_CharClassTable[c] & 0x80)
                GCOMMAND_PpvShowtimesRowPen =
                    (long)(unsigned char)LADFUNC_ParseHexDigit(c);
        }
        i++;

        /* F/B/L/N -> PpvShowtimesWorkflowMode */
        if (i < limit) {
            if (WDISP_CharClassTable[(long)cmd[i]] & 2)
                c = (long)cmd[i] - 32;
            else
                c = (long)cmd[i];
            if ((char)c == 'F' || (char)c == 'B' || (char)c == 'L'
                || (char)c == 'N')
                GCOMMAND_PpvShowtimesWorkflowMode = (char)c;
        }
        i++;

        /* Y/N -> PpvDetailLayoutFlag */
        if (i < limit) {
            if (WDISP_CharClassTable[(long)cmd[i]] & 2)
                c = (long)cmd[i] - 32;
            else
                c = (long)cmd[i];
            if ((char)c == 'Y' || (char)c == 'N')
                GCOMMAND_PpvDetailLayoutFlag = (char)c;
        }
        i++;

        /* two-character number, bound unreachable -> PpvShowtimesRowSpan */
        if (i < limit) {
            STRING_CopyPadNul(scratch, cmd + i, 2L);
            scratch[2] = 0;
            v = PARSE_ReadSignedLongSkipClass3_Alt(scratch);
            if (v >= 0 || v <= bound)
                GCOMMAND_PpvShowtimesRowSpan = v;
        }
        i += 2;

        if (i <= limit)
            t = limit;
        else
            t = i;

        if (cmd[t] != 0) {

            split = STR_FindCharPtr(cmd + t, (long)marker);

            if (split != 0 && *split == marker) {

                *split++ = 0;

                len = strlen(cmd + t);
                if (len > 127)
                    cmd[t + 127] = 0;

                len = strlen(cmd + t);
                if (len > 0)
                    GCOMMAND_PPVPeriodTemplatePtr = ESQPARS_ReplaceOwnedString(
                        cmd + t, GCOMMAND_PPVPeriodTemplatePtr);

                if (split != 0 && *split != 0)
                    GCOMMAND_PPVListingsTemplatePtr =
                        ESQPARS_ReplaceOwnedString(
                            split, GCOMMAND_PPVListingsTemplatePtr);

            } else if (cmd[t] != 0) {
                GCOMMAND_PPVPeriodTemplatePtr = ESQPARS_ReplaceOwnedString(
                    cmd + i, GCOMMAND_PPVPeriodTemplatePtr);
            }
        }
    }

    GCOMMAND_LoadPPVTemplate();
}
