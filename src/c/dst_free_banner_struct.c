/* RESTORES: DST_FreeBannerStruct
 * MODULE:   modules/groups/a/j/dst.s
 * STATUS:   behavioural
 *
 * Frees a banner record: two optional 22-byte date buffers, then the 18-byte
 * record itself.
 *
 * The sizes are not guessed. Each free passes its own literal -- PEA 22 for
 * both buffers, PEA 18 for the record -- so the record is 18 bytes and holds
 * two pointers with 10 bytes after them.
 *
 * The two buffer pointers are NOT cleared after their frees. The record is
 * about to be freed itself, so there is nothing to clear them for, and adding
 * the stores would be inventing work the original does not do.
 *
 * The three source-line arguments (773, 777, 779) and the three distinct
 * file-name strings are literals in the original and are reproduced exactly.
 *
 * 98 ref vs 96 got. All three PEA size literals, all three line numbers and all
 * three LEA 16(A7),A7 cleanups match exactly.
 *
 * SASC-MISMATCH: reload-vs-cse
 *   ref:     4aab0004 ... 2f2b0004    TST.L 4(A3) / ... / MOVE.L 4(A3),-(A7)
 *   got:     202d0004 ... 2f00        MOVE.L 4(A5),D0 / ... / MOVE.L D0,-(A7)
 *   summary: the original re-reads the field to push it after testing it; 6.51
 *            pushes the register it already tested. 2 bytes at the second site,
 *            which is the whole delta. Same class as disptext_free_buffers.c,
 *            and volatile is rejected there for the same reason.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     2f0b 266f0008 ... 265f   MOVE.L A3,-(A7) / MOVEA.L 8(A7),A3 / pop
 *   got:     2f0d 2a6f0008 ... 2a5f   the same three against A5
 *   summary: same instructions, same sizes, one register apart.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 */
struct DstBanner {
    char *first;                /* +0  */
    char *second;               /* +4  */
    char  rest[10];             /* +8, to 18 */
};

extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                    void *p, long size);
extern char Global_STR_DST_C_1[];
extern char Global_STR_DST_C_2[];
extern char Global_STR_DST_C_3[];

void DST_FreeBannerStruct(struct DstBanner *b)
{
    if (b == 0)
        return;

    if (b->first)
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DST_C_1, 773L,
                                                b->first, 22L);
    if (b->second)
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DST_C_2, 777L,
                                                b->second, 22L);

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DST_C_3, 779L, b, 18L);
}
