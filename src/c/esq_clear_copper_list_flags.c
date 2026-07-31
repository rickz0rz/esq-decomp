/* RESTORES: ESQ_ClearCopperListFlags
 * MODULE:   modules/groups/a/a/app2_p2.s
 * STATUS:   behavioural
 *
 * 16 bytes against 18, in ONE region. Both stores agree instruction for
 * instruction; only the way the zero reaches D0 differs.
 *
 * SASC-MISMATCH: zero-into-register
 *   ref:     103c0000    MOVE.B #0,D0
 *   got:     7000        MOVEQ  #0,D0
 *   summary: -2 bytes, and that is the whole difference. Both leave 0 in D0
 *            and both stores that follow are byte stores, so the byte the
 *            program writes is the same. The original's compiler chose a
 *            byte-sized immediate move for a char-typed zero where SAS/C 6.51
 *            chooses MOVEQ.
 *   tried:   a `char` local set to 0 and stored twice reaches 20 bytes -- it
 *            costs a MOVE.L A7 save/restore pair to hold the local in D7 and
 *            still uses MOVEQ. `'\0'` and `(unsigned char)0` are the same 16.
 *            The a = b = 0 chain is already correct: it emits the single
 *            register load the original has, and separate statements would
 *            emit CLR twice.
 *   scope:   every restoration that zeroes a char global. Cheap to find:
 *            grep the reference for 103c0000.
 *   retest:  a compiler that does not fold a char zero to MOVEQ matches this
 *            byte for byte.
 */
extern unsigned char ESQ_CopperListBannerA;
extern unsigned char ESQ_CopperListBannerB;

void ESQ_ClearCopperListFlags(void)
{
    ESQ_CopperListBannerA = ESQ_CopperListBannerB = 0;
}
