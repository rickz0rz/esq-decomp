/* RESTORES: BRUSH_CloneBrushRecord
 * MODULE:   modules/groups/a/a/brush_p3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-and-base-reload
 *   ref:     4e55fff448e72130266d000842adfff82f3c0001000148780174487804e048790000024a4eba67264fef00102b40fff84a80670001de204b224012d866fc206dfff841e800b043eb0080700420d951c8fffc206dfff841e800c443eb009420d9206dfff842a8017043e800887000102800b87200322800b07400342800b220492c79000028584eaefe7a206dfff8116b00be0020216b00c20148216b00c6014c216b00ca0150216b00ce0154216b00d20158216b00de0164216b00e201687e007004be806c1e2007e780206dfff8d1c0224bd3c045e800c841e9009824d824d8528760dc206dfff841e8002143eb00bf10d966fc206dfff8216b00e6016c4aab00d66708216b00d6015c600a7000302800b02140015c4aab00da6708216b00da0160600a7000302800b2214001607e007000206dfff8102800b8be806c00008a7005be806c0000822007e5807200322800b07400342800b22f022f01487805164879000002522f4000204eba02b24fef0010206dfff8222f0010068100000090218018002007e58022000681000000904ab01800662c2c7800044eaeff7c4ab9000001c06616700123c0000001c0206dfff843f900007dbb12d866fc4eaeff76600652876000ff6a7000206dfff8102800b8be80663c43e800242c79000028584eaeff3a206dfff841e80088226dfff8234800287e007060be806c16206dfff820070680000000e811b378200800528760e4202dfff84cdf0c844e5d4e75
 *   got:     594f48e721362a6f002097cb2f3c0001000148780174487804e04879000000006100000026404a804fef00106606200b600001f4204d224b12d866fc41eb00b043ed00802448700424d951c8fffc43eb00c445ed0094229243eb0170429143eb008845eb00b8700010127200321041eb00b27400341020492c79000000004eaefe7a176d00be002041eb014843ed00c2209141eb014c43ed00c6209141eb015043ed00ca209141eb015443ed00ce209141eb015843ed00d2209141eb016443ed00de209141eb016843ed00e220917e007004be806c1c2007e780204bd1c043e800c8204dd1c045e8009822da22da528760de41eb002143ed00bf10d966fc41eb016c43ed00e6209141ed00d62010670843eb015c2280600e41eb015c43eb00b070003011208041ed00da2010670843eb01602280600e41eb016043eb00b27000301120807e0041eb00b870001010be806c00008e7005be806c0000862007e580204bd1c043e8009041eb00b07000301041eb00b2720032102f012f00487805164879000000002f490028610000004fef0010206f001820802007e580204bd1c043e800904a9166322c79000000004eaeff7c4ab9000000006614700123c000000000204b43f90000000012d866fc2c79000000004eaeff76600652876000ff6841eb00b870001010be806704200b603641eb002422482c79000000004eaeff3a41eb002843eb008820897e007060be806c1220070680000000e817b578200800528760e8200b4cdf6c84584f4e754e71
 *   summary: 560 got vs 542 ref, eighteen bytes over. The original keeps the clone pointer in an A5 frame slot and reloads MOVEA.L -8(A5),A0 before each group of field writes, then reaches the whole group through (d16,A0); 6.51 reloads it more often inside the plane-allocation loop and re-derives the scaled plane index after the call. The 20-byte dimension block and the four 8-byte row-offset blocks are copied through struct assignments, which is what produces the original's MOVE.L (A0)+,(A1)+ and DBF; memcpy would inline a MOVE.B loop. The header and label strcpy pair, the InitBitMap from the copied depth and dimensions, the eight long field copies, the two zero-means-full limit defaults, the depth-capped-at-five plane loop with its Forbid/alert/Permit failure path, the completion test, InitRastPort and the 96-byte palette copy all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/gfx.h>
#include <string.h>
#include "esq-graphics.h"
#include "esq-exec.h"

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

struct Blob20 { long w[5]; };
struct Blob8  { long w[2]; };

extern long BRUSH_PendingAlertCode;
extern char BRUSH_SnapshotHeader[];
extern char Global_STR_BRUSH_C_17[];
extern char Global_STR_BRUSH_C_18[];

extern char *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);
extern long  GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(char *who, long line,
                                                  long width, long height);

char *BRUSH_CloneBrushRecord(char *src)
{
    char *dst;
    long  i;

    dst = 0;
    dst = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_BRUSH_C_17, 1248, 372,
              MEMF_PUBLIC + MEMF_CLEAR);
    if (dst == 0)
        return dst;

    strcpy(dst, src);

    *(struct Blob20 *)(dst + 176) = *(struct Blob20 *)(src + 128);
    *(long *)(dst + 196) = *(long *)(src + 148);
    *(long *)(dst + 368) = 0;

    InitBitMap((struct BitMap *)(dst + 136),
               (long)*(unsigned char *)(dst + 184),
               (long)*(unsigned short *)(dst + 176),
               (long)*(unsigned short *)(dst + 178));

    dst[32] = src[190];
    *(long *)(dst + 328) = *(long *)(src + 194);
    *(long *)(dst + 332) = *(long *)(src + 198);
    *(long *)(dst + 336) = *(long *)(src + 202);
    *(long *)(dst + 340) = *(long *)(src + 206);
    *(long *)(dst + 344) = *(long *)(src + 210);
    *(long *)(dst + 356) = *(long *)(src + 222);
    *(long *)(dst + 360) = *(long *)(src + 226);

    i = 0;
    while (i < 4) {
        *(struct Blob8 *)(dst + (i << 3) + 200) =
            *(struct Blob8 *)(src + (i << 3) + 152);
        i++;
    }

    strcpy(dst + 33, src + 191);
    *(long *)(dst + 364) = *(long *)(src + 230);

    if (*(long *)(src + 214) != 0)
        *(long *)(dst + 348) = *(long *)(src + 214);
    else
        *(long *)(dst + 348) = (long)*(unsigned short *)(dst + 176);

    if (*(long *)(src + 218) != 0)
        *(long *)(dst + 352) = *(long *)(src + 218);
    else
        *(long *)(dst + 352) = (long)*(unsigned short *)(dst + 178);

    i = 0;
    while (i < (long)*(unsigned char *)(dst + 184) && i < 5) {
        *(long *)(dst + (i << 2) + 144) = GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(
            Global_STR_BRUSH_C_18, 1302,
            (long)*(unsigned short *)(dst + 176),
            (long)*(unsigned short *)(dst + 178));

        if (*(long *)(dst + (i << 2) + 144) == 0) {
            Forbid();
            if (BRUSH_PendingAlertCode == 0) {
                BRUSH_PendingAlertCode = 1;
                strcpy(BRUSH_SnapshotHeader, dst);
            }
            Permit();
            break;
        }
        i++;
    }

    if (i != (long)*(unsigned char *)(dst + 184))
        return dst;

    InitRastPort((struct RastPort *)(dst + 36));
    *(char **)(dst + 40) = dst + 136;

    i = 0;
    while (i < 96) {
        dst[i + 232] = src[i + 32];
        i++;
    }

    return dst;
}
