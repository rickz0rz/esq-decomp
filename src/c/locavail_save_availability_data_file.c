/* RESTORES: _LOCAVAIL_SaveAvailabilityDataFile
 * MODULE:   modules/groups/a/y/locavail_p3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-and-record-reload
 *   ref:     4e55ff6048e70f32266d0008246d000c7a0141f900006b3043edff66700512d851c8fffc487803ee487900006b364eba088e504f28004a84670001982b4bfffc41f900006b4843edff6c22d822d822d822d8329041edff6c22484a1966fc538993c8200952802f002f082f044eba082c7000206dfffc10102e802f044eba0816206dfffc2ea800022f044eba0808206dfffc102800061b40ff6c422dff6d41edff6c22484a1966fc538993c8200952802e802f082f044eba07e24fef001c7e00206dfffcbea800026c0000dc2007720a4eba1b36226dfffc20690014d1c0700010102f002f042b48fff84eba07a8206dfff83028000248c02e802f044eba0796206dfff83028000448c02e802f044eba07844fef00107c00206dfff83028000448c0bc806c54226dfff820690006d1c6700010100c4000056432d040303b00064efb00040008000800080008000841edff6cd1c62c6dfff8226e0006d3c67000101143edff66d2c01091600a41edff6cd1c610adff665286609e41edff6c2248d3c6421122484a1966fc538993c8200952802f002f082f044eba07004fef000c52876000ff1c2b4afffc95ca41f900006b5a43edff6c22d822d822d822d832904aadfffc6600fe8e2f044eba06d4584f60027a00
 *   got:     9efc00a848e70734266f00c82a6f00c4700a2f4000ac7c0141f90000000043ef00b8700512d851c8fffc487803ee487900000000610000002e00504f4a8766087c00200660000192244d41f90000000043ef001822d822d822d822d832d841ef001822484a1966fc538993c8200952802f002f082f0761000000700010122e802f07610000002eaa00022f0761000000102a00061f40002c422f002d41ef002c22484a1966fc538993c8200952802e802f082f07610000004fef001c7a00baaa00026c0000ec2005222f00ac61000000206a0014d1c0700010102f002f072f4800bc61000000206f00bc3028000248c02e802f0761000000206f00c03028000448c02e802f07610000004fef001042af00b0206f00b43028000448c0222f00b0b2806c5e226f00b420690006d1c11010720012000c81000000056436d241323b10064efb100400080008000800080008226f00b420690006d1ef00b010107200120041ef00b8d0c1202f00b01f900818600a202f00b01faf00b8081852af00b06090202f00b04237081841ef001822484a1966fc538993c8200952802f002f082f07610000004fef000c52856000ff10244b97cb41f90000000043ef001822d822d822d822d832d8200a6600fe922f0761000000584f20064cdf2ce0defc00a84e754e71
 *   summary: 484 got vs 468 ref, and the reference stops at LOCAVAIL_SaveAvailabilityDataFile_Return so the epilogue is not counted. The original keeps the section context and the current record in A5 frame slots and reloads each before every field write; 6.51 reloads them in a different order at four sites. Both header strings are copied through an 18-byte struct assignment and the six-byte tag table through a six-byte one, which is what produces the original's MOVE.L (A0)+,(A1)+ chains rather than a MOVE.B loop. The ten-byte record stride is held in a local so its scaling calls the 32x32 helper. The five-case code translation keeps its jump table with all five entries pointing at one arm, exactly as the original emits it, and the two-pass day loop, the decimal field writes and the per-record line terminator match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

struct AvailRec {
    unsigned char id;           /* +0 */
    char          pad1;
    short         group;        /* +2 */
    short         count;        /* +4 */
    char         *codes;        /* +6 */
};                              /* the record stride is ten bytes */

struct AvailCtx {
    unsigned char day;          /* +0 */
    char          pad1;
    long          count;        /* +2 */
    unsigned char mark;         /* +6 */
    char          pad7[13];
    char         *table;        /* +20 */
};

struct TagBlob  { char b[6]; };
struct LineBlob { long w[4]; short h; };     /* 18 bytes */

extern struct TagBlob  LOCAVAIL_TAG_UVGTI;
extern struct LineBlob LOCAVAIL_STR_LA_VER_1_COLON_CURDAY;
extern struct LineBlob LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY;
extern char LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save[];

extern long DISKIO_OpenFileWithBuffer(char *path, long mode);
extern void DISKIO_WriteBufferedBytes(long fh, char *buf,
                                                      long n);
extern void DISKIO_WriteDecimalField(long fh, long value);
extern void DISKIO_CloseBufferedFileAndFlush(long fh);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);

long LOCAVAIL_SaveAvailabilityDataFile(struct AvailCtx *primary,
                                       struct AvailCtx *secondary)
{
    char  tag[6];
    char  line[148];
    struct AvailCtx  *ctx;
    struct AvailRec  *rec;
    long  fh;
    long  ok;
    long  row;
    long  col;
    long  stride;

    stride = 10;
    ok = 1;
    *(struct TagBlob *)tag = LOCAVAIL_TAG_UVGTI;

    fh = DISKIO_OpenFileWithBuffer(
             LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save, 1006);
    if (fh == 0) {
        ok = 0;
        return ok;
    }

    ctx = primary;
    *(struct LineBlob *)line = LOCAVAIL_STR_LA_VER_1_COLON_CURDAY;

    do {
        DISKIO_WriteBufferedBytes(fh, line, strlen(line) + 1);
        DISKIO_WriteDecimalField(fh, (long)ctx->day);
        DISKIO_WriteDecimalField(fh, ctx->count);

        line[0] = ctx->mark;
        line[1] = 0;
        DISKIO_WriteBufferedBytes(fh, line, strlen(line) + 1);

        row = 0;
        while (row < ctx->count) {
            rec = (struct AvailRec *)(ctx->table + row * stride);
            DISKIO_WriteDecimalField(fh, (long)rec->id);
            DISKIO_WriteDecimalField(fh, (long)rec->group);
            DISKIO_WriteDecimalField(fh, (long)rec->count);

            col = 0;
            while (col < (long)rec->count) {
                switch ((unsigned char)rec->codes[col]) {
                case 0:
                case 1:
                case 2:
                case 3:
                case 4:
                    line[col] = tag[(unsigned char)rec->codes[col]];
                    break;
                default:
                    line[col] = tag[0];
                    break;
                }
                col++;
            }
            line[col] = 0;

            DISKIO_WriteBufferedBytes(fh, line, strlen(line) + 1);
            row++;
        }

        ctx = secondary;
        secondary = 0;
        *(struct LineBlob *)line = LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY;
    } while (ctx != 0);

    DISKIO_CloseBufferedFileAndFlush(fh);
    return ok;
}
