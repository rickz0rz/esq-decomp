/* RESTORES: ESQSHARED4_CopyLivePlanesToSnapshot
 * MODULE:   modules/groups/a/q/esqshared4_esqshared4_copylongwordblockdbfloop_esqshared4_copylongwordblockdbfloop_esqshared4_copyliveplanestosnapshot.s
 *           (1 of its 2 labels)
 * STATUS:   behavioural
 *
 * Copies the three live bitplanes into the banner snapshot buffers. It is on
 * the highlight path: gcommand_service_highlight_messages.c calls it twice.
 *
 * THE COUNT IS 44 LONGWORDS, NOT 43. `MOVE.L #$2b,D1` then DBF runs the body
 * once for each value from 43 down to 0 inclusive, so 44 moves of 4 bytes --
 * 176 bytes per plane. Writing the loop as `while (n--)` from 44 reproduces
 * that; writing `for (i = 0; i < 0x2b; i++)` would copy one longword short and
 * leave the last four bytes of every plane stale.
 *
 * THE DESTINATIONS ARE A WALKED ARRAY OF THREE POINTERS. The original loads
 * `LEA _ESQPARS2_BannerSnapshotPlane0DstPtr,A2` once and then takes three
 * pointers with `MOVEA.L (A2)+`, so the Plane1 and Plane2 destinations are read
 * from the two longwords that FOLLOW Plane0's symbol. The sources are three
 * separate symbols, each loaded with its own LEA. The asymmetry is the
 * original's, not a transcription slip.
 *
 * THE THIRD COPY LOOP IS ESQSHARED4_CopyLongwordBlockDbfLoop, and the original
 * reaches it by FALLING INTO IT -- the label sits on the loop's first
 * instruction, and the loop runs on into this function's own MOVEM epilogue.
 * So the call below is not an approximation of the fall-through, it is the same
 * loop reached by the one mechanism C has. It costs the call and one stack
 * frame; nothing else about the third plane's copy changes.
 *
 * Writing it as a call rather than a third copy in place is also what lets
 * merge_module_c.py join the module: the bridge check requires the call to be
 * the LAST statement, which it is. See ed1_enter_esc_menu.c for the full note
 * on bridging a fall-through.
 *
 * SASC-MISMATCH: no-postincrement-longword-copy
 *   ref:     28db51c9fffc   MOVE.L (A3)+,(A4)+ / DBF D1
 *   got:     a pointer pair walked with explicit adds, and a compare-and-branch
 *            instead of DBF
 *   summary: SAS/C 6.51 emits neither the double post-increment move nor DBF,
 *            so each of the three loops costs a few bytes more. The work per
 *            move and the number of moves are the same.
 *   scope:   every longword block copy in the program.
 *   retest:  a compiler that pairs post-increment operands and uses DBF.
 */
extern long *ESQSHARED_LivePlaneBase0;
extern long *ESQSHARED_LivePlaneBase1;
extern long *ESQSHARED_LivePlaneBase2;
extern long *ESQPARS2_BannerSnapshotPlane0DstPtr[];

extern void ESQSHARED4_CopyLongwordBlockDbfLoop(long *dst, long *src, short count);

void ESQSHARED4_CopyLivePlanesToSnapshot(void)
{
    long **dst = ESQPARS2_BannerSnapshotPlane0DstPtr;
    long *src;
    long *out;
    short n;

    src = ESQSHARED_LivePlaneBase0;
    out = *dst++;
    n = 0x2b;
    do { *out++ = *src++; } while (n--);

    src = ESQSHARED_LivePlaneBase1;
    out = *dst++;
    n = 0x2b;
    do { *out++ = *src++; } while (n--);

    /* The third loop IS ESQSHARED4_CopyLongwordBlockDbfLoop, which the original
     * falls into. See the header. */
    src = ESQSHARED_LivePlaneBase2;
    out = *dst++;
    ESQSHARED4_CopyLongwordBlockDbfLoop(out, src, 0x2b);
}
