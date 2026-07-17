#include <exec/types.h>

LONG __stdargs TESTFN(WORD value)
{
    /* Original: TST.W; SEQ D0 ($FF if zero); NEG.B D0 ($FF -> $01); EXT -> +1.
       Returns 1 for zero, 0 otherwise (NOT the -1/0 booleanize idiom). Verified
       by vamos differential harness (run_leaf_audit.sh). */
    if (value == 0) {
        return 1;
    }
    return 0;
}
