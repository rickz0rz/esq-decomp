/* RESTORES: LADFUNC2_EmitEscapedStringWithLimit
 * MODULE:   modules/groups/a/x/ladfunc2.s
 * STATUS:   behavioural
 *
 * THREE FUNCTIONS, AND ONLY ONE CARRIES AN ENTRY LABEL. This module is the
 * "not every function has a label" case in AGENTS.md, in its sharpest form: the
 * label `LADFUNC2_EmitEscapedStringWithLimit` is not on an entry point at all.
 * It sits on the LOOP TOP, ten bytes past the `MOVEM` that starts the function.
 * The other two functions have no entry label, only `_Return` epilogue labels.
 *
 * NOTHING IN THE PROGRAM REFERENCES ANY OF THE THREE. A grep over src/modules
 * and src/data finds no caller outside this file, and the file contains no
 * internal call to them either. The only LADFUNC2 symbol anything reaches is
 * _LADFUNC2_EmitEscapedStringToScratch, which lives in a different module. So
 * all three are dead code that the original still assembles.
 *
 * That makes the misplaced label safe to correct here. The C exports
 * LADFUNC2_EmitEscapedStringWithLimit at the FUNCTION ENTRY rather than ten
 * bytes in. Had anything called the exported address the change would alter
 * behaviour -- it would skip the argument loads and the null test. Nothing
 * does, so it does not.
 *
 * The two unlabelled functions are named after what they do, since there is no
 * original name to keep.
 *
 * THE LIMIT IS COUNTED, THEN TESTED, THEN INCREMENTED -- `MOVE.L D6,D0 / ADDQ.L
 * #1,D6 / CMP.L D7,D0`. The test uses the value BEFORE the increment, so the
 * routine emits exactly `limit` characters. Testing the incremented value would
 * emit one fewer.
 *
 * THE CHUNKED FORM CLOSES AND REOPENS THE QUOTES at every multiple of `chunk`,
 * and the `> 0` test suppresses the closing quote on the first pass so the
 * output does not start with a stray newline.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   scope:   program-wide under SAS/C 6.51. See AGENTS.md.
 */

extern void LADFUNC2_EmitEscapedCharToScratch(long c);
extern void GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...);
extern char LADFUNC_STR_QuoteAndNewline[];
extern char LADFUNC_STR_Quote[];

/* Unlabelled in the original: `MOVEQ #97,D0 / RTS`, four bytes, no caller. */
long LADFUNC2_ReturnsLowercaseA(void)
{
    return 97;
}

void LADFUNC2_EmitEscapedStringWithLimit(char *text, long limit)
{
    long emitted = 0;

    if (text == 0)
        return;

    while (*text != 0) {
        /* the PRE-increment value is what the limit is tested against */
        if (emitted++ >= limit)
            return;
        LADFUNC2_EmitEscapedCharToScratch((long)(unsigned char)*text++);
    }
}

/* Unlabelled in the original; named for the `_Return` label that follows it. */
void LADFUNC2_EmitEscapedStringChunked(char *text, long chunk)
{
    long emitted = 0;

    if (text == 0)
        return;

    while (*text != 0) {
        if ((emitted - (emitted / chunk) * chunk) == 0) {
            if (emitted > 0)
                GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                    LADFUNC_STR_QuoteAndNewline);
            GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(LADFUNC_STR_Quote);
        }
        LADFUNC2_EmitEscapedCharToScratch((long)(unsigned char)*text++);
        emitted++;
    }
}
