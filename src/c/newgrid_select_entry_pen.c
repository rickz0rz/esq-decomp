/* RESTORES: NEWGRID_SelectEntryPen
 * MODULE:   modules/groups/b/a/newgrid1b.s
 * STATUS:   behavioural
 * OPTIONS:  OPTIMIZE
 *
 * SASC-MISMATCH: large-function-register-allocation
 *   ref:     48e72110266f00107e007e004607200b67367000102b002972004601b08167067e001e006022082b0001001b67047e046016082b0006001b67047e05600a082b0004001b67027e0770004600be806648203900006c2053806d3c0c80000000076c34d040303b00064efb00040028000c000c000c0010001800207e06601a2e390000a9c660122e390000aa06600a2e390000aa3a60027e074a876b06700fbe806f027e077000460023c00000b454220b67147200122b002ab280670a7400140123c20000b454b0b90000b4546656203900006c2053806d440c80000000076c3cd040303b00064efb00040030003000300030000c0018002423f90000a9c20000602023f90000a9fe0000601423f90000aa3200006008700123c00000b45420390000b4547201b0816d067403b0826f0623c10000b45420074cdf08844e75
 *   got:     48e72100206f000c7e00460720086732102800290c0000ff67067e001e00602208280001001b67047e04601608280006001b67047e05600a08280004001b67027e0770004600be80664820390000000053806d3c0c80000000076c34d040303b00064efb00040028000c000c000c0010001800207e06601a2e390000000060122e3900000000600a2e39000000000c407e074a876b06700fbe806f027e077000460023c000000000220867141228002a0c0100ff670a7400140123c200000000b0b900000000665620390000000053806d440c80000000076c3cd040303b00064efb00040030003000300030000c0018002423f90000000000000000602023f90000000000000000601423f900000000000000006008700123c0000000002039000000007201b0816d067403b0826f0623c10000000020074cdf00844e75
 *   summary: First attempt at a large (318-byte) function, and the result is encouraging rather than exact. With OPTIMIZE the size matches exactly at 318 bytes and 79 percent of instruction words are identical in sequence, including both PC-relative jump tables, all three BTST flag tests, the pen constants, both clamp ranges and the epilogue. Of the 30 words that do differ, 8 differ only in a register field (BTST #1,27(A3) versus 27(A0)) -- the familiar allocation divergence. The remaining ~22 are genuine: the original opens with a duplicated MOVEQ #0,D7 before NOT.B that no source form reproduced, and it keeps the 0xFF sentinel in one register where SAS/C splits it. Three source shapes were tried: a two-variable sentinel (292 bytes), explicit ~0 & 0xFF expressions (340), and a single-variable form with the switch based at case 1 (330, or 318 under OPTIMIZE). Recording the closest.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct GridEntry {
    char          pad0[27];
    unsigned char flags;        /* +27 */
    char          pad1[13];
    unsigned char pen;          /* +41 */
    unsigned char penOverride;  /* +42 */
};

extern long NEWGRID_GridOperationId;
extern long NEWGRID_OverridePenIndex;
extern long GCOMMAND_NicheFramePen, GCOMMAND_MplexDetailRowPen, GCOMMAND_PpvShowtimesRowPen;
extern long GCOMMAND_NicheTextPen, GCOMMAND_MplexDetailLayoutPen, GCOMMAND_PpvShowtimesLayoutPen;

long NEWGRID_SelectEntryPen(struct GridEntry *e)
{
    long pen = 0;
    long none = 0xFF;

    pen = none;
    if (e != 0) {
        if (e->pen != none) {
            pen = e->pen;
        } else if (e->flags & 2) {
            pen = 4;
        } else if (e->flags & 64) {
            pen = 5;
        } else if (e->flags & 16) {
            pen = 7;
        }
    }
    if (pen == none) {
        switch (NEWGRID_GridOperationId) {
        case 1: pen = 7; break;
        case 2: case 3: case 4: pen = 6; break;
        case 5: pen = GCOMMAND_NicheFramePen; break;
        case 6: pen = GCOMMAND_MplexDetailRowPen; break;
        case 7: pen = GCOMMAND_PpvShowtimesRowPen; break;
        default: pen = 7; break;
        }
    }
    if (pen < 0 || pen > 15)
        pen = 7;

    NEWGRID_OverridePenIndex = none;
    if (e != 0 && e->penOverride != none)
        NEWGRID_OverridePenIndex = e->penOverride;
    if (NEWGRID_OverridePenIndex == none) {
        switch (NEWGRID_GridOperationId) {
        case 1: case 2: case 3: case 4: NEWGRID_OverridePenIndex = 1; break;
        case 5: NEWGRID_OverridePenIndex = GCOMMAND_NicheTextPen; break;
        case 6: NEWGRID_OverridePenIndex = GCOMMAND_MplexDetailLayoutPen; break;
        case 7: NEWGRID_OverridePenIndex = GCOMMAND_PpvShowtimesLayoutPen; break;
        default: NEWGRID_OverridePenIndex = 1; break;
        }
    }
    if (NEWGRID_OverridePenIndex < 1 || NEWGRID_OverridePenIndex > 3)
        NEWGRID_OverridePenIndex = 1;
    return pen;
}
