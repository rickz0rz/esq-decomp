/* RESTORES: _FORMAT_ParseFormatSpec
 * MODULE:   modules/submodules/unknown27_p0.s
 * STATUS:   behavioural
 *
 * The printf conversion engine. `WDISP_FormatWithCallback` hands it the format
 * string just past a `%`, and it parses flags, width, precision and length,
 * formats one conversion into a work buffer, emits it through the callback and
 * returns the format pointer positioned after the spec. It returns NULL when
 * the conversion character is not one it knows, and the caller then emits the
 * spec literally.
 *
 * `args` IS A POINTER TO THE ARGUMENT CURSOR, not the cursor itself. Every read
 * is `MOVEA.L (A2),A0 / ADDQ.L #4,(A2) / MOVE.L (A0),D0` -- load through it,
 * then advance the pointed-to value. That is why the parameter is `void **`:
 * the caller's cursor has to move as arguments are consumed.
 *
 * THE `l` MODIFIER IS PARSED AND THEN DOES NOTHING, and the original makes that
 * explicit in a way worth preserving in the record. Every conversion branches on
 * it and BOTH ARMS ARE IDENTICAL:
 *
 *     TST.B   -15(A5)
 *     BEQ.S   .conv_signed_long
 *     MOVEA.L (A2),A0 / ADDQ.L #4,(A2) / MOVE.L (A0),D0
 *     BRA.S   .conv_signed_done
 * .conv_signed_long:
 *     MOVEA.L (A2),A0 / ADDQ.L #4,(A2) / MOVE.L (A0),D0
 *
 * Both read four bytes, because a short is promoted to a long in a variadic
 * argument block anyway. `h` is likewise consumed and ignored. This file reads
 * one long per conversion and records the flag only so the parse advances.
 *
 * THE WORK BUFFER AND ITS CURSOR ARE SEPARATE. `-48(A5)` is the buffer and
 * `-52(A5)` is a cursor into it. A sign or an alternate-form prefix is written
 * at the buffer start and the cursor is stepped past it, so the digit routine
 * writes AFTER the prefix. `emitLen` counts the prefix; the digit count does
 * not. After precision padding the cursor is reset to the buffer start, which is
 * what makes the emit loop send prefix and digits together.
 *
 * `%p` IS NOT `%x`. The dispatch sends 'p' to a path that first forces the pad
 * character to '0' and, when no precision was given, sets precision to 8 -- so a
 * pointer always prints eight zero-padded digits. 'x' and 'X' share the plain
 * hex path and take no such treatment. 'X' is distinguished from 'x' only at the
 * end, by re-reading the saved conversion character and upper-casing the buffer.
 *
 * THE TWO EMIT LOOPS ARE DECREMENT-THEN-BRANCH. `SUBQ.L #1,n / BLT` writes the
 * decremented value back and exits when it goes NEGATIVE, so each loop runs
 * exactly n times. Writing either as a pre-test would be off by one.
 *
 * A NULL `%s` PRINTS NOTHING. The original points the cursor at a two-byte
 * constant in its own CODE section that is just a NUL. This file uses a local
 * instead: a string literal would emit a DATA hunk, and four bytes of DATA
 * growth is recorded in AGENTS.md as enough to shift every symbol after it.
 *
 * SASC-MISMATCH: near-data-and-frame
 *   ref:     a LINK.W A5,#-60 frame with fourteen named slots
 *   got:     ordinary locals, which 6.51 allocates as it sees fit
 *   summary: the original reserves A5 as a frame pointer and addresses every
 *            local off it. This is the project's central divergence and it is
 *            not option-selectable. See docs/compiler-version.md.
 *   scope:   program-wide.
 *   retest:  a compiler that emits 2f0b on the acceptance test.
 */

extern long  PARSE_ReadSignedLong_NoBranch(char *s, long *out);
extern long  FORMAT_U32ToDecimalString(char *buf, unsigned long value);
extern long  FORMAT_U32ToOctalString(char *buf, unsigned long value);
extern long  FORMAT_U32ToHexString(char *buf, unsigned long value);
extern char *STRING_ToUpperInPlace(char *s);
extern void  MEM_Move(char *src, char *dst, long n);

/* Pull the next four bytes out of the caller's argument block. */
static long next_arg(void **args)
{
    long *p = (long *)*args;

    *args = (void *)((char *)*args + 4);
    return *p;
}

char *FORMAT_ParseFormatSpec(char *fmt, void **args, long (*put)(long))
{
    char  work[44];         /* -48(A5), the conversion work buffer */
    char  nulls[2];         /* the empty string a NULL %s prints */
    char *cursor;           /* -52(A5) */
    char  padChar;          /* -5(A5)  */
    char  altForm;          /* -4(A5)  */
    char  lengthLong;       /* -15(A5), parsed and then unused */
    char  convChar;         /* -16(A5) */
    long  width;            /* -10(A5) */
    long  precision;        /* -14(A5) */
    long  value;            /* -20(A5) */
    long  negative;         /* -24(A5) */
    long  emitLen;          /* -28(A5) */
    long  digits;           /* -56(A5) */
    long  padCount;         /* -60(A5) */
    long  leftJustify;      /* D7 */
    long  plusFlag;         /* D6 */
    long  spaceFlag;        /* D5 */

    leftJustify = 0;
    plusFlag    = 0;
    spaceFlag   = 0;
    padChar     = ' ';
    width       = 0;
    precision   = -1;
    lengthLong  = 0;
    altForm     = 0;
    emitLen     = 0;
    negative    = 0;
    cursor      = work;

    nulls[0] = 0;
    nulls[1] = 0;

    /* ---- flags ---------------------------------------------------------- */
    while (*fmt != 0) {
        if (*fmt == ' ')
            spaceFlag = 1;
        else if (*fmt == '#')
            altForm = 1;
        else if (*fmt == '+')
            plusFlag = 1;
        else if (*fmt == '-')
            leftJustify = 1;
        else
            break;
        fmt++;
    }

    if (*fmt == '0') {
        fmt++;
        padChar = '0';
    }

    /* ---- width ---------------------------------------------------------- */
    if (*fmt == '*') {
        width = next_arg(args);
        fmt++;
    } else {
        fmt += PARSE_ReadSignedLong_NoBranch(fmt, &width);
    }

    /* ---- precision ------------------------------------------------------ */
    if (*fmt == '.') {
        fmt++;
        if (*fmt == '*') {
            precision = next_arg(args);
            fmt++;
        } else {
            fmt += PARSE_ReadSignedLong_NoBranch(fmt, &precision);
        }
    }

    /* ---- length: consumed, never used ----------------------------------- */
    if (*fmt == 'l') {
        lengthLong = 1;
        fmt++;
    } else if (*fmt == 'h') {
        fmt++;
    }

    /* ---- conversion ----------------------------------------------------- */
    convChar = *fmt++;

    switch (convChar) {
    case 'd':
        value = next_arg(args);
        if (value < 0) {
            value = -value;
            negative = 1;
        }
        if (negative)
            work[0] = '-';
        else if (plusFlag)
            work[0] = '+';
        else
            work[0] = ' ';
        if (negative || plusFlag || spaceFlag) {
            cursor++;
            emitLen++;
        }
        digits = FORMAT_U32ToDecimalString(cursor, (unsigned long)value);
        break;

    case 'u':
        value  = next_arg(args);
        digits = FORMAT_U32ToDecimalString(cursor, (unsigned long)value);
        break;

    case 'o':
        value = next_arg(args);
        if (altForm) {
            *cursor++ = '0';
            emitLen = 1;
        }
        digits = FORMAT_U32ToOctalString(cursor, (unsigned long)value);
        break;

    case 'p':
        /* Zero-padded to eight digits unless the caller said otherwise. */
        padChar = '0';
        if (precision < 0)
            precision = 8;
        /* fall through */
    case 'x':
    case 'X':
        value = next_arg(args);
        if (altForm) {
            *cursor++ = '0';
            *cursor++ = 'x';
            emitLen = 2;
        }
        digits = FORMAT_U32ToHexString(cursor, (unsigned long)value);
        if (convChar == 'X')
            STRING_ToUpperInPlace(work);
        break;

    case 's': {
        char *s = (char *)next_arg(args);
        char *e;

        if (s == 0)
            s = nulls;
        cursor = s;

        e = s;
        while (*e != 0)
            e++;
        emitLen = (long)(e - s);

        if (precision >= 0 && precision < emitLen)
            emitLen = precision;
        goto emit;
    }

    case 'c':
        emitLen  = 1;
        work[0]  = (char)next_arg(args);
        work[1]  = 0;
        goto emit;

    default:
        return (char *)0;
    }

    /* ---- precision padding, for the numeric conversions ------------------ */
    if (precision < 0)
        precision = 1;

    padCount = precision - digits;
    if (padCount > 0) {
        char *fill = cursor;

        /* Shift the digits right, then fill the gap. The original moves a
         * COPY of the cursor while filling and resets the stored one after,
         * so the fill must not disturb `cursor`. */
        MEM_Move(cursor, cursor + padCount, digits);
        while (padCount-- > 0)
            *fill++ = padChar;
        digits = precision;
    }
    emitLen += digits;
    cursor   = work;

    if (leftJustify)
        padChar = ' ';

emit:
    /* ---- field width ---------------------------------------------------- */
    if (width >= emitLen)
        width -= emitLen;
    else
        width = 0;

    if (leftJustify) {
        while (emitLen-- > 0)
            (*put)((long)(unsigned char)*cursor++);
        while (width-- > 0)
            (*put)((long)(unsigned char)padChar);
    } else {
        while (width-- > 0)
            (*put)((long)(unsigned char)padChar);
        while (emitLen-- > 0)
            (*put)((long)(unsigned char)*cursor++);
    }

    /* `lengthLong` is recorded so the parse advances correctly and is then
     * deliberately unused -- see the header. */
    (void)lengthLong;

    return fmt;
}
