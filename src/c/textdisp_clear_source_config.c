/* RESTORES: TEXTDISP_ClearSourceConfig
 * MODULE:   modules/groups/b/a/textdisp_p2_p1.s
 * STATUS:   behavioural
 *
 * Releases every source-config record, clears its table slot, and resets the
 * count and the flag mask.
 *
 * The record is 6 bytes -- a name pointer and a flag byte, which is the layout
 * textdisp_apply_source_config_to_entry.c models -- and that is the size the
 * free is given.
 *
 * A null slot is SKIPPED ENTIRELY: the BEQ at 0x2C1EC lands on the counter
 * bump, past the clear as well as past the free.
 *
 * The count and the mask are reset AFTER the loop, and the mask is a byte
 * (CLR.B) where the count is a long.
 *
 * The original recomputes the table index THREE TIMES per iteration (three
 * separate ASL.L #2 / LEA / ADDA.L runs) rather than holding the address, and
 * it also parks the record pointer in a stack slot across the replace call.
 * Both are the reserved-A5 property; the C below indexes the table each time,
 * which is the source form that produces them.
 *
 * 138 ref vs 124 got. All three ASL.L #2 index recomputations, the PEA 6 record
 * size, the PEA 1153 line number, the LEA 24(A7),A7 cleanup, the CLR.L of the
 * slot and the closing CLR.L / CLR.B pair match exactly.
 *
 * SASC-MISMATCH: link-frame-and-spill
 *   ref:     4e55fff8 ... 2451 2f4a0014 ... 206f0014 2080 ... 4e5d
 *            LINK / MOVEA.L (A1),A2 / MOVE.L A2,20(A7) / reload / store
 *   got:     2480                 MOVE.L D0,(A2) straight
 *   summary: the original loads the record pointer into A2, ALSO writes it into
 *            a stack slot, and reloads it from there after the call just to
 *            store the result. 6.51 keeps A2 live across the call. The frame
 *            plus the store and reload is the 14 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#ifndef TEXTDISPSOURCECONFIG_DEFINED
#define TEXTDISPSOURCECONFIG_DEFINED
struct TextDispSourceConfig {
    char         *name;         /* +0 */
    unsigned char bits;         /* +4, record is 6 bytes */
};
#endif

extern char *ESQPARS_ReplaceOwnedString(char *newStr, char *old);
extern void  MEMORY_DeallocateMemory(char *who, long line, void *p, long size);

extern long TEXTDISP_SourceConfigEntryCount;
extern unsigned char TEXTDISP_SourceConfigFlagMask;
extern struct TextDispSourceConfig *TEXTDISP_SourceConfigEntryTable[];
extern char Global_STR_TEXTDISP_C_3[];

void TEXTDISP_ClearSourceConfig(void)
{
    long i;

    for (i = 0; i < TEXTDISP_SourceConfigEntryCount; i++) {
        if (TEXTDISP_SourceConfigEntryTable[i] != 0) {
            TEXTDISP_SourceConfigEntryTable[i]->name =
                ESQPARS_ReplaceOwnedString(
                    0, TEXTDISP_SourceConfigEntryTable[i]->name);

            MEMORY_DeallocateMemory(Global_STR_TEXTDISP_C_3, 1153L,
                                    TEXTDISP_SourceConfigEntryTable[i], 6L);

            TEXTDISP_SourceConfigEntryTable[i] = 0;
        }
    }

    TEXTDISP_SourceConfigEntryCount = 0;
    TEXTDISP_SourceConfigFlagMask = 0;
}
