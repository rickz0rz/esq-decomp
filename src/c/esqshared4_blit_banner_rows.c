/* RESTORES: ESQSHARED4_BlitBannerRowsForActiveField,
 *           ESQSHARED4_CopyInterleavedRowWordsFromOffset,
 *           ESQSHARED4_CopyBannerRowsWithByteOffset,
 *           ESQSHARED4_LoadCopperColorWordsFromNibbleTable
 * MODULE:   modules/groups/a/q/esqshared4_p4.s
 * STATUS:   behavioural
 *
 * The whole module in one file, because a C replacement substitutes for a whole
 * module and these four labels share it.
 *
 * SOLVED 2026-08-03: A LOOP HERE TEARS THE SCREEN. THE FIX IS TO UNROLL.
 *
 * Written with `for` loops, this file drew horizontal colour streaks through the
 * grid time banner slot labels -- "10:30 PM", "11:00 PM", "11:30 PM" -- while the
 * live clock beside them, the date row and the standby banner all stayed clean.
 *
 * It was bisected to this file first, against the right controls:
 *
 *     manifest with this file          STREAKED
 *     manifest without it              CLEAN
 *     pure assembly, ESQ_FARCALLS=1    CLEAN
 *     ESQ.known-good-36cf56ed          CLEAN
 *
 * The last two matter. The ESC-menu grey turned out to be original behaviour, so
 * the original and the pure build are checked BEFORE blaming a restoration.
 *
 * THE LOGIC WAS NEVER WRONG, WHICH IS WHY IT TOOK SO LONG. Every structural
 * check came back clean, and all of it was counted from the encoding rather than
 * read by eye:
 *
 *   - CopyInterleavedRowWordsFromOffset: 51 MOVE.W = 17 groups of three,
 *     16 A1 steps, 15 A2 steps, tail source reloaded from the base.
 *   - CopyBannerRowsWithByteOffset: 17 MOVE.W and 289 MOVE.L = 17 rows of one
 *     word plus 17 longs, 16 A1 steps, 15 A2 steps.
 *   - Source and destination are the right way round (`MOVE.W 6(A2),6(A1)`,
 *     A1 is the destination).
 *   - The three scratch rasters are pointers read as pointers; the copper lists
 *     are arrays passed as addresses. All eight offset globals are DS.L and are
 *     declared `long`.
 *   - Both helpers really are called only from BlitBannerRowsForActiveField.
 *   - LoadCopperColorWordsFromNibbleTable really is dead: its only caller is the
 *     unlabelled block at the head of esqshared4_p5.s, reachable only by
 *     fall-through from _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp, a bare RTS.
 *
 * THE DEFECT WAS TIMING. `ESQSHARED4_CopyBannerRowsWithByteOffset` is 306 moves
 * with ZERO branches in the original -- no DBF, no BRA, no call. That is a
 * DEADLINE, not a style. The chain reaches here from the vertical-blank
 * interrupt:
 *
 *     _ESQ_TickGlobalCounters                       (the VERTB is_Code target)
 *       -> _ESQSHARED4_TickCopperAndBannerTransitions
 *         -> ESQSHARED4_BlitBannerRowsForActiveField
 *
 * and the copy must finish before the raster reaches the banner. Three scratch
 * rasters times 17 rows times 18 moves is about 900 moves per field. A loop adds
 * a compare and a branch to every one of them, the copy overruns the beam, and
 * the display reads rows that are half old and half new. That is the streaking.
 *
 * So the copies are MACROS, not functions. C89 has no `inline` and 6.51 will not
 * inline a static across a call, so a macro is the only way to get the
 * original's straight-line code out of C. The emitted routines are now 668 and
 * 3170 bytes with no branch in either.
 *
 * WHAT TO TAKE FROM THIS. A restoration can be correct in every structural
 * respect and still be wrong, because the original's SHAPE encoded a real-time
 * constraint. No byte comparison sees it -- the sizes are wildly different by
 * design here. No audit sees it. Both byte gates pass. It is visible only on
 * screen. When a routine in an interrupt path is hand-unrolled, assume the
 * unrolling is load-bearing until measured otherwise.
 *
 * WHY THE REGISTER-ARGUMENT BLOCKER DOES NOT APPLY HERE.
 * coverage.py screens the first three as `register-args`, and that screen is
 * about the ORIGINAL's convention, not about C. The base pointer arrives in A0
 * and the two copy helpers are called from BlitBannerRowsForActiveField and from
 * nowhere else in the program. Both caller and callee land in this file, so the
 * convention between them is ours to choose and an ordinary C parameter carries
 * it.
 *
 * The one EXTERNAL entry is ESQSHARED4_BlitBannerRowsForActiveField, called once
 * from esqshared4_p3_p0.s. It takes no arguments. Its `MOVEM.L D0/A0-A1` is
 * callee-save for an assembly caller, and that caller restores D0-D3/A0-A6 from
 * its own entry MOVEM immediately after the call, so nothing depends on this
 * function preserving them.
 *
 * LoadCopperColorWordsFromNibbleTable IS still register-argument, so it keeps the
 * convention through __asm. It is dead code in the shipped program, and is
 * restored anyway so the dead caller stays correct rather than merely unexecuted.
 *
 * The decode of an RGB nibble triplet is INLINED rather than called.
 * _ESQSHARED4_DecodeRgbNibbleTriplet clobbers D2 and does not restore it, and
 * SAS/C assumes D2 survives a call, so calling it from C would leak a damaged D2
 * to whoever called us.
 *
 * SASC-MISMATCH: unrolled-copy-emitted-larger
 *   summary: both sides are straight-line, but 6.51 needs more instructions per
 *            move than the original's `MOVE.L (A2)+,(A1)+` post-increment pair,
 *            so the emitted module is several times the original's size. That is
 *            inert -- it is code size, not work per move, and the timing is what
 *            matters here.
 *   tried:   the loop form, which is far smaller and TEARS THE SCREEN. Do not
 *            re-roll these loops to save space.
 *   retest:  a compiler that emits post-increment moves for a pointer walk.
 */
#include <exec/types.h>

extern long ESQSHARED4_InterleaveCopyBaseOffset;
extern long ESQSHARED4_InterleaveCopyTailOffsetCurrent;
extern long ESQPARS2_BannerCopySourceOffset;
extern long ESQPARS2_BannerCopyTailOffset;
extern long ESQSHARED_BlitAddressOffset;
extern long GCOMMAND_BannerRowByteOffsetCurrent;
extern long ESQPARS2_BannerRowCopySpanBytes;
extern long ESQPARS2_BannerRowCopyStrideBytes;
extern long ESQPARS2_ActiveCopperListSelectFlag;

extern UBYTE ESQ_CopperListBannerA[];
extern UBYTE ESQ_CopperListBannerB[];

/* Each holds a POINTER to a scratch raster. The original reads it as
 * LEA sym,A1 / MOVEA.L (A1),A0, which is the value at sym, not sym itself. */
extern UBYTE *ESQSHARED_BannerRowScratchRasterBase0;
extern UBYTE *ESQSHARED_BannerRowScratchRasterBase1;
extern UBYTE *ESQSHARED_BannerRowScratchRasterBase2;

extern UWORD ESQ_BannerColorSweepProgramA;
extern UWORD ESQ_BannerColorSweepProgramB;
extern UWORD ESQ_BannerColorSweepProgramA_AnchorColorWord;
extern UWORD ESQ_BannerColorSweepProgramB_AnchorColorWord;
extern UWORD ESQ_BannerColorSweepProgramA_TailColorWord;
extern UWORD ESQ_BannerColorSweepProgramB_TailColorWord;

#define ROW_STEP        0x20        /* interleaved row stride */
#define FIRST_SRC_STEP  0x20        /* source starts one row past the destination */
#define BANNER_SRC_STEP 0xb0        /* banner source starts 0xb0 past the destination */
#define STEPPED_GROUPS  15          /* groups between the first one and the tail */

/* Copy the three words a copper row carries, at +6, +10 and +14. */
/* THE ORIGINAL IS FULLY UNROLLED AND SO IS THIS, ON PURPOSE.
 *
 * `ESQSHARED4_CopyBannerRowsWithByteOffset` is 306 moves with ZERO branches --
 * no DBF, no BRA, no call. That is not an accident of a hand-written routine,
 * it is a DEADLINE. The chain reaches here from the vertical-blank interrupt
 * (_ESQ_TickGlobalCounters -> _ESQSHARED4_TickCopperAndBannerTransitions ->
 * this), and the copy has to finish before the raster reaches the banner. Three
 * scratch rasters times 17 rows times 18 moves is about 900 moves per field.
 *
 * A LOOP MISSES THAT DEADLINE AND THE SCREEN SHOWS IT. Written with `for`
 * loops, this file drew horizontal colour streaks through the grid time banner
 * slot labels -- the copy was still running when the display read the rows. The
 * logic was correct the whole time, which is why counting the moves, the
 * pointer steps, the source and destination order and every extern shape all
 * came back clean. Timing was the defect, and no byte comparison can see it.
 *
 * So the copies are MACROS, not functions: C89 has no `inline`, and 6.51 will
 * not inline a static across a call. A macro is the only way to get the
 * original's straight-line code out of C.
 */

/* Three copper row words, at +6, +10 and +14. The pointers do NOT advance;
 * the original addresses these with displacements and steps afterwards. */
#define COPY_ROW_WORDS(d, s)                                    \
    do {                                                        \
        *(UWORD *)((d) +  6) = *(UWORD *)((s) +  6);            \
        *(UWORD *)((d) + 10) = *(UWORD *)((s) + 10);            \
        *(UWORD *)((d) + 14) = *(UWORD *)((s) + 14);            \
    } while (0)

/* One banner row: a word then 17 longs, 70 bytes, both pointers advancing.
 * The original does this with `MOVE.W (A2)+,(A1)+` and 17 `MOVE.L (A2)+,(A1)+`. */
#define COPY_BANNER_ROW(d, s)                                   \
    do {                                                        \
        *(UWORD *)(d) = *(UWORD *)(s);                          \
        *(ULONG *)((d) +  2) = *(ULONG *)((s) +  2);   \
        *(ULONG *)((d) +  6) = *(ULONG *)((s) +  6);   \
        *(ULONG *)((d) + 10) = *(ULONG *)((s) + 10);   \
        *(ULONG *)((d) + 14) = *(ULONG *)((s) + 14);   \
        *(ULONG *)((d) + 18) = *(ULONG *)((s) + 18);   \
        *(ULONG *)((d) + 22) = *(ULONG *)((s) + 22);   \
        *(ULONG *)((d) + 26) = *(ULONG *)((s) + 26);   \
        *(ULONG *)((d) + 30) = *(ULONG *)((s) + 30);   \
        *(ULONG *)((d) + 34) = *(ULONG *)((s) + 34);   \
        *(ULONG *)((d) + 38) = *(ULONG *)((s) + 38);   \
        *(ULONG *)((d) + 42) = *(ULONG *)((s) + 42);   \
        *(ULONG *)((d) + 46) = *(ULONG *)((s) + 46);   \
        *(ULONG *)((d) + 50) = *(ULONG *)((s) + 50);   \
        *(ULONG *)((d) + 54) = *(ULONG *)((s) + 54);   \
        *(ULONG *)((d) + 58) = *(ULONG *)((s) + 58);   \
        *(ULONG *)((d) + 62) = *(ULONG *)((s) + 62);   \
        *(ULONG *)((d) + 66) = *(ULONG *)((s) + 66);   \
        (d) += 70;                                              \
        (s) += 70;                                              \
    } while (0)

void ESQSHARED4_CopyInterleavedRowWordsFromOffset(UBYTE *base)
{
    UBYTE *dst = base + ESQSHARED4_InterleaveCopyBaseOffset;
    UBYTE *src = dst + FIRST_SRC_STEP;

    COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);
    dst += ROW_STEP; src += ROW_STEP; COPY_ROW_WORDS(dst, src);

    dst += ROW_STEP;
    src = base + ESQSHARED4_InterleaveCopyTailOffsetCurrent;
    COPY_ROW_WORDS(dst, src);
}

void ESQSHARED4_CopyBannerRowsWithByteOffset(UBYTE *base)
{
    UBYTE *dst = base + ESQPARS2_BannerCopySourceOffset;
    UBYTE *src = dst + BANNER_SRC_STEP;
    long   step = ESQSHARED_BlitAddressOffset;

    COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);
    dst += step; src += step; COPY_BANNER_ROW(dst, src);

    dst += step;
    src = base + (GCOMMAND_BannerRowByteOffsetCurrent + ESQPARS2_BannerCopyTailOffset);
    COPY_BANNER_ROW(dst, src);
}

void ESQSHARED4_BlitBannerRowsForActiveField(void)
{
    long span = ESQPARS2_BannerRowCopySpanBytes;
    long stride = ESQPARS2_BannerRowCopyStrideBytes;
    UBYTE *list;

    if (ESQPARS2_ActiveCopperListSelectFlag == 0) {
        stride += 0x58;
        list = ESQ_CopperListBannerA;
    } else {
        list = ESQ_CopperListBannerB;
    }

    ESQPARS2_BannerCopyTailOffset = stride;
    ESQPARS2_BannerCopySourceOffset = span + stride;

    ESQSHARED4_CopyInterleavedRowWordsFromOffset(list);
    ESQSHARED4_CopyBannerRowsWithByteOffset(ESQSHARED_BannerRowScratchRasterBase0);
    ESQSHARED4_CopyBannerRowsWithByteOffset(ESQSHARED_BannerRowScratchRasterBase1);
    ESQSHARED4_CopyBannerRowsWithByteOffset(ESQSHARED_BannerRowScratchRasterBase2);
}

/* Dead in the shipped program -- see the header. Keeps the original's register
 * convention so the unreachable caller in esqshared4_p5.s stays correct.
 * slot steps 0, 4, 8 ... 28 and selects where each decoded colour word goes. */
void __asm ESQSHARED4_LoadCopperColorWordsFromNibbleTable(
        register __d3 short slot,
        register __a1 UBYTE *nibbles,
        register __a2 UBYTE *listA,
        register __a3 UBYTE *listB)
{
    short i;

    for (i = 0; i < 8; i++) {
        UWORD r = (UWORD)(nibbles[0] & 15);
        UWORD g = (UWORD)(nibbles[1] & 15);
        UWORD b = (UWORD)(nibbles[2] & 15);
        UWORD colour = (UWORD)(b + (g << 4) + (r << 8));

        nibbles += 3;

        if (slot == 4) {
            ESQ_BannerColorSweepProgramA = colour;
            ESQ_BannerColorSweepProgramB = colour;
            ESQ_BannerColorSweepProgramA_AnchorColorWord = colour;
            ESQ_BannerColorSweepProgramB_AnchorColorWord = colour;
        } else if (slot == 0x1c) {
            ESQ_BannerColorSweepProgramA_TailColorWord = colour;
            ESQ_BannerColorSweepProgramB_TailColorWord = colour;
        } else {
            *(UWORD *)(listA + slot) = colour;
            *(UWORD *)(listB + slot) = colour;
        }

        slot += 4;
    }
}
