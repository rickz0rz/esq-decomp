/* RESTORES: ED_IsConfirmKey
 * MODULE:   modules/groups/a/l/ed3.s
 * STATUS:   exact
 * OPTIONS:  SHORTINT
 *
 * True (0) when the last key was one of the two confirm codes. Keyboard path.
 *
 * NOTE: requires SHORTINT. The original compares with SUBI.W, which only
 * happens when `int` is 16 bits; with 32-bit int SAS/C emits MOVEQ + SUB.L and
 * the function grows. This is per-file: LADFUNC_GetPackedPenHighNibble breaks
 * under SHORTINT. SAS/C reads a per-directory SCOPTIONS, so the original
 * translation units need not have shared settings.
 */
extern unsigned char ED_LastKeyCode;

long ED_IsConfirmKey(void)
{
    long result;

    switch (ED_LastKeyCode) {
    case 0x59:
    case 0x79:  result = 0; break;
    default:    result = 1; break;
    }
    return result;
}
