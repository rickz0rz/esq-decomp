#include "esq_types.h"

extern s16 ESQ_BannerCharIndexShadow2273;

__asm__(
    ".globl _ESQ_AdvanceBannerCharIndex_Return\n"
    "_ESQ_AdvanceBannerCharIndex_Return:\n"
    "    move.w %d0,_ESQ_BannerCharIndexShadow2273\n"
    "    movem.l (%sp)+,%d2-%d3\n"
    "    rts\n");
