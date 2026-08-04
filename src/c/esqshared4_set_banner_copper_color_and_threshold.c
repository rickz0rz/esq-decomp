/* RESTORES: ESQSHARED4_SetBannerCopperColorAndThreshold
 * MODULE:   modules/groups/a/q/esqshared4_p5.s   (1 of its 10 blocks)
 * STATUS:   behavioural
 *
 * Writes one colour byte into the eight banner copper words -- the head byte,
 * the sweep wait row, the sweep start and the sweep end, in both the A and B
 * lists -- and leaves the last value in ESQPARS2_BannerColorThreshold.
 *
 * IT IS ENTERED WITH THE COLOUR IN D0 AND A COPPER-LIST POINTER IN A4, and
 * only the first is a real parameter. See esq-banner.h for why A4 folds away:
 * all five callers load it with the same constant.
 *
 * THE ARITHMETIC IS BYTE-WIDE IN THE MIDDLE AND WORD-WIDE AT THE END, and
 * modelling it as a plain `unsigned char` is exact rather than a
 * simplification. The original does ADDI.B twice, then ADDQ.W, then
 * ANDI.W #$ff. Working it through: a carry out of the low byte from the ADDQ.W
 * lands in the high byte, and the ANDI.W throws that high byte away again --
 * and every MOVE.B along the way only ever saw the low byte. So the high byte
 * cannot reach any observable result, whatever it held on entry, and byte
 * arithmetic throughout gives the same eight stores and the same threshold.
 *
 * The +1, +0x11, +1 steps are the copper's own geometry: the wait row is one
 * line below the head, the sweep starts 0x11 lines after that, and the sweep
 * ends one line later.
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     1880 ... 33c0<threshold> 4e75   (34)
 *   summary: SAS/C copies D0 into a callee-saved register of its own and
 *            reloads each list address as an absolute under DATA=FAR, where
 *            the original walks A4 through the eight symbols with LEA. The
 *            eight stores, the three increments and the threshold write are
 *            the same in the same order.
 *   scope:   every `__asm` register function in the program.
 *   retest:  a compiler that works in the argument register directly.
 */
#include "esq-banner.h"

extern unsigned char ESQ_CopperListBannerA[];
extern unsigned char ESQ_CopperListBannerB[];
extern unsigned char ESQ_BannerSweepWaitRowA[];
extern unsigned char ESQ_BannerSweepWaitRowB[];
extern unsigned char ESQ_BannerSweepWaitStartProgramA[];
extern unsigned char ESQ_BannerSweepWaitStartProgramB[];
extern unsigned char ESQ_BannerSweepWaitEndProgramA[];
extern unsigned char ESQ_BannerSweepWaitEndProgramB[];
extern short ESQPARS2_BannerColorThreshold;

void __asm ESQSHARED4_SetBannerCopperColorAndThreshold(
        register __d0 unsigned short colour)
{
    unsigned char b = (unsigned char)colour;

    ESQ_CopperListBannerA[0] = b;
    ESQ_CopperListBannerB[0] = b;

    b = (unsigned char)(b + 1);
    ESQ_BannerSweepWaitRowA[0] = b;
    ESQ_BannerSweepWaitRowB[0] = b;

    b = (unsigned char)(b + 0x11);
    ESQ_BannerSweepWaitStartProgramA[0] = b;
    ESQ_BannerSweepWaitStartProgramB[0] = b;

    b = (unsigned char)(b + 1);
    ESQ_BannerSweepWaitEndProgramA[0] = b;
    ESQ_BannerSweepWaitEndProgramB[0] = b;

    ESQPARS2_BannerColorThreshold = b;
}
