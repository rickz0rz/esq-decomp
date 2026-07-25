/* RESTORES: _LADFUNC_GetPackedPenHighNibble
 * MODULE:   modules/groups/a/w/ladfunc.s
 * STATUS:   exact
 *
 * Extracts the high nibble of a packed pen byte.
 *
 * NOTE: must NOT be compiled with SHORTINT (unlike ED_IsConfirmKey, which
 * requires it) -- see the per-file options column in src/c/replacements.txt.
 * Introducing a named local for the widened value also breaks the match: the
 * original computes straight into D0.
 */
long LADFUNC_GetPackedPenHighNibble(unsigned char packed)
{
    return ((long)packed >> 4) & 15;
}
