/* RESTORES: ESQSHARED4_LoadBannerPaletteFromPreset
 * MODULE:   modules/groups/a/q/esqshared4_p5.s   (1 of its 10 blocks)
 * STATUS:   behavioural
 *
 * Loads the eight banner palette words for both copper lists from the preset
 * nibble table, starting at slot 0.
 *
 * THE BLOCK CARRIED NO LABEL UNTIL 2026-08-04. It sits at the very top of the
 * module, and the module before it in src/Prevue.asm is a bare RTS, so nothing
 * can reach it by fall-through either. Adding the label is byte-neutral and
 * test-hash.sh confirms it. The name is OURS, chosen from what the block does.
 *
 * IT IS DEAD, and so is what it calls.
 * ESQSHARED4_LoadCopperColorWordsFromNibbleTable is documented as dead in
 * esqshared4_blit_banner_rows.c, which notes that its only caller is this
 * block. Both are restored so the pair stays correct rather than merely
 * unexecuted.
 *
 * SASC-MISMATCH: register-argument-convention
 *   summary: the callee takes its four arguments in D3, A1, A2 and A3, which
 *            the __asm prototype in esqshared4_blit_banner_rows.c already
 *            declares. SAS/C loads those registers at the call site rather
 *            than leaving them where a preceding LEA put them, which costs a
 *            few bytes and no behaviour.
 *   scope:   every `__asm` register call site.
 *   retest:  a compiler that tracks values already in the argument registers.
 */
extern unsigned char GCOMMAND_PresetFallbackValue0;
extern unsigned char ESQ_BannerPaletteWordsA[];
extern unsigned char ESQ_BannerPaletteWordsB[];

extern void __asm ESQSHARED4_LoadCopperColorWordsFromNibbleTable(
        register __d3 short slot,
        register __a1 unsigned char *nibbles,
        register __a2 unsigned char *listA,
        register __a3 unsigned char *listB);

void ESQSHARED4_LoadBannerPaletteFromPreset(void)
{
    ESQSHARED4_LoadCopperColorWordsFromNibbleTable(
        0, &GCOMMAND_PresetFallbackValue0,
        ESQ_BannerPaletteWordsA, ESQ_BannerPaletteWordsB);
}
