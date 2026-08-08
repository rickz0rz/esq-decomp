/* RESTORES: _GCOMMAND_ValidatePresetTable
 * MODULE:   modules/groups/a/u/gcommand3b_p0_gcommand_validatepresettable.s
 * STATUS:   behavioural
 * Validates a working preset table. If every row passes, the table is copied
 * over the DEFAULT table under Disable/Enable, the reset flag is raised and the
 * banner bounds are refreshed.
 *
 * THE COPY RUNS FROM THE WORKING TABLE TO THE DEFAULT TABLE, not the other way
 * round. The original loads `MOVEA.L A3,A0` and `LEA _GCOMMAND_DefaultPresetTable,A1`,
 * and AmigaOS CopyMem takes source in A0 and destination in A1. So a validated
 * table becomes the new default. Reading this backwards would silently discard
 * the user's presets on every validation.
 *
 * TABLE LAYOUT, derived from the addressing and confirmed by the copy size.
 * The outer loop reads a count at `0(A3,i*2)` and the inner loop reads a value
 * at `A3 + i*128 + j*2 + 32`. That gives 16 counts in the first 32 bytes,
 * followed by 16 rows of 128 bytes:
 *
 *     count[16]      +0     32 bytes
 *     value[16][64]  +32    2048 bytes
 *                           ----
 *                           2080 = 0x820
 *
 * 0x820 is exactly the length the original passes to CopyMem, which is what
 * confirms the layout rather than merely fitting it.
 *
 * VALIDITY. A row is valid when its count is greater than 1 and 0x40 or less,
 * and when every value in the row is below 0x1000. Both loops stop early
 * through the same `valid` flag rather than by branching out, which is why the
 * original tests `TST.L D5` at the top of each.
 *
 * SIZE: the reference reads 188 bytes because the epilogue carries its own
 * `_Return` label. Add the 6-byte `MOVEM.L (A7)+,D5-D7/A3` / `RTS` for a true
 * reference of 194, against 188 emitted. THE 6-BYTE DEFICIT IS FULLY
 * ATTRIBUTED: it is the dead lower-bound test recorded below, and nothing else.
 *
 * Two further classes appear and both are already known program-wide, so they
 * are noted here rather than given their own blocks: the original reaches the
 * copy length as `MOVE.L #$820,D0` where 6.51 emits `MOVEQ #$41` / `LSL.L #5`
 * (same value, same 6 bytes), and the original loads the exec base from
 * absolute 4 (`2c780004`) where 6.51 reads the `_SysBase` global. The register
 * allocation differs throughout in the usual A3-versus-A5 way.
 *
 * SASC-MISMATCH: dead-lower-bound-test
 *   ref:     0c68 0000 0020 6500     CMPI.W #0,32(A0) / BCS
 *   got:     (nothing -- the test is absent)
 *   summary: the original tests each value against 0 with an UNSIGNED branch,
 *            which can never be taken. The test is dead in the original too.
 *            Keeping it would need a local holding 0 rather than a literal --
 *            see the zero-local rule in AGENTS.md -- and this file does not
 *            bother, because the byte match is out of reach anyway on the
 *            A5-frame class.
 *   tried:   nothing. Recorded so the deficit is attributed rather than
 *            unexplained.
 *   scope:   6 bytes here.
 *   retest:  write the bound through a zero local if this file is ever pushed
 *            for an exact match.
 */
#include "esq-exec.h"

#ifndef GCOMMANDPRESETTABLE_DEFINED
#define GCOMMANDPRESETTABLE_DEFINED
struct GcommandPresetTable {
    unsigned short count[16];       /* +0    one count per row */
    unsigned short value[16][64];   /* +32   16 rows of 128 bytes */
};
#endif

extern short GCOMMAND_PresetWorkResetPendingFlag;
/* An ARRAY, not a scalar. The original only ever takes this symbol's ADDRESS
 * (`LEA _GCOMMAND_DefaultPresetTable,A1`), so the symbol IS the table.
 * Declaring it as a scalar object and passing `&` of it reads one dereference
 * too deep, and `tools/data_shape_audit.py` rejects the build for it. */
extern struct GcommandPresetTable GCOMMAND_DefaultPresetTable[];
extern void GCOMMAND_UpdateBannerBounds(long left, long top, long right,
                                        long bottom);

void GCOMMAND_ValidatePresetTable(struct GcommandPresetTable *table)
{
    long valid;
    long row;
    long slot;

    valid = 1;
    row   = 0;

    while (valid && row < 16) {
        if (table->count[row] > 1 && table->count[row] <= 0x40)
            valid = 1;
        else
            valid = 0;

        slot = 0;
        while (valid && slot < (long)table->count[row]) {
            if (table->value[row][slot] < 0x1000)
                valid = 1;
            else
                valid = 0;
            slot++;
        }
        row++;
    }

    if (valid == 0)
        return;

    Disable();
    CopyMem((char *)table, (char *)GCOMMAND_DefaultPresetTable, 0x820L);
    GCOMMAND_PresetWorkResetPendingFlag = 1;
    GCOMMAND_UpdateBannerBounds(0L, 5L, 6L, 0L);
    Enable();
}
