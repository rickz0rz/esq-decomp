/* RESTORES: GCOMMAND_CopyImageDataToBitmap
 * MODULE:   modules/groups/a/u/gcommand3b_p3_p1_gcommand_copyimagedatatobitmap.s
 * STATUS:   behavioural
 *
 * Writes a COPPER LIST, 1240 bytes, and despite the name it copies nothing: it
 * lays down three blocks of copper instructions into the caller's buffer and
 * calls out twice to fill the gaps between them. There is not a single loop.
 *
 * The three blocks sit at fixed byte offsets -- 0, 672 and 3876 -- with
 * GCOMMAND_BuildBannerBlock filling 128 and 740, and GCOMMAND_BuildBannerRow
 * filling the long stretch after that. The last block is written OUT OF ORDER,
 * 3916..3938 before 3876..3914, and the order is preserved here because it is the
 * order the original emits.
 *
 * THE BUFFER IS ADDRESSED THROUGH TWO POINTERS, one `unsigned char *` and one
 * `unsigned short *`. That is the cast-and-add form AGENTS.md warns about, and it
 * is the right call here for once: a copper list is a raw byte array of 4-byte
 * instructions whose first word is EITHER a register number (a MOVE) or a packed
 * vpos/hpos pair written as two separate bytes (a WAIT). No single struct
 * describes both, and indexing `cw[41]` emits `MOVE.W ...,82(A0)` -- exactly the
 * original's displacement -- while `cb[80]` emits `MOVE.B ...,80(A0)`. A struct
 * with a union would emit the same code and read worse.
 *
 * The WAIT instructions are recognisable: 0x8e/0xd9/0xfffe at the head,
 * 0x80/0xd9/0x80fe near the end, and 0xffff/0xfffe as the terminator. The rest is
 * DIWSTRT/DIWSTOP, DDFSTRT/DDFSTOP, the BPLCONs, the colour registers 0x180-0x18e,
 * the blitter-ish 0x84/0x86/0x8a, and five bitplane pointers split high/low.
 *
 * THE ROW COUNTER IS READ AND ADVANCED FOUR TIMES, through the caller's pointer,
 * and each read lands in a WAIT's vpos byte. So the four waits are at increasing
 * scanlines and the step comes from the caller. Collapsing those reads would
 * change the list.
 *
 * MEASURED: 1244 emitted against 1240 in the original, +4 over 63 regions.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....              JSR (d16,PC)
 *   got:     61000000              BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55fffc ... 4e5d     LINK.W A5,#-4 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: NOT itemised. The body is 150 independent constant stores; a per-hunk
 *            listing would be 150 lines saying the same thing about immediate
 *            forms. Recorded as a known-unknown per AGENTS.md rule 3.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>

struct GcPlanes {
    char pad0[8];
    long plane8;                /*  8 */
    long plane12;               /* 12 */
    long plane16;               /* 16 */
};

extern long WDISP_BannerWorkRasterPtr;

extern void GCOMMAND_BuildBannerBlock(unsigned char *dst, long kind,
                                      unsigned char *counter, long limit,
                                      long y, long step);
extern void GCOMMAND_BuildBannerRow(struct GcPlanes *planes, void *dst, long a,
                                    long b, long off);

void GCOMMAND_CopyImageDataToBitmap(struct GcPlanes *planes, void *dst,
                                    long off1, long off2,
                                    unsigned char *counter, short y, char step)
{
    unsigned char  *cb;
    unsigned short *cw;

    cb = (unsigned char *)dst;
    cw = (unsigned short *)dst;

    /* --- block 1, offsets 0..126 ------------------------------------------- */
    cb[0] = 0x8e;
    cb[1] = 0xd9;
    cw[1] = 0xfffe;
    cw[2] = 0x92;
    cw[3] = 0x30;
    cw[4] = 0x94;
    cw[5] = 0xd8;
    cw[6] = 0x8e;
    cw[7] = 0x1769;
    cw[8] = 0x90;
    cw[9] = 0xffc5;
    cw[10] = 0x108;
    cw[11] = 88;
    cw[12] = 0x10a;
    cw[13] = 88;
    cw[14] = 0x100;
    cw[15] = 0x9306;
    cw[16] = 0x102;
    cw[17] = 0;
    cw[18] = 0x182;
    cw[19] = 3;
    cw[20] = 0xe0;
    cw[21] = (unsigned short)(WDISP_BannerWorkRasterPtr >> 16);
    cw[22] = 0xe2;
    cw[23] = (unsigned short)(WDISP_BannerWorkRasterPtr & 0xffff);
    cw[24] = 0x180;
    cw[25] = 3;
    cw[26] = 0x182;
    cw[27] = 3;
    cw[28] = 0x184;
    cw[29] = 0x111;
    cw[30] = 0x186;
    cw[31] = 0xcc0;
    cw[32] = 0x188;
    cw[33] = 0x512;
    cw[34] = 0x18a;
    cw[35] = 0x16a;
    cw[36] = 0x18c;
    cw[37] = 0x555;
    cw[38] = 0x18e;
    cw[39] = 3;
    cb[80] = *counter;
    *counter = *counter + step;
    cb[81] = 0xdb;
    cw[41] = y;
    cw[42] = 0xe0;
    cw[43] = (unsigned short)((planes->plane8 + off1) >> 16);
    cw[44] = 0xe2;
    cw[45] = (unsigned short)((planes->plane8 + off1) & 0xffff);
    cw[46] = 0xe4;
    cw[47] = (unsigned short)((planes->plane12 + off1) >> 16);
    cw[48] = 0xe6;
    cw[49] = (unsigned short)((planes->plane12 + off1) & 0xffff);
    cw[50] = 0xe8;
    cw[51] = (unsigned short)((planes->plane16 + off1) >> 16);
    cw[52] = 0xea;
    cw[53] = (unsigned short)((planes->plane16 + off1) & 0xffff);
    cw[54] = 0x182;
    cw[55] = 0xaaa;
    cw[56] = 0x100;
    cw[57] = 0xb306;
    cw[58] = 0x84;
    cw[59] = (unsigned short)(((long)&cb[132]) >> 16);
    cw[60] = 0x86;
    cw[61] = (unsigned short)(((long)&cb[132]) & 0xffff);
    cw[62] = 0x8a;
    cw[63] = 0;

    GCOMMAND_BuildBannerBlock(&cb[128], 17L, counter, 221L, (long)y, (long)step);

    /* --- block 2, offsets 672..738 ---------------------------------------- */
    cb[672] = *counter;
    *counter = *counter + step;
    cb[673] = 0xdb;
    cw[337] = y;
    cw[338] = 0x100;
    cw[339] = 0x9306;
    cw[340] = 0x182;
    cw[341] = 3;
    cw[342] = 0xe0;
    cw[343] = (unsigned short)(WDISP_BannerWorkRasterPtr >> 16);
    cw[344] = 0xe2;
    cw[345] = (unsigned short)(WDISP_BannerWorkRasterPtr & 0xffff);
    cw[346] = 0xe4;
    cw[347] = (unsigned short)((planes->plane12 + off2) >> 16);
    cw[348] = 0xe6;
    cw[349] = (unsigned short)((planes->plane12 + off2) & 0xffff);
    cw[350] = 0xe8;
    cw[351] = (unsigned short)((planes->plane16 + off2) >> 16);
    cw[352] = 0xea;
    cw[353] = (unsigned short)((planes->plane16 + off2) & 0xffff);
    cb[708] = *counter;
    *counter = *counter + step;
    cb[709] = 0xdb;
    cw[355] = y;
    cw[356] = 0xe0;
    cw[357] = (unsigned short)((planes->plane8 + off2) >> 16);
    cw[358] = 0xe2;
    cw[359] = (unsigned short)((planes->plane8 + off2) & 0xffff);
    cw[360] = 0x182;
    cw[361] = 0xaaa;
    cw[362] = 0x100;
    cw[363] = 0xb306;
    cw[364] = 0x84;
    cw[365] = (unsigned short)(((long)&cb[744]) >> 16);
    cw[366] = 0x86;
    cw[367] = (unsigned short)(((long)&cb[744]) & 0xffff);
    cw[368] = 0x8a;
    cw[369] = 0;

    GCOMMAND_BuildBannerBlock(&cb[740], 98L, counter, 221L, (long)y, (long)step);
    GCOMMAND_BuildBannerRow(planes, dst, 0L, 98L, off2);

    /* --- block 3: the tail is written BEFORE the body, as the original does - */
    cb[3916] = 0x80;
    cb[3917] = (unsigned char)-39;
    cw[1959] = 0x80fe;
    cw[1960] = 0x100;
    cw[1961] = 0x9306;
    cw[1962] = 0x182;
    cw[1963] = 3;
    cw[1964] = 0xe0;
    cw[1965] = (unsigned short)(WDISP_BannerWorkRasterPtr >> 16);
    cw[1966] = 0xe2;
    cw[1967] = (unsigned short)(WDISP_BannerWorkRasterPtr & 0xffff);
    cb[3936] = 0xff;
    cb[3937] = 0xff;
    cw[1969] = 0xfffe;

    cb[3876] = *counter;
    *counter = *counter + step;
    cb[3877] = (unsigned char)-39;
    cw[1939] = y;
    cw[1940] = 0xe0;
    cw[1941] = (unsigned short)((planes->plane8 + off2) >> 16);
    cw[1942] = 0xe2;
    cw[1943] = (unsigned short)((planes->plane8 + off2) & 0xffff);
    cw[1944] = 0xe4;
    cw[1945] = (unsigned short)((planes->plane12 + off2) >> 16);
    cw[1946] = 0xe6;
    cw[1947] = (unsigned short)((planes->plane12 + off2) & 0xffff);
    cw[1948] = 0xe8;
    cw[1949] = (unsigned short)((planes->plane16 + off2) >> 16);
    cw[1950] = 0xea;
    cw[1951] = (unsigned short)((planes->plane16 + off2) & 0xffff);
    cw[1952] = 0x84;
    cw[1953] = (unsigned short)(((long)&cb[744]) >> 16);
    cw[1954] = 0x86;
    cw[1955] = (unsigned short)(((long)&cb[744]) & 0xffff);
    cw[1956] = 0x8a;
    cw[1957] = 0;
}
