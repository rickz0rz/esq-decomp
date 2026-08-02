/* RESTORES: WDISP_FormatWithCallback
 * MODULE:   modules/submodules/unknown28.s
 * STATUS:   behavioural
 *
 * SAS/C library code: the printf driver. It walks the format string, hands each
 * literal character to the callback, and defers anything after a '%' to
 * FORMAT_ParseFormatSpec.
 *
 * THE ARGUMENT CURSOR IS PASSED BY ADDRESS. The original copies the incoming
 * pointer into a local (`MOVE.L 16(A5),-10(A5)`) and then passes `PEA -10(A5)`
 * to the spec parser, which ADVANCES it past whatever it consumed. Passing the
 * pointer by value would restart every conversion at the first argument.
 *
 * A FAILED SPEC IS EMITTED LITERALLY. FORMAT_ParseFormatSpec returns the new
 * format cursor, or ZERO to mean "this is not a conversion I understand", and
 * the zero case falls into the literal path with the '%' still in hand. So an
 * unrecognised conversion prints its '%' and then continues from the character
 * after it -- it does not consume the rest of the specifier.
 *
 * "%%" IS HANDLED BEFORE THE PARSER IS ASKED, by stepping the cursor once and
 * falling into the literal path with the first '%' still in hand.
 *
 * THE CURSOR ADVANCES BEFORE THE TEST. `MOVE.B (A2)+,D7` then `CMP.B (A2),D0`
 * looks at the character AFTER the one in hand, which is what makes both the
 * "%%" check and the parser hand-off land on the right byte.
 *
 * THE CALLBACK'S RESULT IS DISCARDED -- `JSR (A3)` then `ADDQ.W #4,A7`. That is
 * why FORMAT_CallbackWriteChar's D1 return, which C cannot express, is not a
 * blocker; see lib_format_to_callback_buffer.c.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba  JSR (d16,PC)
 *   got:     6100  BSR.W
 *   scope:   program-wide.
 *   retest:  a compiler that picks the encoding per callee.
 */

extern char *FORMAT_ParseFormatSpec(char *fmt, void **args, long (*put)(long));

void WDISP_FormatWithCallback(long (*put)(long ch), char *fmt, void *args)
{
    void *argp = args;      /* the parser advances this through the varargs */

    for (;;) {
        char c = *fmt++;

        if (c == 0)
            return;

        if (c == '%') {
            if (*fmt == '%') {
                fmt++;                  /* "%%": emit one literal '%' */
            } else {
                char *next = FORMAT_ParseFormatSpec(fmt, &argp, put);

                if (next != 0) {
                    fmt = next;
                    continue;
                }
                /* zero: not a conversion -- fall through and emit the '%' */
            }
        }

        put((long)(unsigned char)c);
    }
}
