/* RESTORES: SCRIPT_CheckPathExists
 * MODULE:   modules/groups/b/a/script3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     48e72310266f00147e007c00220b74fe2c790000d9304eaeffac2e004a87670822074eaeffa67c0120064cdf08c44e75
 *   got:     48e723062a6f00187c00220d2c790000000074fe4eaeffac2e004a87670822074eaeffa67c0120064cdf60c44e75
 *   summary: The OS call itself now matches exactly -- SAS/C's #pragma libcall emits the same MOVEA.L base,A6 / JSR _LVOxxx(A6) the original uses, with identical LVO offsets. The remaining gap is A6 handling: SAS/C treats A6 as callee-saved and adds it to the MOVEM save/restore masks (48e73002 / 4cdf400c) where the original treats A6 as scratch and does not save it (48e73000 / 4cdf000c), and it orders the base load before the argument setup. Not an option: CONSTLIBBASE, NOCONSTLIBBASE, SAVEDS and NOSAVEDS all leave it. This is now a single narrow code-generator difference rather than an unknown, and it affects every OS-calling function in the program.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-dos.h"
long SCRIPT_CheckPathExists(char *path)
{
    BPTR lk;
    long found = 0;

    lk = Lock(path, -2);
    if (lk != 0) {
        UnLock(lk);
        found = 1;
    }
    return found;
}
