/* RESTORES: _ESQSHARED4_InitializeBannerCopperSystem
 * MODULE:   modules/groups/a/q/esqshared4_p1.s
 * STATUS:   behavioural
 *
 * THREE FUNCTIONS. Two are labelled and the third is not -- an unreferenced
 * six-instruction tail that re-applies the banner colour base. It is the "not
 * every function has a label" case again; see AGENTS.md.
 *
 * IT WRITES POINTERS INTO A LIVE COPPER LIST, one 16-bit half at a time. Each
 * `MOVE.W` lands on the value word of a copper MOVE instruction, so the low and
 * high halves of one address end up in two separate instructions. That is why
 * every target here is declared `short` rather than `long`: the assembly does a
 * TWO-BYTE store at the symbol, and matching the store width is what makes the
 * C write the same bytes. The data section declares several of the same symbols
 * `long`, and that disagreement is deliberate -- AGENTS.md records that the CODE
 * is the authority on width, not the data.
 *
 * FOUR ADDRESSES PER PLANE, at fixed displacements from the plane's scratch
 * raster base: +2992, +3080, +5984 and +6072. 5984 is the assembler equate
 * GCOMMAND_BannerRowByteOffsetResetValueDefault, asserted in src/data-lengths.s.
 *
 * THE THREE DESTINATION POINTERS ARE ONE 12-BYTE RUN, NOT THREE SYMBOLS. The
 * original walks them with `MOVE.L A2,(A1)+`, and the data section stores each
 * as TWO bytes -- ESQPARS2_BannerSnapshotPlane1DstPtr and its Plane2 sibling are
 * two of the eight adjacencies listed in AGENTS.md. So the C writes through a
 * cast on the first symbol rather than naming the other two, exactly as
 * esq_update_copper_lists_from_params.c does.
 *
 * ESQSHARED4_SetBannerColorBaseAndLimit TAKES ITS ARGUMENT IN D0. It is one of
 * the register-argument family and carries DO-NOT-LINK for that reason, so the
 * two calls here use an `__asm register __d0` prototype -- the mechanism
 * AGENTS.md describes for the CALLERS of that family. Its clobbers are safe: it
 * writes D0 and D1 only, and both are scratch under the ordinary convention, so
 * SAS/C already assumes they do not survive.
 *
 * THE ORIGINAL PRESERVES D0/D1/A0/A1 AND THE C DOES NOT. Both labelled functions
 * open `MOVEM.L D0-D1/A0-A4`, which is the register-args signature, but neither
 * reads an argument -- it is a hand-written routine being polite. The only
 * caller in the program is one JSR in modules/groups/a/m/esq.s, inside an init
 * sequence whose neighbouring statements are themselves calls, so nothing is
 * live in those registers across it. Checked before converting, because a
 * caller that did rely on it would break with no diagnostic.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   scope:   program-wide under SAS/C 6.51. See AGENTS.md.
 */

extern volatile unsigned char CIAB_PRA;

extern short ESQPARS2_BannerSweepBaseColor, ESQPARS2_BannerSweepOffsetColor;
extern short ESQPARS2_ReadModeFlags, ESQPARS2_StateIndex;
extern short ESQPARS2_HighlightTickCountdown, ESQPARS2_CopperProgramPendingFlag;
extern short ESQPARS2_BannerColorThreshold, ESQPARS2_BannerColorBaseValue;
extern short CONFIG_BannerCopperHeadByte;
extern unsigned char ESQ_CopperListBannerA, ESQ_CopperListBannerB;

extern char *ESQSHARED_BannerRowScratchRasterBase0;
extern char *ESQSHARED_BannerRowScratchRasterBase1;
extern char *ESQSHARED_BannerRowScratchRasterBase2;

/* One 12-byte run; see the header. */
extern unsigned char ESQPARS2_BannerSnapshotPlane0DstPtr[];
extern char *ESQPARS2_BannerRowOffsetResetPtrPlane0[];
extern char *ESQPARS2_BannerRowOffsetResetPtrPlane1;
extern char *ESQPARS2_BannerRowOffsetResetPtrPlane2Table;

extern void ESQSHARED4_SnapshotDisplayBufferBases(void);
extern void ESQSHARED4_ResetBannerColorSweepState(void);
extern void __asm ESQSHARED4_SetBannerColorBaseAndLimit(register __d0 short base);

#define RESET_DEFAULT 5984      /* GCOMMAND_BannerRowByteOffsetResetValueDefault */

void ESQSHARED4_SetupBannerPlanePointerWords(void);

void ESQSHARED4_InitializeBannerCopperSystem(void)
{
    short colour = 0x62;
    short head;

    ESQPARS2_BannerSweepBaseColor = colour;
    colour -= 2;
    ESQPARS2_BannerSweepOffsetColor = colour;

    ESQPARS2_ReadModeFlags = 5;
    ESQPARS2_StateIndex = 2;
    ESQPARS2_HighlightTickCountdown = 10;

    ESQSHARED4_SnapshotDisplayBufferBases();
    ESQSHARED4_ResetBannerColorSweepState();
    ESQSHARED4_SetupBannerPlanePointerWords();

    /* Two separate read-modify-writes, as the original does them. */
    CIAB_PRA = (unsigned char)(CIAB_PRA | 0x80);
    CIAB_PRA = (unsigned char)(CIAB_PRA | 0x40);

    head = CONFIG_BannerCopperHeadByte;
    ESQ_CopperListBannerA = (unsigned char)head;
    ESQ_CopperListBannerB = (unsigned char)head;

    ESQPARS2_CopperProgramPendingFlag = 1;
}

extern short ESQ_BannerPlane0SnapshotScratchPtrLoWord;
extern short ESQ_BannerPlane0SnapshotScratchPtrHiWord;
extern short ESQ_BannerPlane0ScratchPtrAlt_LoWord;
extern short ESQ_BannerPlane0ScratchPtrAlt_HiWord;
extern short ESQ_BannerSnapshotPlane0DstPtrLoWord;
extern short ESQ_BannerSnapshotPlane0DstPtrHiWord;
extern short ESQ_BannerPlane0DstPtrReset_LoWord;
extern short ESQ_BannerPlane0DstPtrReset_HiWord;
extern short ESQ_BannerSweepSrcPlane0Ptr_LoWord;
extern short ESQ_BannerSweepSrcPlane0Ptr_HiWord;
extern short ESQ_BannerSweepSrcPlane0PtrReset_LoWord;
extern short ESQ_BannerSweepSrcPlane0PtrReset_HiWord;

extern short ESQ_BannerPlane1SnapshotScratchPtrLoWord;
extern short ESQ_BannerPlane1SnapshotScratchPtrHiWord;
extern short ESQ_BannerPlane1ScratchPtrAlt_LoWord;
extern short ESQ_BannerPlane1ScratchPtrAlt_HiWord;
extern short ESQ_BannerSnapshotPlane1DstPtrLoWord;
extern short ESQ_BannerSnapshotPlane1DstPtrHiWord;
extern short ESQ_BannerPlane1DstPtrReset_LoWord;
extern short ESQ_BannerPlane1DstPtrReset_HiWord;
extern short ESQ_BannerSweepSrcPlane1Ptr_LoWord;
extern short ESQ_BannerSweepSrcPlane1Ptr_HiWord;
extern short ESQ_BannerSweepSrcPlane1PtrReset_LoWord;
extern short ESQ_BannerSweepSrcPlane1PtrReset_HiWord;

extern short ESQ_BannerPlane2SnapshotScratchPtrLoWord;
extern short ESQ_BannerPlane2SnapshotScratchPtrHiWord;
extern short ESQ_BannerPlane2ScratchPtrAlt_LoWord;
extern short ESQ_BannerPlane2ScratchPtrAlt_HiWord;
extern short ESQ_BannerSnapshotPlane2DstPtrLoWord;
extern short ESQ_BannerSnapshotPlane2DstPtrHiWord;
extern short ESQ_BannerPlane2DstPtrReset_LoWord;
extern short ESQ_BannerPlane2DstPtrReset_HiWord;
extern short ESQ_BannerSweepSrcPlane2Ptr_LoWord;
extern short ESQ_BannerSweepSrcPlane2Ptr_HiWord;
extern short ESQ_BannerSweepSrcPlane2PtrReset_LoWord;
extern short ESQ_BannerSweepSrcPlane2PtrReset_HiWord;

void ESQSHARED4_SetupBannerPlanePointerWords(void)
{
    long *dst = (long *)ESQPARS2_BannerSnapshotPlane0DstPtr;
    char *base;
    long a;

    /* ---- plane 0 ---- */
    base = ESQSHARED_BannerRowScratchRasterBase0;

    a = (long)(base + 2992);
    ESQ_BannerPlane0SnapshotScratchPtrLoWord = (short)a;
    ESQ_BannerPlane0SnapshotScratchPtrHiWord = (short)(a >> 16);

    a = (long)(base + 3080);
    ESQ_BannerPlane0ScratchPtrAlt_LoWord = (short)a;
    ESQ_BannerPlane0ScratchPtrAlt_HiWord = (short)(a >> 16);

    a = (long)(base + RESET_DEFAULT);
    dst[0] = a;
    ESQPARS2_BannerRowOffsetResetPtrPlane0[0] = (char *)a;

    ESQ_BannerSnapshotPlane0DstPtrLoWord = (short)a;
    ESQ_BannerPlane0DstPtrReset_LoWord   = (short)a;
    ESQ_BannerSnapshotPlane0DstPtrHiWord = (short)(a >> 16);
    ESQ_BannerPlane0DstPtrReset_HiWord   = (short)(a >> 16);

    a = (long)(base + 6072);
    ESQ_BannerSweepSrcPlane0Ptr_LoWord      = (short)a;
    ESQ_BannerSweepSrcPlane0PtrReset_LoWord = (short)a;
    ESQ_BannerSweepSrcPlane0Ptr_HiWord      = (short)(a >> 16);
    ESQ_BannerSweepSrcPlane0PtrReset_HiWord = (short)(a >> 16);

    /* ---- plane 1 ---- */
    base = ESQSHARED_BannerRowScratchRasterBase1;

    a = (long)(base + 2992);
    ESQ_BannerPlane1SnapshotScratchPtrLoWord = (short)a;
    ESQ_BannerPlane1SnapshotScratchPtrHiWord = (short)(a >> 16);

    a = (long)(base + 3080);
    ESQ_BannerPlane1ScratchPtrAlt_LoWord = (short)a;
    ESQ_BannerPlane1ScratchPtrAlt_HiWord = (short)(a >> 16);

    a = (long)(base + RESET_DEFAULT);
    dst[1] = a;
    ESQPARS2_BannerRowOffsetResetPtrPlane1 = (char *)a;

    ESQ_BannerSnapshotPlane1DstPtrLoWord = (short)a;
    ESQ_BannerPlane1DstPtrReset_LoWord   = (short)a;
    ESQ_BannerSnapshotPlane1DstPtrHiWord = (short)(a >> 16);
    ESQ_BannerPlane1DstPtrReset_HiWord   = (short)(a >> 16);

    a = (long)(base + 6072);
    ESQ_BannerSweepSrcPlane1Ptr_LoWord      = (short)a;
    ESQ_BannerSweepSrcPlane1PtrReset_LoWord = (short)a;
    ESQ_BannerSweepSrcPlane1Ptr_HiWord      = (short)(a >> 16);
    ESQ_BannerSweepSrcPlane1PtrReset_HiWord = (short)(a >> 16);

    /* ---- plane 2 ---- */
    base = ESQSHARED_BannerRowScratchRasterBase2;

    a = (long)(base + 2992);
    ESQ_BannerPlane2SnapshotScratchPtrLoWord = (short)a;
    ESQ_BannerPlane2SnapshotScratchPtrHiWord = (short)(a >> 16);

    a = (long)(base + 3080);
    ESQ_BannerPlane2ScratchPtrAlt_LoWord = (short)a;
    ESQ_BannerPlane2ScratchPtrAlt_HiWord = (short)(a >> 16);

    a = (long)(base + RESET_DEFAULT);
    dst[2] = a;
    ESQPARS2_BannerRowOffsetResetPtrPlane2Table = (char *)a;

    ESQ_BannerSnapshotPlane2DstPtrLoWord = (short)a;
    ESQ_BannerPlane2DstPtrReset_LoWord   = (short)a;
    ESQ_BannerSnapshotPlane2DstPtrHiWord = (short)(a >> 16);
    ESQ_BannerPlane2DstPtrReset_HiWord   = (short)(a >> 16);

    a = (long)(base + 6072);
    ESQ_BannerSweepSrcPlane2Ptr_LoWord      = (short)a;
    ESQ_BannerSweepSrcPlane2PtrReset_LoWord = (short)a;
    ESQ_BannerSweepSrcPlane2Ptr_HiWord      = (short)(a >> 16);
    ESQ_BannerSweepSrcPlane2PtrReset_HiWord = (short)(a >> 16);

    ESQSHARED4_SetBannerColorBaseAndLimit(ESQPARS2_BannerColorThreshold);
}

/* Unlabelled in the original, and nothing calls it: six instructions that
 * re-apply the banner colour base from the value already stored. */
void ESQSHARED4_ReapplyBannerColorBase(void)
{
    ESQSHARED4_SetBannerColorBaseAndLimit(ESQPARS2_BannerColorBaseValue);
}
