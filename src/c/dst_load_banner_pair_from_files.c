/* RESTORES: DST_LoadBannerPairFromFiles
 * MODULE:   modules/groups/a/j/dst_p2.s
 * STATUS:   behavioural
 *
 * Rebuilds the banner pair, loads the .dat file, and pulls a date pair out of
 * each of the two tagged sections in it.
 *
 * The two sections are found by SUBSTRING SEARCH for "G2" and "G3", and the
 * offsets 4 and 19 are relative to whatever the search returned -- so a missing
 * tag simply skips that half rather than failing the whole load.
 *
 * The two halves target DIFFERENT members: "G2" fills the record at +4 of the
 * pair and "G3" the one at +0. That is the same reversal
 * datetime_save_pair_to_file.c writes out, and it is what makes the two round-
 * trip.
 *
 * The SECOND search starts from the ORIGINAL buffer, not from where the first
 * one stopped -- the original reloads -48(A5), which it stamped before the
 * first search. So "G3" may appear before "G2" in the file.
 *
 * The work buffer is freed with length + 1, taken from the length that was
 * saved BEFORE the parsing; the parse can move Global_REF_LONG_FILE_SCRATCH.
 *
 * A failed load returns 0 without freeing anything, because nothing was
 * allocated.
 *
 * 236 ref vs 232 got. Both substring searches, all four parse calls with their
 * PEA 4 / PEA 19 offsets, both recalculate calls, both LEA 36(A7),A7 cleanups,
 * the ADDQ.L #1 free length, the PEA 889 line number and the closing queue
 * update match in kind and size -- including the fact that the second search
 * restarts from the ORIGINAL buffer.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffc8 ... 2b48ffd0 ... 2f2dffd0 ... 4e5d
 *            LINK.W A5,#-56 / spill the buffer / push it back / UNLK
 *   got:     9efc002c ... 2f0b        the buffer stays in an address register
 *   summary: the frame class, and 6.51 takes 44 bytes of stack where the
 *            original takes 56 -- the original reserves two extra longwords for
 *            the buffer and the found pointer that 6.51 keeps in registers.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct DateTimePair {
    char *first;                /* +0 */
    char *second;               /* +4 */
    long  firstSeconds;
    long  secondSeconds;
};

struct DstBannerPair {
    struct DateTimePair *g3;    /* +0 */
    struct DateTimePair *g2;    /* +4 */
};

extern void  DST_RebuildBannerPair(struct DstBannerPair *p);
extern long  DISKIO_LoadFileToWorkBuffer(char *path);
extern char *STRING_FindSubstring(char *hay, char *needle);
extern void  DATETIME_ParseString(char *out, char *text, long offset);
extern void  DATETIME_CopyPairAndRecalc(struct DateTimePair *p, char *a,
                                        char *b);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                     void *p, long size);
extern long  DST_UpdateBannerQueue(struct DstBannerPair *p);

extern char *DST_DefaultDatPathPtr;
extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;
extern char  Global_STR_G2[];
extern char  Global_STR_G3[];
extern char  Global_STR_DST_C_7[];

long DST_LoadBannerPairFromFiles(struct DstBannerPair *pair)
{
    char *buf;
    char *found;
    char  a[22];
    char  b[22];
    long  len;

    DST_RebuildBannerPair(pair);

    if (DISKIO_LoadFileToWorkBuffer(DST_DefaultDatPathPtr) == -1)
        return 0;

    buf = Global_PTR_WORK_BUFFER;
    len = Global_REF_LONG_FILE_SCRATCH;

    found = STRING_FindSubstring(buf, Global_STR_G2);
    if (found != 0) {
        DATETIME_ParseString(a, found, 4L);
        DATETIME_ParseString(b, found, 19L);
        DATETIME_CopyPairAndRecalc(pair->g2, a, b);
    }

    found = STRING_FindSubstring(buf, Global_STR_G3);
    if (found != 0) {
        DATETIME_ParseString(a, found, 4L);
        DATETIME_ParseString(b, found, 19L);
        DATETIME_CopyPairAndRecalc(pair->g3, a, b);
    }

    MEMORY_DeallocateMemory(Global_STR_DST_C_7, 889L, buf,
                                            len + 1);
    DST_UpdateBannerQueue(pair);
    return 1;
}
