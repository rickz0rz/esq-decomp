/* RESTORES: ESQIFF_DeallocateAdsAndLogoLstData
 * MODULE:   modules/groups/a/n/esqiff.s
 * STATUS:   behavioural
 *
 * Releases the two IFF asset blobs -- the ads data and the logo list -- each
 * guarded by both its pointer and its recorded file size being non-zero, and
 * each freed at size+1 (the loaders allocate one extra byte for a terminator).
 * The pointer and the size are cleared together, inside the guard.
 *
 * 126 bytes in the original against 118 emitted (cdiff reports 120, the last two
 * being alignment padding). The whole delta is attributed: 4 bytes per block,
 * twice, from the one divergence below. The instruction sequence is otherwise
 * identical, including the guard order, the size+1, and the paired clears.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     4ab900005ae0 ... 2f3900005ae0   TST.L Ads_DATA ... later
 *                                            MOVE.L Ads_DATA,-(A7)   (6+6)
 *   got:     203900000000 ... 2f00           MOVE.L Ads_DATA,D0 ... later
 *                                            MOVE.L D0,-(A7)         (6+2)
 *   summary: the original tests the global and then re-reads it when the value is
 *            wanted; SAS/C keeps the loaded value in a register and pushes that.
 *            Costs 4 bytes per site, 2 sites here.
 *   tried:   nothing. `volatile` would force the reload, but that is distorting
 *            the source to manufacture a match rather than recording a codegen
 *            difference -- see the prime directive in AGENTS.md. The original's
 *            source almost certainly had no volatile; its compiler simply did not
 *            keep the value live.
 *   scope:   a recurring class. The same reload-vs-cache choice is the sole
 *            non-call divergence in ladfunc_free_banner_rect_entries.c, where the
 *            original re-reads a struct field to subtract it and SAS/C caches it
 *            in D0. There it happens to cost nothing.
 *   retest:  a compiler that does not keep a tested global live in a register.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba018a / 4eba014c    JSR (d16,PC), 2 sites
 *   got:     61000000               BSR.W
 *   summary: the standard call-encoding class. Both 4 bytes.
 */
extern void  ESQIFF_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                   void *ptr, long size);
extern void *Global_REF_LONG_GFX_G_ADS_DATA;
extern long  Global_REF_LONG_GFX_G_ADS_FILESIZE;
extern void *Global_REF_LONG_DF0_LOGO_LST_DATA;
extern long  Global_REF_LONG_DF0_LOGO_LST_FILESIZE;
extern char  Global_STR_ESQIFF_C_7[];
extern char  Global_STR_ESQIFF_C_8[];

void ESQIFF_DeallocateAdsAndLogoLstData(void)
{
    if (Global_REF_LONG_GFX_G_ADS_DATA && Global_REF_LONG_GFX_G_ADS_FILESIZE) {
        ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQIFF_C_7, 1988,
                                              Global_REF_LONG_GFX_G_ADS_DATA,
                                              Global_REF_LONG_GFX_G_ADS_FILESIZE + 1);
        Global_REF_LONG_GFX_G_ADS_DATA = 0;
        Global_REF_LONG_GFX_G_ADS_FILESIZE = 0;
    }

    if (Global_REF_LONG_DF0_LOGO_LST_DATA && Global_REF_LONG_DF0_LOGO_LST_FILESIZE) {
        ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQIFF_C_8, 1994,
                                              Global_REF_LONG_DF0_LOGO_LST_DATA,
                                              Global_REF_LONG_DF0_LOGO_LST_FILESIZE + 1);
        Global_REF_LONG_DF0_LOGO_LST_DATA = 0;
        Global_REF_LONG_DF0_LOGO_LST_FILESIZE = 0;
    }
}
