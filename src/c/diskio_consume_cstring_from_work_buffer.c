/* RESTORES: DISKIO_ConsumeCStringFromWorkBuffer
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fffc2b7900008004fffc20390000800053b9000080004a806f12207900008004101823c8000080044a0066de2039000080004a806a08307cffff2b48fffc202dfffc4e5d4e75
 *   got:     48e701042a790000000020390000000053b9000000004a806f1620790000000052b9000000001e10488748c74a8766da2039000000004a806a062a7c0000ffff200d4cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;
char *DISKIO_ConsumeCStringFromWorkBuffer(void)
{
    char *start = Global_PTR_WORK_BUFFER;
    long  c;

    do {
        if (Global_REF_LONG_FILE_SCRATCH-- <= 0)
            break;
        c = *Global_PTR_WORK_BUFFER++;
    } while (c != 0);
    if (Global_REF_LONG_FILE_SCRATCH < 0)
        start = (char *)-1;
    return start;
}
