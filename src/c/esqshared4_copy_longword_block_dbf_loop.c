/* RESTORES: ESQSHARED4_CopyLongwordBlockDbfLoop
 * MODULE:   modules/groups/a/q/esqshared4_esqshared4_copylongwordblockdbfloop_esqshared4_copylongwordblockdbfloop_esqshared4_copyliveplanestosnapshot.s
 *           (1 of its 2 labels)
 * STATUS:   behavioural
 *
 * THIS LABEL IS NOT A FUNCTION IN THE ORIGINAL. It is the top of the THIRD copy
 * loop inside ESQSHARED4_CopyLivePlanesToSnapshot, reached by falling into it
 * with A3, A4 and D1 already set, and its body runs on into that function's
 * MOVEM epilogue -- an epilogue restoring registers this block never saved. The
 * label exists because the DBF at the bottom of the loop needs a target, and
 * the disassembly exported it.
 *
 * NOTHING REACHES IT AS A FUNCTION. A grep over src/modules, src/data and src/c
 * finds one reference: the DBF inside its own body. There is no BSR, no JSR, no
 * jump-table thunk and no C call.
 *
 * IT IS REACHED AS A FUNCTION IN THE C BUILD, and only there.
 * esqshared4_copy_live_planes_to_snapshot.c writes its third plane copy as a
 * CALL to this function, because that is what the fall-through means and C has
 * no other way to say it. So the definition below is live in the maximum-C
 * build and unreachable in the original.
 *
 * IT IS OTHERWISE A DELIBERATE ANALOGUE AND NOT A TRANSCRIPTION, and it is the one
 * label in this cluster where that is true. The C below is a self-contained
 * copy loop with an ordinary prologue, its arguments on the stack, and its own
 * return -- none of which the original has. It is written so that the symbol
 * exists, the module can leave assembly, and a reader who follows the name
 * arrives at code that does what the loop does. It is NOT the original's
 * fourteen bytes and could not be: an interior label sharing another function's
 * frame and epilogue has no C form, which is why coverage.py screens the shape
 * out as `interior-label`.
 *
 * The live third loop is inside esqshared4_copy_live_planes_to_snapshot.c,
 * written out in place, so nothing depends on this definition being reached.
 *
 * SASC-MISMATCH: not-a-callable-function
 *   ref:     28db51c9fffc4cdf1f034e75   (12, and 6 of those are the shared
 *            epilogue that belongs to the enclosing function)
 *   summary: the original is a two-instruction loop entered with its operands
 *            in registers and left through somebody else's MOVEM. The C form
 *            is a whole function. The copy itself agrees; nothing around it
 *            does.
 *   scope:   one label. coverage.py screens this shape as interior-label.
 *   retest:  nothing to retest. No compiler emits a function that returns
 *            through another function's epilogue.
 */
void ESQSHARED4_CopyLongwordBlockDbfLoop(long *dst, long *src, short count)
{
    do {
        *dst++ = *src++;
    } while (count--);
}
