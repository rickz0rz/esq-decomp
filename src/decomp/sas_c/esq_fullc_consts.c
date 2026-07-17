/* Constants the original defines as local DC.B tables inside code, which the
   restorations reference `extern`. Provided here for the whole-program link.
   Values taken verbatim from the original ASM. */

/* unknown10.s: kHexDigitTable: DC.B "0123456789abcdef"  (lowercase, 16 bytes) */
const char kHexDigitTable[16] = "0123456789abcdef";
