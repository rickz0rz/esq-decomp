/* RESTORES: ESQSHARED4_BindAndClearBannerWorkRaster
 * MODULE:   modules/groups/a/q/esqshared4_p2.s
 * STATUS:   behavioural
 *
 * Splits the banner work raster's address into two words and pokes them into
 * the twelve copper slots that carry it, then clears the raster.
 *
 * NOT a register-argument function, although coverage.py screens it as one on
 * the strength of its `MOVEM.L D0/A0-A1`. That MOVEM is callee-save for an
 * assembly caller, not an argument list: the body reads no register it did not
 * load itself. Its one caller sets D1 to 0x58 before the call and the body
 * never reads D1 either -- _ESQSHARED4_ClearBannerWorkRasterWithOnes loads its
 * own count into D1, so the caller's value is dead.
 *
 * The low word goes to six slots and the high word to six, and the two sets are
 * NOT the same six. Tail A and tail B take only the HIGH word, and there is no
 * matching low-word store for either. That asymmetry is in the original.
 *
 * SASC-MISMATCH: swap-versus-shift
 *   ref:     MOVE.L A1,D0 / six MOVE.W / SWAP D0 / six MOVE.W
 *   got:     the address held in a long local, with a cast to UWORD for the low
 *            half and a shift for the high half
 *   summary: the original builds both halves out of one register with SWAP,
 *            which C has no operator for. Same twelve stores, same order.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <exec/types.h>

extern void ESQSHARED4_ClearBannerWorkRasterWithOnes(void);

/* Holds a POINTER to the raster. The original reads it as
 * LEA sym,A0 / MOVEA.L (A0),A1, which is the value at sym. */
extern UBYTE *WDISP_BannerWorkRasterPtr;

extern UWORD ESQ_BannerWorkRasterPtrA_LoWord;
extern UWORD ESQ_BannerWorkRasterPtrA_HiWord;
extern UWORD ESQ_BannerWorkRasterPtrMirrorA_LoWord;
extern UWORD ESQ_BannerWorkRasterPtrMirrorA_HiWord;
extern UWORD ESQ_BannerWorkRasterPtrTailA_HiWord;
extern UWORD ESQ_CopperBannerRasterPointerListA;

extern UWORD ESQ_BannerWorkRasterPtrB_LoWord;
extern UWORD ESQ_BannerWorkRasterPtrB_HiWord;
extern UWORD ESQ_BannerWorkRasterPtrMirrorB_LoWord;
extern UWORD ESQ_BannerWorkRasterPtrMirrorB_HiWord;
extern UWORD ESQ_BannerWorkRasterPtrTailB_HiWord;
extern UWORD ESQ_CopperBannerRasterPointerListB;

void ESQSHARED4_BindAndClearBannerWorkRaster(void)
{
    ULONG raster = (ULONG)WDISP_BannerWorkRasterPtr;
    UWORD lo = (UWORD)raster;
    UWORD hi = (UWORD)(raster >> 16);

    ESQ_BannerWorkRasterPtrA_LoWord = lo;
    ESQ_BannerWorkRasterPtrMirrorA_LoWord = lo;
    ESQ_CopperBannerRasterPointerListA = lo;
    ESQ_BannerWorkRasterPtrB_LoWord = lo;
    ESQ_BannerWorkRasterPtrMirrorB_LoWord = lo;
    ESQ_CopperBannerRasterPointerListB = lo;

    ESQ_BannerWorkRasterPtrA_HiWord = hi;
    ESQ_BannerWorkRasterPtrMirrorA_HiWord = hi;
    ESQ_BannerWorkRasterPtrTailA_HiWord = hi;
    ESQ_BannerWorkRasterPtrB_HiWord = hi;
    ESQ_BannerWorkRasterPtrMirrorB_HiWord = hi;
    ESQ_BannerWorkRasterPtrTailB_HiWord = hi;

    ESQSHARED4_ClearBannerWorkRasterWithOnes();
}
