/* RESTORES: _ESQIFF_RestoreBasePaletteTriples
 * MODULE:   modules/groups/a/n/esqiff.s
 * STATUS:   exact
 *
 * Copies the 24-byte base palette back over the live palette triples.
 * Display path: a fault here changes on-screen colours.
 *
 * NOTE: the loop counter must be `short`. The original compares with CMP.W and
 * indexes with ADDA.W; a `long` counter widens both and the bytes diverge.
 */
extern char WDISP_PaletteTriplesRBase[];
extern char ESQFUNC_BasePaletteRgbTriples[];

void ESQIFF_RestoreBasePaletteTriples(void)
{
    short i;

    for (i = 0; i < 24; i++)
        WDISP_PaletteTriplesRBase[i] = ESQFUNC_BasePaletteRgbTriples[i];
}
