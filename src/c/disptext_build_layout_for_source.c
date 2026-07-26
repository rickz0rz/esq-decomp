/* RESTORES: DISPTEXT_BuildLayoutForSource
 * MODULE:   modules/groups/a/i/disptext.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: varargs-frame
 *   ref:     4e55fff848e70110266d00087e004ab900008150662a41ed00102f082f2d000c2f39000081562b48fff84eba02e62eb9000081562f0b6100fddc4fef00102e0020074cdf08804e5d4e75
 *   got:     48e701042a6f000c7e004ab9000000006624486f00142f2f00142f3900000000610000002eb9000000002f0d610000002e004fef001020074cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long  DISPTEXT_LineTableLockFlag;
extern char *Global_REF_1000_BYTES_ALLOCATED_1;
extern void  GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2(char *buf, char *fmt, void *args);
extern long  DISPTEXT_LayoutAndAppendToBuffer(void *src, char *buf);
long DISPTEXT_BuildLayoutForSource(void *src, char *fmt)
{
    long n = 0;

    if (DISPTEXT_LineTableLockFlag == 0) {
        GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2(Global_REF_1000_BYTES_ALLOCATED_1, fmt, &fmt + 1);
        n = DISPTEXT_LayoutAndAppendToBuffer(src, Global_REF_1000_BYTES_ALLOCATED_1);
    }
    return n;
}
