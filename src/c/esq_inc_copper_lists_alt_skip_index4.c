/* RESTORES: ESQ_IncCopperListsAltSkipIndex4
 * MODULE:   modules/groups/a/a/app2_p4.s
 * STATUS:   behavioural
 * DO-NOT-LINK: _ESQ_BumpColorTowardTargets clobbers D2 and D3 and does not
 *   restore them. SAS/C treats both as callee-saved, so it neither keeps a
 *   value there across the call nor saves them in the prologue, and they leak
 *   out to whoever called this function. The original's MOVEM.L D2-D5/A2-A3
 *   covers exactly that: it saves D2 and D3, which its own body never touches.
 *
 * THE HELPER ALSO TAKES A POINTER IN A1 AND ADVANCES IT BY 3 PER CALL, and
 * this caller never sets A1. It runs on whatever the entry left there. That is
 * harmless only because the block is dead code: nothing calls it. The C below
 * declares the helper with a D0 argument alone, so SAS/C leaves A1 untouched
 * and the emitted call behaves the same way -- but that holds only while the
 * allocator has no reason to use A1, which is not a guarantee. The live
 * sibling esq_inc_copper_lists_towards_targets.c sets A1 and threads it
 * explicitly.
 *
 * This block carried no label until 2026-07-30, which made the preceding
 * 2-byte ESQ_NoOp_0074 read as 58 bytes.
 *
 * Byte accounting is the same four classes as
 * esq_dec_copper_lists_alt_skip_index4.c; see that file for the write-ups.
 */
extern char ESQ_BannerPaletteWordsA[];
extern char ESQ_BannerPaletteWordsB[];

/* Register-argument helper: the colour arrives in D0 and comes back in D0.
 * It also destroys D1, D2 and D3, and reads a target stream through A1 --
 * see DO-NOT-LINK above. */
unsigned short __asm ESQ_BumpColorTowardTargets(register __d0 unsigned short c);

void ESQ_IncCopperListsAltSkipIndex4(void)
{
    char *a = ESQ_BannerPaletteWordsA;
    char *b = ESQ_BannerPaletteWordsB;
    short off = 0;
    short k = 8;

    do {
        if (off != 4)
            *(unsigned short *)(b + off) = *(unsigned short *)(a + off) =
                ESQ_BumpColorTowardTargets(*(unsigned short *)(a + off));
        off += 4;
    } while (--k);
}
