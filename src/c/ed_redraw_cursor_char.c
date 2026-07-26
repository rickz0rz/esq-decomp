/* RESTORES: ED_RedrawCursorChar
 * MODULE:   modules/groups/a/l/ed3bb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: os-library-call
 *   ref:     22790000870270052c79000028584eaefe9e6100001622790000870270012c79000028584eaefe9e4e75
 *   got:     487800052f39000000006100000061000000487800012f3900000000610000004fef00104e75
 *   summary: The original calls an AmigaOS library function through an explicit base register (MOVEA.L base,A6 / JSR _LVOxxx(A6)). Reproducing that from C requires SAS/C #pragma libcall and the matching library base; plain extern calls cannot match.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void *Global_REF_RASTPORT_1;
extern void SetDrMd(void *rp, long mode);
extern void ED_DrawCursorChar(void);
void ED_RedrawCursorChar(void)
{
    SetDrMd(Global_REF_RASTPORT_1, 5);
    ED_DrawCursorChar();
    SetDrMd(Global_REF_RASTPORT_1, 1);
}
