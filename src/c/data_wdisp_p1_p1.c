/* RESTORES: (data module -- no function)
 * MODULE:   data/wdisp_p1_p1.s
 * STATUS:   behavioural
 *
 * HAND-WRITTEN, not produced by tools/data_to_c.py. The generator REFUSES this
 * module and is right to: it holds a build-variant block, and the generator
 * skips a conditional body rather than sizing it, so it cannot emit one safely.
 * Keeping that refusal protects the other 45 data modules. This module is four
 * lines, so it is written out instead of teaching the tool a case it has once.
 *
 * TWO NAMES FOR ONE ADDRESS. The assembly labels the same location `_DOSBase`
 * and `_Global_REF_DOS_LIBRARY_2`. C has no alias, so the first is a ZERO-LENGTH
 * array immediately before the real one -- the same device data_esq.c uses for
 * GfxBase and DiskfontBase. It emits no bytes and lands at the same address.
 *
 * THE 220 BYTES ARE NOT ALL THE LIBRARY BASE. `DS.L 55` reserves the pointer and
 * 54 longs after it, and the code reaches into that space by displacement, so it
 * has to stay one object. Splitting it into a pointer plus a separate array
 * would let C place them apart. See AGENTS.md, "Before the DATA section can move
 * to C", for the general rule.
 *
 * THE VARIANT ARM IS Ari's DEBUG INSTRUMENTATION, gated by
 * includeCustomAriAssembly in src/Prevue.asm. build-split.sh reads that equate
 * and passes DEFINE=ESQ_CUSTOM_ARI, so the C arm cannot disagree with the
 * assembly arm -- the same arrangement as ESQ_FIX_ESCMENU.
 *
 * The string is 49 characters plus a NUL, and `NStr` word-aligns after it, so
 * the array is 52 bytes. That is the 52 data bytes AGENTS.md records for the
 * variant build.
 */

#ifndef ESQ_CUSTOM_ARI
#define ESQ_CUSTOM_ARI 0
#endif

unsigned char DOSBase[0] = {
};
unsigned char Global_REF_DOS_LIBRARY_2[220] = {
    0
};

#if ESQ_CUSTOM_ARI
char WDISP_FMT_CTRLH_STATUS_MAX[52] =
    "CTRL H:%04ld Cnt:%ld CRC:%02x State:%ld Byte:%02x";
#endif
