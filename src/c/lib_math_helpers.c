/* RESTORES: (SAS/C arithmetic helpers -- 3 routines under 6 names)
 * MODULE:   modules/submodules/unknown22_p0.s
 * STATUS:   behavioural
 *
 * The three routines SAS/C calls for 32-bit multiply and divide. The module
 * carries SIX labels because each routine has two names: the SAS/C internal
 * name the code generator emits a call to, and the ESQ name the program's own
 * jump tables point at. Both are at the same address in the original.
 *
 *     __CXM33 / _MATH_Mulu32     32 x 32 multiply, low 32 bits
 *     __CXD33 / _MATH_DivS32     signed 32 / 32 divide
 *     __CXD22 / _MATH_DivU32     unsigned 32 / 32 divide
 *
 * SYMBOL NAMES. SAS/C prefixes an underscore, so the C function `_CXD22` emits
 * the symbol `__CXD22` that the code generator calls. `MATH_DivU32` had NO
 * leading underscore in the assembly and was renamed to `_MATH_DivU32` with
 * `tools/rename_for_c.py`, which is byte-neutral.
 *
 * THE CALLING CONVENTION IS REGISTERS, NOT THE STACK. SAS/C emits
 * `MOVE.L a,D0 / MOVE.L b,D1 / BSR.W __CXD33` with no argument push at all, so
 * these must be `__asm` functions with `register __d0` and `register __d1`
 * parameters. A stack-argument definition compiles, links, and reads garbage.
 *
 * NEITHER BODY MAY USE `/`, `%` OR `*` ON A LONG, or it would compile into a
 * call to itself. Verified by compiling and reading the object's xref table,
 * which is EMPTY:
 *
 *   - the divide is a shift-and-subtract loop, so it needs no divide operator;
 *   - the multiply is built from 16-bit partial products, and
 *     `(unsigned long)(unsigned short)a * (unsigned short)b` emits `MULU.W`
 *     inline rather than a helper call.
 *
 * THE REMAINDER IN D1 IS GONE, AND THAT IS THE POINT. The original returns the
 * quotient in D0 *and* the sign-corrected remainder in D1, which is how SAS/C
 * implements `%`. A C function returns one value, so this file cannot preserve
 * that. Every `%` in `src/c` was rewritten as `a - (a / b) * b` first, which
 * reads only D0. `tools/d1_remainder_audit.py` proves no caller is left that
 * reads D1, and it must report ZERO before this file may be linked.
 *
 * SASC-MISMATCH: library-routine-not-reproducible
 *   ref:     a DIVU-based algorithm, 146 bytes for the unsigned divide
 *   got:     a 32-iteration shift-and-subtract loop
 *   summary: the original is SAS's own library source built by SAS's own
 *            compiler. No C fed to 6.51 reproduces it, and this file does not
 *            try. It is a functional analogue, and it is SLOWER: the original
 *            uses the 68000 DIVU instruction on 16-bit halves where this loops
 *            32 times. Correctness first -- if the divide shows up in a
 *            profile, the 16-bit DIVU path is the optimisation to add.
 *   tried:   nothing. A byte match here is not reachable, by the reasoning in
 *            AGENTS.md under "Library code is not application code".
 *   scope:   this module.
 *   retest:  not applicable.
 *
 * DIVISION BY ZERO DIFFERS. The original divides with DIVU and a zero divisor
 * therefore traps. This returns zero instead, because a shift-and-subtract loop
 * has no trap to raise and looping forever would hang the machine. No caller in
 * the program divides by a value it has not already checked.
 *
 * VALIDATED BY MODEL, not by inspection. The three algorithms were re-implemented
 * in Python and checked against exact arithmetic over 20,000 random pairs each
 * plus the boundary cases (0, 1, 0xFFFFFFFF, 0x80000000, and divisors above
 * 2^31). Unsigned divide, signed divide and multiply were all exact.
 *
 * The single divergence is `LONG_MIN / -1`, whose true quotient 2^31 is not
 * representable in a signed long. This wraps back to LONG_MIN, which is what
 * two's-complement hardware does. The 68000 DIVS traps on it instead. No caller
 * divides by a negative variable it has not bounded.
 */

/* Quotient of a / b, unsigned, with the remainder written through `rem`.
 * Shift and subtract, most significant bit first. Uses no divide operator, so
 * it cannot compile into a call to itself.
 *
 * `r << 1` CANNOT LOSE A BIT, and it is worth writing down why, because the
 * obvious worry is that it can. The invariant is `r == (a >> i) mod b`. For r to
 * carry bit 31 into the shift it would have to be 2^31 or more, which needs both
 * `b > 2^31` and `(a >> i) >= 2^31` -- and the second holds only at `i == 0`,
 * where no further shift happens. A carry guard was written first and then
 * measured: it fired ZERO times in 100,008 divisions, including adversarial
 * divisors in [2^31, 2^32). It is left out rather than kept as dead code. */
static unsigned long udivmod(unsigned long a, unsigned long b,
                             unsigned long *rem)
{
    unsigned long q;
    unsigned long r;
    short         i;

    if (b == 0) {
        *rem = 0;
        return 0;
    }

    q = 0;
    r = 0;
    for (i = 31; i >= 0; i--) {
        r = (r << 1) | ((a >> i) & 1UL);
        if (r >= b) {
            r = r - b;
            q = q | (1UL << i);
        }
    }

    *rem = r;
    return q;
}

/* ---- unsigned divide -------------------------------------------------- */

unsigned long __asm _CXD22(register __d0 unsigned long a,
                           register __d1 unsigned long b)
{
    unsigned long r;

    return udivmod(a, b, &r);
}

unsigned long __asm MATH_DivU32(register __d0 unsigned long a,
                                register __d1 unsigned long b)
{
    unsigned long r;

    return udivmod(a, b, &r);
}

/* ---- signed divide ----------------------------------------------------- */

/* Truncates toward zero, so the quotient takes the sign of a XOR the sign of b.
 * That is what the original computes with its NEG.L pairs. */
static long sdiv(long a, long b)
{
    unsigned long ua;
    unsigned long ub;
    unsigned long r;
    unsigned long q;
    short         neg;

    neg = 0;
    ua  = (unsigned long)a;
    ub  = (unsigned long)b;

    /* Negate in UNSIGNED arithmetic. `-a` on the most negative long overflows,
     * which is undefined, and the magnitude of LONG_MIN does not fit in a long
     * anyway. Two's-complement negation on the unsigned value is well defined
     * and gives the right magnitude for every input including LONG_MIN. */
    if (a < 0) {
        ua  = ~ua + 1UL;
        neg = !neg;
    }
    if (b < 0) {
        ub  = ~ub + 1UL;
        neg = !neg;
    }

    q = udivmod(ua, ub, &r);
    /* Negate through unsigned for the same reason as the operands above:
     * LONG_MIN / 1 gives a quotient of 2^31, whose negation is representable
     * but whose positive form is not. */
    return neg ? (long)(~q + 1UL) : (long)q;
}

long __asm _CXD33(register __d0 long a, register __d1 long b)
{
    return sdiv(a, b);
}

long __asm MATH_DivS32(register __d0 long a, register __d1 long b)
{
    return sdiv(a, b);
}

/* ---- multiply ---------------------------------------------------------- */

/* Low 32 bits of a * b, from three 16-bit partial products. Each product has
 * both operands narrowed to `unsigned short` first, which is what makes SAS/C
 * emit MULU.W inline instead of calling __CXM33 and recursing. */
static unsigned long umul(unsigned long a, unsigned long b)
{
    unsigned long lo;
    unsigned long mid1;
    unsigned long mid2;

    lo   = (unsigned long)(unsigned short)a * (unsigned short)b;
    mid1 = (unsigned long)(unsigned short)(a >> 16) * (unsigned short)b;
    mid2 = (unsigned long)(unsigned short)a * (unsigned short)(b >> 16);

    return lo + ((mid1 + mid2) << 16);
}

unsigned long __asm _CXM33(register __d0 unsigned long a,
                           register __d1 unsigned long b)
{
    return umul(a, b);
}

unsigned long __asm MATH_Mulu32(register __d0 unsigned long a,
                                register __d1 unsigned long b)
{
    return umul(a, b);
}
