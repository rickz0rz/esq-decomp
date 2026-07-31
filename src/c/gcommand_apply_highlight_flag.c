/* RESTORES: _GCOMMAND_ApplyHighlightFlag
 * MODULE:   modules/groups/a/u/gcommand3_p1_gcommand_applyhighlightflag.s
 * STATUS:   behavioural
 *
 * Writes the highlight bit into every copper instruction that carries it. That
 * is two words in the row templates and five words in each of the two banner
 * lists. The bit is 2, and the code clears it first. One pass therefore either
 * sets or clears it.
 *
 * The word indices are the copper DATA words of the patched instructions, which
 * is why they are irregular (15, 57, 339, 363, 1961). The original writes them
 * as byte offsets 30, 114, 678, 726 and 3922.
 *
 * The code loads the banner pointer ONCE per list, and the five patches reuse
 * it. The original does the same. It reloads only when it moves to the second
 * list.
 *
 * NEEDS SHORTINT, and the flag local must be `short`. Without both, the
 * read-modify-write widens to 32 bits, and the function costs 240 bytes instead
 * of 216. A `long bit` alone forces an EXT.L plus an OR.L at each of the twelve
 * patch sites.
 *
 * 216 bytes against 220, and tools/casm.py accounts for every byte. The two
 * divergences below very nearly cancel: +24 from the constant idiom, -24 from
 * the pointer idiom, -4 from the prologue.
 *
 * SASC-MISMATCH: moveq-vs-movew-constant
 *   ref:     70fd       MOVEQ #-3,D0     (2 bytes, then AND.W mem,D0)
 *   got:     303cfffd   MOVE.W #-3,D0    (4 bytes)
 *   summary: the original loads the mask as a long with MOVEQ, then applies it
 *            with a WORD and. That is safe, because only the low word is read
 *            back. 6.51 will not mix the widths that way. It pays two bytes at
 *            each of the twelve sites.
 *   tried:   SHORTINT and a `long` mask constant. The long mask reaches MOVEQ,
 *            but it then widens the AND to ANDI.L, which is worse.
 *   scope:   twelve sites here. The idiom appears wherever the original masks a
 *            word with a small negative constant.
 *   retest:  a compiler that narrows the AND without narrowing the load.
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     2b7c00002cdcfffc / 206dfffc   MOVE.L #addr,-4(A5) then MOVEA.L
 *   got:     4bf900000000                  LEA addr,A5
 *   summary: the original stores each list address into a frame slot and reads
 *            it back, which costs 12 bytes. 6.51 takes the address straight into
 *            a register, which costs 6. There are four sites, so this is where
 *            the 24 bytes come back. Same class as
 *            gcommand_find_path_separator.c.
 *   tried:   nothing source-side.
 *   scope:   program-wide. See gcommand_find_path_separator.c.
 *   retest:  tools/mismatches.py --recheck on a compiler that spills the local.
 */
extern short GCOMMAND_HighlightFlag;
extern short ESQ_CopperEffectTemplateRowsSet0[];
extern short ESQ_CopperEffectTemplateRowsSet1[];
extern short ESQ_CopperListBannerA[];
extern short ESQ_CopperListBannerB[];

#define HIGHLIGHT_BIT 2

void GCOMMAND_ApplyHighlightFlag(void)
{
    short  bit;
    short *tmpl;
    short *banner;

    if (GCOMMAND_HighlightFlag)
        bit = HIGHLIGHT_BIT;
    else
        bit = 0;

    tmpl = ESQ_CopperEffectTemplateRowsSet0;
    tmpl[13] = (tmpl[13] & ~HIGHLIGHT_BIT) | bit;
    tmpl = ESQ_CopperEffectTemplateRowsSet1;
    tmpl[13] = (tmpl[13] & ~HIGHLIGHT_BIT) | bit;

    banner = ESQ_CopperListBannerA;
    banner[15]   = (banner[15]   & ~HIGHLIGHT_BIT) | bit;
    banner[57]   = (banner[57]   & ~HIGHLIGHT_BIT) | bit;
    banner[339]  = (banner[339]  & ~HIGHLIGHT_BIT) | bit;
    banner[363]  = (banner[363]  & ~HIGHLIGHT_BIT) | bit;
    banner[1961] = (banner[1961] & ~HIGHLIGHT_BIT) | bit;

    banner = ESQ_CopperListBannerB;
    banner[15]   = (banner[15]   & ~HIGHLIGHT_BIT) | bit;
    banner[57]   = (banner[57]   & ~HIGHLIGHT_BIT) | bit;
    banner[339]  = (banner[339]  & ~HIGHLIGHT_BIT) | bit;
    banner[363]  = (banner[363]  & ~HIGHLIGHT_BIT) | bit;
    banner[1961] = (banner[1961] & ~HIGHLIGHT_BIT) | bit;
}
