/* RESTORES: SCRIPT_CheckPathExists
 * MODULE:   modules/groups/b/a/script3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: os-library-call
 *   ref:     48e72310266f00147e007c00220b74fe2c790000d9304eaeffac2e004a87670822074eaeffa67c0120064cdf08c44e75
 *   got:     48e703042a6f00107c004878fffe2f0d610000002e00504f4a87670a2f0761000000584f7c0120064cdf20c04e75
 *   summary: The original calls an AmigaOS library function through an explicit base register (MOVEA.L base,A6 / JSR _LVOxxx(A6)). Reproducing that from C needs the SAS/C #pragma libcall machinery and the matching library base; without it sc emits an ordinary external call. Recorded rather than guessed at.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void *Global_REF_DOS_LIBRARY_2;
extern long Lock(char *name, long mode);
extern void UnLock(long lock);
long SCRIPT_CheckPathExists(char *path)
{
    long lk;
    long found = 0;

    lk = Lock(path, -2);
    if (lk != 0) {
        UnLock(lk);
        found = 1;
    }
    return found;
}
