/* RESTORES: _ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty
 * MODULE:   modules/groups/a/n/esqdispb_p0_p1_p0_p2.s
 * STATUS:   behavioural
 *
 * When the secondary group is EMPTY, copies every primary entry into it: one
 * `ESQSHARED_CreateGroupEntryAndTitle` per entry to make the record, then
 * `ESQDISP_FillProgramInfoHeaderFields` to fill its header from the primary.
 * The mirror flag is set on the way out, and cleared without doing anything
 * when the secondary group already holds entries.
 *
 * THE ORIGINAL PUSHES ELEVEN LONGS AND THE SECOND CALLEE READS SIX, which is
 * easy to misread as an eleven-argument function. It is not. The original never
 * pops the first call's six-long block. It overwrites the TOP slot with
 * `MOVE.L A2,(A7)`, pushes five more, calls, and then pops all 44 bytes at once
 * with `LEA 44(A7),A7`. The five slots below the second call's arguments are
 * dead leftovers from the first call. `ESQDISP_FillProgramInfoHeaderFields` is
 * already restored and takes six parameters, which is what settles it.
 *
 * Read the argument order from the PUSH order, remembering the last push is the
 * first parameter:
 *
 *   call 1  D0, D1, A1, A2, A3, A6
 *           = (secondary group code, entry[27], &entry[12], &entry[1],
 *              &entry[28], &entry[19])
 *   call 2  A1, D1, D0, D2, D3, and the reused slot
 *           = (new secondary entry, entry[40] & 0x7f, entry[46],
 *              entry[41], entry[42], &entry[43])
 *
 * The mask is `ANDI.W #$ff7f` on a zero-extended byte, so it clears bit 7 and
 * nothing else.
 *
 * The secondary entry the second call fills is the one the FIRST call just
 * created: the code re-reads `TEXTDISP_SecondaryGroupEntryCount` after the
 * call and indexes the pre-slot table with it.
 *
 * The struct tag is deliberately local to this file. Several other
 * restorations define `struct EsqDispEntry` with different members, and this
 * module holds one label so it never merges with them.
 *
 * SIZE: 208 reference against 200 emitted, and `tools/casm.py` attributes the
 * whole -8. The two classes below account for it.
 *
 * THE ARGUMENT-SLOT REUSE REPRODUCED EXACTLY, which is worth recording because
 * it looks like the kind of thing C cannot express. Writing the two calls
 * normally, 6.51 emits the original's `LEA 43(A5),A0` / `MOVE.L A0,(A7)` /
 * five pushes / `LEA 44(A7),A7` -- it keeps the first block and overwrites the
 * top slot, exactly as the original does. `casm.py` reports no hunk there. An
 * earlier draft of this header claimed a divergence here and was wrong.
 *
 * SASC-MISMATCH: char-widen-move-width
 *   ref:     7000 1028001b        MOVEQ #0,D0 / MOVE.B 27(A0),D0
 *   got:     102d001b 4880 48c0   MOVE.B 27(A5),D0 / EXT.W D0 / EXT.L D0
 *   summary: widening a byte field to a long. The original clears the register
 *            first and then moves the byte in. 6.51 moves the byte and sign-
 *            extends twice. Both leave the same value for an unsigned source.
 *            Four sites here, worth -2 to -12 bytes each.
 *   tried:   `unsigned char` fields, which is already what this file uses.
 *   scope:   program-wide, every byte field widened to a parameter.
 *   retest:  a compiler that emits the MOVEQ-then-MOVE.B pair.
 *
 * SASC-MISMATCH: dead-store-to-frame-slot
 *   ref:     2b49fff8            MOVE.L A1,-8(A5)
 *   got:     (nothing)
 *   summary: the original saves the new secondary entry pointer into a frame
 *            slot that NOTHING in the function reads. It is dead in the
 *            original. Reproducing it would need a local that is written and
 *            never used, which SAS/C removes.
 *   tried:   nothing. Recorded so the -4 is attributed rather than unexplained.
 *   scope:   4 bytes here.
 *   retest:  a compiler that keeps a provably dead store.
 */
struct EsqDispMirrorEntry {
    char           pad0;        /* +0  */
    char           f1[11];      /* +1  */
    char           f12[7];      /* +12 */
    char           f19[8];      /* +19 */
    unsigned char  f27;         /* +27 */
    char           f28[12];     /* +28 */
    unsigned char  f40;         /* +40 */
    unsigned char  f41;         /* +41 */
    unsigned char  f42;         /* +42 */
    char           f43[3];      /* +43 */
    short          w46;         /* +46 */
};

extern short TEXTDISP_PrimaryGroupEntryCount;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern unsigned char TEXTDISP_SecondaryGroupCode;
extern short ESQDISP_PrimarySecondaryMirrorFlag;
extern struct EsqDispMirrorEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern char *TEXTDISP_SecondaryEntryPtrTablePreSlot[];

extern void ESQSHARED_CreateGroupEntryAndTitle(char groupCode, char entryFlag,
                                               char *f0, char *f1, char *f2,
                                               char *f3);
extern void ESQDISP_FillProgramInfoHeaderFields(char *entry, char kind,
                                                short value, char flag41,
                                                char flag42, char *src);

void ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty(void)
{
    struct EsqDispMirrorEntry *e;
    char *made;
    long  i;

    if (TEXTDISP_SecondaryGroupEntryCount != 0) {
        ESQDISP_PrimarySecondaryMirrorFlag = 0;
        return;
    }

    for (i = 0; i < (long)TEXTDISP_PrimaryGroupEntryCount; i++) {
        e = TEXTDISP_PrimaryEntryPtrTable[i];

        ESQSHARED_CreateGroupEntryAndTitle((char)TEXTDISP_SecondaryGroupCode,
                                           (char)e->f27,
                                           e->f12, e->f1, e->f28, e->f19);

        made = TEXTDISP_SecondaryEntryPtrTablePreSlot[
                   TEXTDISP_SecondaryGroupEntryCount];

        ESQDISP_FillProgramInfoHeaderFields(made,
                                            (char)(e->f40 & 0x7f),
                                            e->w46,
                                            (char)e->f41,
                                            (char)e->f42,
                                            e->f43);
    }

    ESQDISP_PrimarySecondaryMirrorFlag = 1;
}
