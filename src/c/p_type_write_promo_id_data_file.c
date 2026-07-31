/* RESTORES: P_TYPE_WritePromoIdDataFile
 * MODULE:   modules/groups/b/a/p_typebb_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a7-frame-and-shorter-strcpy
 *   ref:     4e55ff8848e70700487803ee487900006d5e4eba1f3a504f2e004a876700011e41f900006d6e43edff9312d866fc7a007002ba80670000fe2005e58041f90000b4e0d1c02b50fff841edff9322484a1966fc538993c82f092f082f074eba1ede4fef000c4aadfff867000090206dfff8202800024a806f000082720012102f002f01487900006d76486dff934eba184e41edff9322484a1966fc538993c82e892f082f074eba1e964fef00187c00206dfff8bca800026c14226dfff820690006d1c610101b806893528660e22046528620081bbc000a08934235689341edff9322484a1966fc538993c82f092f082f074eba1e4a4fef000c601448780009487900006d8a2f074eba1e344fef000c20054a8067065380671660147a0141f900006d9443edff9312d866fc6000ff047a026000fefe2f074eba1e0a584f4cdf00e04e5d4e75
 *   got:     9efc007048e70704487803ee487900000000610000002e00504f4a876700010641f90000000043ef001312d866fc7c007002bc80670000e62006e58041f900000000d1c02a5041ef001322484a1966fc538993c82f092f082f07610000004fef000c200d677c202d00024a806f74720012152f002f01487900000000486f001f6100000041ef002322484a1966fc538993c82e892f082f07610000004fef00187a00baad00026c0e206d0006d1c51f905813528560ec41ef00132248d3c5528512bc000a4237581322484a1966fc538993c82f092f082f07610000004fef000c6014487800094879000000002f07610000004fef000c20064a8067065380671660147c0141f90000000043ef001312d866fc6000ff1c7c026000ff162f0761000000584f4cdf20e0defc00704e754e71
 *   summary: 304 got vs 324 ref, twenty bytes SHORT. The original keeps the 109-byte line buffer at a negative A5 displacement and rebuilds LEA -109(A5),A0 before each of the four inlined strlen scans; 6.51 addresses it from A7 and folds the base into the scan. The open/write/close sequence, both section strings, the record count guard, the SPrintf header line, the byte copy loop with its trailing newline and NUL, the no-data arm and the two-arm section advance all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

struct PromoRec {
    unsigned char kind;         /* +0 */
    char          pad1;
    long          count;        /* +2 */
    char         *data;         /* +6 */
};

extern struct PromoRec *P_TYPE_PrimaryGroupListPtr[];
extern char P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Write[];
extern char P_TYPE_STR_CURDAY_COLON_WriteSection[];
extern char P_TYPE_STR_NXTDAY_COLON_WriteSection[];
extern char P_TYPE_FMT_PCT_03D_PCT_02D[];
extern char P_TYPE_STR_NO_DATA[];

extern long SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(char *path, long line);
extern void SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(long fh, char *buf, long n);
extern void SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(long fh);
extern void PARSEINI_JMPTBL_WDISP_SPrintf(char *buf, char *fmt, long a, long b);

void P_TYPE_WritePromoIdDataFile(void)
{
    char line[109];
    long fh;
    long sect;
    long i;
    struct PromoRec *rec;

    fh = SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(
             P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Write, 1006);
    if (fh == 0)
        return;

    strcpy(line, P_TYPE_STR_CURDAY_COLON_WriteSection);
    sect = 0;

    while (sect != 2) {
        rec = P_TYPE_PrimaryGroupListPtr[sect];
        SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(fh, line, strlen(line));

        if (rec != 0 && rec->count > 0) {
            PARSEINI_JMPTBL_WDISP_SPrintf(line, P_TYPE_FMT_PCT_03D_PCT_02D,
                                          (long)rec->kind, rec->count);
            SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(fh, line, strlen(line));

            for (i = 0; i < rec->count; i++)
                line[i] = rec->data[i];
            line[i++] = '\n';
            line[i] = 0;

            SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(fh, line, strlen(line));
        } else {
            SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(fh, P_TYPE_STR_NO_DATA, 9);
        }

        switch (sect) {
        case 0:
            sect = 1;
            strcpy(line, P_TYPE_STR_NXTDAY_COLON_WriteSection);
            break;
        case 1:
        default:
            sect = 2;
            break;
        }
    }

    SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(fh);
}
