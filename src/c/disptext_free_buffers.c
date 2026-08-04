/* RESTORES: DISPTEXT_FreeBuffers
 * MODULE:   modules/groups/a/i/disptext_p1.s
 * STATUS:   behavioural
 *
 * Releases the two 1000-byte display buffers, each guarded by its own pointer
 * and cleared after the free.
 *
 * The two source-line arguments the tracking allocator records (338 and 343)
 * are literals in the original and are reproduced exactly; so are the two
 * distinct file-name strings.
 *
 * 90 ref vs 84 got. Both PEA 1000, both line numbers, both LEA 16(A7),A7
 * cleanups and both CLR.L stores match exactly.
 *
 * SASC-MISMATCH: reload-vs-cse
 *   ref:     4ab900008156 ... 2f3900008156   TST.L global / ... / MOVE.L global,-(A7)
 *   got:     203900000000 ... 2f00           MOVE.L global,D0 / ... / MOVE.L D0,-(A7)
 *   summary: the original tests the pointer and then RE-READS it from memory to
 *            push as an argument. 6.51 loads it once, tests the loaded value
 *            and pushes the register. Same pointer -- nothing between the two
 *            points can change the global. The saved re-read is 4 bytes at each
 *            of the two sites, which is the whole delta.
 *   tried:   declaring the two globals `volatile` would force the re-read and
 *            close this. REJECTED: volatile in this project means "the value
 *            can change under us", which is true of a library base and is not
 *            true here. Spending the keyword to buy 8 bytes would put a false
 *            statement in the source, and esq-libbase.md is explicit that the
 *            volatile in the headers is a correctness fix rather than a
 *            codegen lever.
 *   scope:   anywhere a global pointer is tested and then passed. Same class as
 *            textdisp_draw_next_entry_preview.c.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void  DISPLIB_ResetTextBufferAndLineTables(void);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                     void *p, long size);
extern void *Global_REF_1000_BYTES_ALLOCATED_1;
extern void *Global_REF_1000_BYTES_ALLOCATED_2;
extern char  Global_STR_DISPTEXT_C_4[];
extern char  Global_STR_DISPTEXT_C_5[];

void DISPTEXT_FreeBuffers(void)
{
    DISPLIB_ResetTextBufferAndLineTables();

    if (Global_REF_1000_BYTES_ALLOCATED_1) {
        MEMORY_DeallocateMemory(Global_STR_DISPTEXT_C_4, 338L,
                                                Global_REF_1000_BYTES_ALLOCATED_1,
                                                1000L);
        Global_REF_1000_BYTES_ALLOCATED_1 = 0;
    }

    if (Global_REF_1000_BYTES_ALLOCATED_2) {
        MEMORY_DeallocateMemory(Global_STR_DISPTEXT_C_5, 343L,
                                                Global_REF_1000_BYTES_ALLOCATED_2,
                                                1000L);
        Global_REF_1000_BYTES_ALLOCATED_2 = 0;
    }
}
