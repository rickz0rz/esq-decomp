/* esq-banner.h -- register-argument prototypes for the banner colour sweep.
 *
 * modules/groups/a/q/esqshared4_p5.s is a chain of entry points that hand each
 * other a colour byte in D0 and a copper-list pointer in A4, and several of
 * them fall through rather than call. Two of the entries are reachable by name
 * and need the convention stated in C.
 *
 * A4 IS NOT A PARAMETER, and that is the one judgement call in this cluster.
 * Every caller of SetBannerCopperColorAndThreshold loads it with the SAME
 * constant -- `LEA _ESQ_CopperListBannerA,A4` -- at all five sites, and the
 * callee's first instruction stores through it before reloading A4 with the
 * next list. So the register carries no information the callee could not read
 * from the symbol, and folding it away costs one LEA per caller and no
 * behaviour. It also avoids `register __a4`, which would be a poor bet: A4 is
 * SAS/C's near-data base and is only free because this project builds DATA=FAR.
 *
 * One header rather than a copy per file, for the reason esq-copper.h gives: a
 * prototype that disagrees with its definition is invisible to the linker, and
 * these nine functions are merged into one translation unit.
 */
#ifndef ESQ_BANNER_H
#define ESQ_BANNER_H

/* The colour byte arrives in D0. A4 is folded away -- see above. */
void __asm ESQSHARED4_SetBannerCopperColorAndThreshold(
        register __d0 unsigned short colour);

/* The colour byte arrives in D0. Falls out through
 * ESQSHARED4_BindAndClearBannerWorkRaster. */
void __asm ESQSHARED4_ApplyBannerColorStep(register __d0 unsigned short colour);

/* Takes nothing; seeds the step counter and enters ApplyBannerColorStep at
 * colour 0x19. The original reaches it by falling through. */
void ESQSHARED4_ResetBannerColorToStart(void);

#endif /* ESQ_BANNER_H */
