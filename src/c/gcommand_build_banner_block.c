/* RESTORES: _GCOMMAND_BuildBannerBlock
 * MODULE:   modules/groups/a/u/gcommand3b_p3_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-and-cursor-reload
 *   ref:     4e55fff448e70f32266d00082e2d000c246d00101c2d00173a2d001a182d001f2b4bfffc4a790000a2dc67047000600220072f0042a72b40fff46100f3ae2e802f2dfff442a748790000b26c6100f49e2eadfff4487800056100f3902e802f2dfff44878000548790000b2846100f47e2eadfff4487800066100f3702e802f2dfff44878000648790000b29c6100f45e2eadfff4487800076100f3502e802f2dfff44878000748790000b2b46100f43e4fef004442adfff8202dfff8b0876c00013c1012206dfffc1080d9121146000131450002317c0188000420390000b2744a806a0a72001239000028fc601c22390000b26cef8143f90000aa6c2c49ddc1d080ddc070003016220031410006317c018a000820390000b28c4a806a0a72001239000028fd601c22390000b284ef8143f90000aa6c2c49ddc1d080ddc07000301622003141000a317c018c000c20390000b2a44a806a0a72001239000028fe601c22390000b29cef8143f90000aa6c2c49ddc1d080ddc07000301622003141000e317c018e001020390000b2bc4a806a0a72001239000028ff601a22390000b2b4ef8143f90000aa6cd3c1d080d3c070003011220031410012317c0084001443e8002020094240484031400016317c00860018200902800000ffff3140001a317c008a001c4268001e6100f3de52adfff87020d1adfffc6000febe202dfffc4cdf4cf04e5d4e75
 *   got:     9efc000c48e727343a2f003e1c2f003b2e2f0030266f00342a6f002c244d303900000000670642af0024600620072f4000242f2f002442a7610000002e802f2f002c42a7487900000000610000002eaf003848780005610000002e802f2f003c48780005487900000000610000002eaf004848780006610000002e802f2f004c48780006487900000000610000002eaf005848780007610000002e802f2f005c48780007487900000000610000004fef004442af0020202f0020b0876c00018210131480102f0043d11310061540000141ea0002308541ea000430bc01882239000000004a816a0e74001439000000002f42001c601e243900000000ef8241f9000000002248d3c2d281d3c1720032112f41001c41ea0006222f001c308141ea000830bc018a2239000000004a816a0e74001439000000002f42001c601e243900000000ef8241f9000000002248d3c2d281d3c1720032112f41001c41ea000a222f001c308141ea000c30bc018c2239000000004a816a0e74001439000000002f42001c601e243900000000ef8241f9000000002248d3c2d281d3c1720032112f41001c41ea000e222f001c308141ea001030bc018e2239000000004a816a0e74001439000000002f42001c601c243900000000ef8241f900000000d1c2d281d1c1720032102f41001c41ea0012222f001c308141ea001430bc008441ea001643ea00202209484148c1308141ea001830bc008641ea001a2209484142414841308141ea001c30bc008a41ea001e425061000000d4fc002052af00206000fe784cdf2ce4defc000c4e754e71
 *   summary: 588 got vs 520 ref. The original keeps the write cursor and the span in A5 frame slots and reloads MOVEA.L -4(A5),A0 once per row, then reaches all sixteen copper words through (d16,A0); 6.51 reloads the cursor from A7 more often inside the row body. The preset lookup is written as byte arithmetic -- table + (entry << 7) + (index << 1) -- which is the original's exact form. The busy-flag span choice, all four increment-and-init pairs with their distinct index arguments, the seed byte advanced by the step, the four register/value word pairs with their 0x188 to 0x18e registers, the self-referential BPLPT split into 0x84 and 0x86 halves and the per-row tick match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short Global_UIBusyFlag;
extern unsigned short GCOMMAND_PresetValueTable[];
extern long GCOMMAND_PresetWorkEntryTable;
extern long GCOMMAND_PresetWorkEntry0_ValueIndex;
extern long GCOMMAND_PresetWorkEntry1;
extern long GCOMMAND_PresetWorkEntry1_ValueIndex;
extern long GCOMMAND_PresetWorkEntry2;
extern long GCOMMAND_PresetWorkEntry2_ValueIndex;
extern long GCOMMAND_PresetWorkEntry3;
extern long GCOMMAND_PresetWorkEntry3_ValueIndex;
extern unsigned char GCOMMAND_PresetFallbackValue0;
extern unsigned char GCOMMAND_PresetFallbackValue1;
extern unsigned char GCOMMAND_PresetFallbackValue2;
extern unsigned char GCOMMAND_PresetFallbackValue3;

extern long GCOMMAND_ComputePresetIncrement(long index, long span);
extern void GCOMMAND_InitPresetWorkEntry(long *entry, long bound, long seed,
                                         long step);
extern void GCOMMAND_TickPresetWorkEntries(void);

void GCOMMAND_BuildBannerBlock(char *block, long count, unsigned char *seed,
                               unsigned char kind, short colour,
                               unsigned char step)
{
    char *cursor;
    long  span;
    long  row;
    long  value;

    cursor = block;

    if (Global_UIBusyFlag != 0)
        span = 0;
    else
        span = count;

    GCOMMAND_InitPresetWorkEntry(&GCOMMAND_PresetWorkEntryTable, 0, span,
        GCOMMAND_ComputePresetIncrement(0, span));
    GCOMMAND_InitPresetWorkEntry(&GCOMMAND_PresetWorkEntry1, 5, span,
        GCOMMAND_ComputePresetIncrement(5, span));
    GCOMMAND_InitPresetWorkEntry(&GCOMMAND_PresetWorkEntry2, 6, span,
        GCOMMAND_ComputePresetIncrement(6, span));
    GCOMMAND_InitPresetWorkEntry(&GCOMMAND_PresetWorkEntry3, 7, span,
        GCOMMAND_ComputePresetIncrement(7, span));

    row = 0;
    while (row < count) {
        cursor[0] = *seed;
        *seed = *seed + step;
        cursor[1] = kind;
        *(short *)(cursor + 2) = colour;

        *(short *)(cursor + 4) = 0x188;
        if (GCOMMAND_PresetWorkEntry0_ValueIndex < 0)
            value = GCOMMAND_PresetFallbackValue0;
        else
            value = *(unsigned short *)((char *)GCOMMAND_PresetValueTable
                        + (GCOMMAND_PresetWorkEntryTable << 7)
                        + (GCOMMAND_PresetWorkEntry0_ValueIndex << 1));
        *(short *)(cursor + 6) = value;

        *(short *)(cursor + 8) = 0x18a;
        if (GCOMMAND_PresetWorkEntry1_ValueIndex < 0)
            value = GCOMMAND_PresetFallbackValue1;
        else
            value = *(unsigned short *)((char *)GCOMMAND_PresetValueTable
                        + (GCOMMAND_PresetWorkEntry1 << 7)
                        + (GCOMMAND_PresetWorkEntry1_ValueIndex << 1));
        *(short *)(cursor + 10) = value;

        *(short *)(cursor + 12) = 0x18c;
        if (GCOMMAND_PresetWorkEntry2_ValueIndex < 0)
            value = GCOMMAND_PresetFallbackValue2;
        else
            value = *(unsigned short *)((char *)GCOMMAND_PresetValueTable
                        + (GCOMMAND_PresetWorkEntry2 << 7)
                        + (GCOMMAND_PresetWorkEntry2_ValueIndex << 1));
        *(short *)(cursor + 14) = value;

        *(short *)(cursor + 16) = 0x18e;
        if (GCOMMAND_PresetWorkEntry3_ValueIndex < 0)
            value = GCOMMAND_PresetFallbackValue3;
        else
            value = *(unsigned short *)((char *)GCOMMAND_PresetValueTable
                        + (GCOMMAND_PresetWorkEntry3 << 7)
                        + (GCOMMAND_PresetWorkEntry3_ValueIndex << 1));
        *(short *)(cursor + 18) = value;

        *(short *)(cursor + 20) = 0x84;
        *(short *)(cursor + 22) = (short)(((long)(cursor + 32)) >> 16);
        *(short *)(cursor + 24) = 0x86;
        *(short *)(cursor + 26) = (short)(((long)(cursor + 32)) & 0xffff);
        *(short *)(cursor + 28) = 0x8a;
        *(short *)(cursor + 30) = 0;

        GCOMMAND_TickPresetWorkEntries();

        cursor += 32;
        row++;
    }
}
