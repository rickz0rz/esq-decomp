/* RESTORES: ESQ_TerminateAfterSecondQuote
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: scratch-register-locals
 *   ref:     206f00042f027000320074221218670eb20266f812186706b20266f81080241f4e75
 *   got:     48e701042a6f000c1e1d4a0767067022be0066f41e1d4a0767087022be0066f442154cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
void ESQ_TerminateAfterSecondQuote(char *p)
{
    char c;

    while ((c = *p++) != 0)
        if (c == '"')
            break;
    while ((c = *p++) != 0)
        if (c == '"') {
            *p = 0;
            break;
        }
}
