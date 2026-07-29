/* RESTORES: GCOMMAND_TickPresetWorkEntries
 * MODULE:   modules/groups/a/u/gcommand3b_p2_gcommand_tickpresetworkentries.s
 * STATUS:   behavioural
 *
 * Advances the four preset work entries by one tick each. An entry with a delay
 * still to run only counts that delay down. Any other entry adds its step to a
 * fixed-point accumulator, then carries every whole 1000 into the value. It
 * stops itself: once the value passes the limit, the step becomes 0.
 *
 * The accumulator holds thousandths, so the carry loop is a repeated subtract
 * rather than a divide. It cannot run away. The step is positive and below the
 * limit test, so only a few carries happen per tick.
 *
 * The code skips an entry that already reached its limit before it does any
 * work. That is why the limit is tested twice, once to skip and once to clamp.
 *
 * 116 bytes against 132. tools/casm.py attributes ALL 16 bytes to the single
 * divergence below. There is no structural disagreement anywhere in the body.
 * Every field access folds into the same (d16,An) displacement as the original.
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     2b7c0000b26cfffc  MOVE.L #table,-4(A5), then MOVEA.L -4(A5),A0
 *                              reloaded at each of the three loop heads, and
 *                              advanced with MOVEQ #24,D0 / ADD.L D0,-4(A5)
 *   got:     4bf900000000      LEA table,A5, kept in the register throughout,
 *                              and advanced with ADDA.W #24,A5
 *   summary: the original holds the cursor in a frame slot behind LINK A5,#-8.
 *            It reloads the cursor whenever control rejoins. 6.51 allocates it
 *            to an address register, which removes the frame, the three reloads,
 *            and the scratch register that advances it. Same class as
 *            gcommand_find_path_separator.c.
 *   tried:   nothing source-side. The address of the local is never taken, so
 *            no legal C form asks for the spill.
 *   scope:   program-wide. See gcommand_find_path_separator.c for the list.
 *   retest:  tools/mismatches.py --recheck on a compiler that spills the local.
 */
struct PresetWorkEntry {
    long unused;    /*  0 */
    long limit;     /*  4 */
    long value;     /*  8 */
    long step;      /* 12 */
    long accum;     /* 16 */
    long delay;     /* 20 */
};

extern struct PresetWorkEntry GCOMMAND_PresetWorkEntryTable[];

void GCOMMAND_TickPresetWorkEntries(void)
{
    struct PresetWorkEntry *e;
    long i;

    i = 0;
    e = GCOMMAND_PresetWorkEntryTable;
    while (i < 4) {
        if (e->delay != 0)
            e->delay -= 1;
        else if (e->step > 0 && e->value < e->limit) {
            e->accum += e->step;
            while (e->accum >= 1000) {
                e->value += 1;
                e->accum -= 1000;
            }
            if (e->value > e->limit) {
                e->step = 0;
                e->value = e->limit;
            }
        }
        i++;
        e++;
    }
}
