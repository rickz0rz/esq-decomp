/* RESTORES: ED_EnterTextEditMode
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     13fc000400001cd84eba36cc4eba35044eba30fc41f900008460d1f900008180700010102f004eba3210584f4e75
 *   got:     13fc00040000000061000000610000006100000041f900000000d1f9000000001010720012002f0161000000584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char ED_MenuStateId;
extern char ED_EditBufferLive[];
extern long ED_EditCursorOffset;
extern void ED_DrawAdEditingScreen(void);
extern void ED_RedrawAllRows(void);
extern void ED_RedrawCursorChar(void);
extern void ED_DrawCurrentColorIndicator(long colour);
void ED_EnterTextEditMode(void)
{
    ED_MenuStateId = 4;
    ED_DrawAdEditingScreen();
    ED_RedrawAllRows();
    ED_RedrawCursorChar();
    ED_DrawCurrentColorIndicator((long)(unsigned char)ED_EditBufferLive[ED_EditCursorOffset]);
}
