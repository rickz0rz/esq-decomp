/* RESTORES: _GCOMMAND_RebuildBannerTablesFromBounds
 * MODULE:   modules/groups/a/u/gcommand3b_p2_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: index-rematerialisation
 *   ref:     4e55ffe848e723302b7c00002da8fffc2b7c00004168fff8206dfffc41e80080226dfff843e900802b48fff42b49fff04a790000a2dc67047000600270112c002f390000b2de2f062f390000b2ce48790000b26c6100fdaa2eb90000b2e22f062f390000b2d248790000b2846100fd922eb90000b2e62f062f390000b2d648790000b29c6100fd7a2eb90000b2ea2f062f390000b2da48790000b2b46100fd624fef00347e007011be806c0001062007eb8022390000b2744a816a0a74001439000028fc601c24390000b26cef8241f90000aa6c2248d3c2d281d3c1720032112401206dfff431820806226dfff0338208062007eb8022390000b28c4a816a0a74001439000028fd601c24390000b284ef8245f90000aa6c264ad7c2d281d7c17200321324013182080a3382080a2007eb8022390000b2a44a816a0a74001439000028fe601c24390000b29cef8245f90000aa6c264ad7c2d281d7c17200321324013182080e3382080e2007eb8022390000b2bc4a816a0a74001439000028ff601a24390000b2b4ef8241f90000aa6cd1c2d281d1c1720032102401206dfff431820812338208126100fd3452876000fef64279000068aa4cdf0cc44e5d4e75
 *   got:     514f48e707364bf90000000047f90000000045ed008041eb00803039000000002f4800204a4067047e0060027e112f39000000002f072f3900000000487900000000610000002eb9000000002f072f3900000000487900000000610000002eb9000000002f072f3900000000487900000000610000002eb9000000002f072f3900000000487900000000610000004fef00347c007011bc806c0001542a06eb852039000000004a806a0e72001239000000002f41001c601e223900000000ef8141f9000000002248d3c1d080d3c0700030112f40001c204ad1c543e80006202f001c3280206f00202248d3c54de900063c802a06eb852039000000004a806a0e72001239000000002f41001c601e223900000000ef8143f9000000002c49ddc1d080ddc0700030162f40001c224ad3c54de9000a202f001c3c802248d3c54de9000a3c802a06eb852039000000004a806a0e72001239000000002f41001c601e223900000000ef8143f9000000002c49ddc1d080ddc0700030162f40001c224ad3c54de9000e202f001c3c802248d3c54de9000e3c802a06eb852039000000004a806a0e72001239000000002f41001c601c223900000000ef8143f900000000d3c1d080d3c0700030112f40001c224ad3c54de90012202f001c3c80d1c543e8001232806100000052866000fea84279000000004cdf6ce0504f4e75
 *   summary: 508 got vs 448 ref. The original recomputes the row offset with MOVE.L D7,D0 / ASL.L #5 before each of the four entry groups and keeps both copper-list row bases in A5 frame slots; 6.51 reloads the bases from A7 per store, which costs four bytes at each of the eight word writes. Writing the preset lookup as byte arithmetic -- table + (entry << 7) + (index << 1), the original's exact form -- was worth 16 bytes against an ordinary short subscript. The busy-flag seed choice between 0 and 17, all four InitPresetWorkEntry calls with their bound and step pairs, the four negative-index fallbacks and the per-row tick match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char ESQ_CopperListBannerA[];
extern char ESQ_CopperListBannerB[];
extern short Global_UIBusyFlag;
extern short GCOMMAND_BannerRebuildPendingFlag;
extern unsigned short GCOMMAND_PresetValueTable[];

extern long GCOMMAND_PresetWorkEntryTable;
extern long GCOMMAND_PresetWorkEntry0_ValueIndex;
extern long GCOMMAND_PresetWorkEntry1;
extern long GCOMMAND_PresetWorkEntry1_ValueIndex;
extern long GCOMMAND_PresetWorkEntry2;
extern long GCOMMAND_PresetWorkEntry2_ValueIndex;
extern long GCOMMAND_PresetWorkEntry3;
extern long GCOMMAND_PresetWorkEntry3_ValueIndex;

extern long GCOMMAND_BannerBoundLeft, GCOMMAND_BannerStepLeft;
extern long GCOMMAND_BannerBoundTop, GCOMMAND_BannerStepTop;
extern long GCOMMAND_BannerBoundRight, GCOMMAND_BannerStepRight;
extern long GCOMMAND_BannerBoundBottom, GCOMMAND_BannerStepBottom;

extern unsigned char GCOMMAND_PresetFallbackValue0;
extern unsigned char GCOMMAND_PresetFallbackValue1;
extern unsigned char GCOMMAND_PresetFallbackValue2;
extern unsigned char GCOMMAND_PresetFallbackValue3;

extern void GCOMMAND_InitPresetWorkEntry(long *entry, long bound, long seed,
                                         long step);
extern void GCOMMAND_TickPresetWorkEntries(void);

void GCOMMAND_RebuildBannerTablesFromBounds(void)
{
    char *listA;
    char *listB;
    char *rowA;
    char *rowB;
    long  seed;
    long  row;
    long  off;
    long  value;

    listA = ESQ_CopperListBannerA;
    listB = ESQ_CopperListBannerB;
    rowA = listA + 0x80;
    rowB = listB + 0x80;

    if (Global_UIBusyFlag != 0)
        seed = 0;
    else
        seed = 17;

    GCOMMAND_InitPresetWorkEntry(&GCOMMAND_PresetWorkEntryTable,
        GCOMMAND_BannerBoundLeft, seed, GCOMMAND_BannerStepLeft);
    GCOMMAND_InitPresetWorkEntry(&GCOMMAND_PresetWorkEntry1,
        GCOMMAND_BannerBoundTop, seed, GCOMMAND_BannerStepTop);
    GCOMMAND_InitPresetWorkEntry(&GCOMMAND_PresetWorkEntry2,
        GCOMMAND_BannerBoundRight, seed, GCOMMAND_BannerStepRight);
    GCOMMAND_InitPresetWorkEntry(&GCOMMAND_PresetWorkEntry3,
        GCOMMAND_BannerBoundBottom, seed, GCOMMAND_BannerStepBottom);

    row = 0;
    while (row < 17) {
        off = row << 5;
        if (GCOMMAND_PresetWorkEntry0_ValueIndex < 0)
            value = GCOMMAND_PresetFallbackValue0;
        else
            value = *(unsigned short *)((char *)GCOMMAND_PresetValueTable
                        + (GCOMMAND_PresetWorkEntryTable << 7) + (GCOMMAND_PresetWorkEntry0_ValueIndex << 1));
        *(short *)(rowA + off + 6) = value;
        *(short *)(rowB + off + 6) = value;

        off = row << 5;
        if (GCOMMAND_PresetWorkEntry1_ValueIndex < 0)
            value = GCOMMAND_PresetFallbackValue1;
        else
            value = *(unsigned short *)((char *)GCOMMAND_PresetValueTable
                        + (GCOMMAND_PresetWorkEntry1 << 7) + (GCOMMAND_PresetWorkEntry1_ValueIndex << 1));
        *(short *)(rowA + off + 10) = value;
        *(short *)(rowB + off + 10) = value;

        off = row << 5;
        if (GCOMMAND_PresetWorkEntry2_ValueIndex < 0)
            value = GCOMMAND_PresetFallbackValue2;
        else
            value = *(unsigned short *)((char *)GCOMMAND_PresetValueTable
                        + (GCOMMAND_PresetWorkEntry2 << 7) + (GCOMMAND_PresetWorkEntry2_ValueIndex << 1));
        *(short *)(rowA + off + 14) = value;
        *(short *)(rowB + off + 14) = value;

        off = row << 5;
        if (GCOMMAND_PresetWorkEntry3_ValueIndex < 0)
            value = GCOMMAND_PresetFallbackValue3;
        else
            value = *(unsigned short *)((char *)GCOMMAND_PresetValueTable
                        + (GCOMMAND_PresetWorkEntry3 << 7) + (GCOMMAND_PresetWorkEntry3_ValueIndex << 1));
        *(short *)(rowA + off + 18) = value;
        *(short *)(rowB + off + 18) = value;

        GCOMMAND_TickPresetWorkEntries();
        row++;
    }

    GCOMMAND_BannerRebuildPendingFlag = 0;
}
