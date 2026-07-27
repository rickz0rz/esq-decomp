/* RESTORES: TLIBA3_InitRuntimeEntry
 * MODULE:   modules/groups/b/a/tliba3.s
 * STATUS:   behavioural
 *
 * 250 bytes in the original, 276 emitted, only FIVE differing regions -- but
 * they are large ones. See the multiply note below.
 *
 * Reproduces: the five short field writes, the 100-byte RastPort copy into the
 * entry, the copied RastPort's BitMap pointer aimed at the entry's own embedded
 * BitMap, the InitBitMap call, the five-plane pointer copy, and the paired
 * zeroing of the last two shorts.
 *
 * The entry layout decodes exactly as 5 shorts (0..9), an embedded struct
 * RastPort (10..109, 100 bytes), an embedded struct BitMap (110..149, 40 bytes)
 * and two trailing shorts -- 154 bytes total, which is the stride the original
 * multiplies by.
 *
 * TWO SOURCE-SHAPE RULES worth carrying forward:
 *
 *   - Copy a struct with ASSIGNMENT, not memcpy. Written as
 *     memcpy(&ent.rp, rp, 100) SAS/C emits a 100-iteration MOVE.B loop; written
 *     as ent.rp = *rp it emits MOVEQ #24 / MOVE.L (A1)+,(A2)+ / DBF, matching the
 *     original's 25-long copy exactly. That one change took this restoration from
 *     296 bytes to 276. (Note this is the opposite of ed_capture_key_sequence.c,
 *     where memcpy of a 24-byte char array was the right call -- the rule is
 *     about whether the source has a struct type, not about size.)
 *
 *   - Do NOT cache the entry pointer in a local. The original recomputes
 *     idx*154 three separate times, so writing table[idx].field throughout is
 *     faithful; hoisting a pointer would collapse them into one.
 *
 * SASC-MISMATCH: multiply-strength-reduction
 *   ref:     724d d281 4eba2a16       MOVEQ #77,D1 / ADD.L D1,D1 / JSR MATH_Mulu32
 *   got:     e580 9087 e580 9087 2200 e781 9280 d281   inline shift/subtract chain
 *   summary: idx * 154. The original builds 154 as 77x2 (the doubling rule) and
 *            calls the multiply helper; SAS/C expands it inline as shifts and
 *            adds. At three call sites that is the entire +26, and it is why the
 *            region count is 5 while the byte delta is large.
 *   scope:   every multiply by a constant, program-wide.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc                 LINK.W A5,#-4
 *   got:     594f                     SUBQ.W #4,A7
 */
#include "esq-graphics.h"
#include <string.h>

struct RtEntry {
    short a, b, c, d, e;      /*   0,2,4,6,8 */
    struct RastPort rp;       /*  10 */
    struct BitMap   bm;       /* 110 */
    short f150, f152;         /* 150,152 */
};

extern struct RtEntry TLIBA3_VmArrayRuntimeTable[];
extern struct RastPort *Global_REF_RASTPORT_1;
extern PLANEPTR WDISP_DisplayContextPlanePointer0[];

void TLIBA3_InitRuntimeEntry(long idx, short a, short b, short c,
                             short d, short e, char depth)
{
    long i;

    TLIBA3_VmArrayRuntimeTable[idx].a = a;
    TLIBA3_VmArrayRuntimeTable[idx].b = b;
    TLIBA3_VmArrayRuntimeTable[idx].c = c;
    TLIBA3_VmArrayRuntimeTable[idx].d = d;
    TLIBA3_VmArrayRuntimeTable[idx].e = e;

    TLIBA3_VmArrayRuntimeTable[idx].rp = *Global_REF_RASTPORT_1;
    TLIBA3_VmArrayRuntimeTable[idx].rp.BitMap = &TLIBA3_VmArrayRuntimeTable[idx].bm;

    InitBitMap(&TLIBA3_VmArrayRuntimeTable[idx].bm, (long)depth, (long)b, (long)c);

    for (i = 0; i < 5; i++)
        TLIBA3_VmArrayRuntimeTable[idx].bm.Planes[i] =
            WDISP_DisplayContextPlanePointer0[i];

    TLIBA3_VmArrayRuntimeTable[idx].f152 = TLIBA3_VmArrayRuntimeTable[idx].f150 = 0;
}
