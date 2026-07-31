/* RESTORES: DISKIO_LoadConfigFromDisk
 * MODULE:   modules/groups/a/g/diskio_p5_p0.s
 * STATUS:   behavioural
 *
 * Loads the config file into the work buffer, parses it, frees the buffer, and
 * answers 0 for success or -1 for a load failure.
 *
 * The failure test is ADDQ.L #1,D0 / BNE, so the sentinel is -1 rather than 0 --
 * a zero-length file is a success here.
 *
 * The length passed to both the parser and the free is
 * Global_REF_LONG_FILE_SCRATCH + 1, the NUL included. The original computes it
 * TWICE, once from the global for the parse and once from the copy it saved in
 * D7 for the free, which is why the source keeps a local copy of the length: the
 * parse can change the global.
 *
 * 100 ref vs 88 got. The ADDQ.L #1 / BNE sentinel test, both length
 * computations, the argument-slot reuse (2e80), the PEA 1344 and the
 * LEA 20(A7),A7 cleanup all match exactly.
 *
 * SASC-MISMATCH: link-frame-and-spill
 *   ref:     4e55fff4 ... 2b48fffc ... 2f2dfffc ... 4e5d
 *            LINK.W A5,#-12 / MOVE.L A0,-4(A5) / MOVE.L -4(A5),-(A7) / UNLK
 *   got:     ... 2f0d              the buffer pointer stays in an address register
 *   summary: the original spills the work-buffer pointer to a frame slot across
 *            the parse call and pushes it back from there; 6.51 keeps it in a
 *            register throughout. The frame, the store and the wider push are
 *            the 12 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: zero-through-register-vs-moveq
 *   ref:     7cff / 7c00 2006      MOVEQ #-1,D6 / MOVEQ #0,D6 / MOVE.L D6,D0
 *   got:     70ff / 7000           MOVEQ #-1,D0 / MOVEQ #0,D0
 *   summary: the original builds both results in a saved register and copies to
 *            D0 at the end; 6.51 writes D0 directly. Same two constants.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern long  DISKIO_LoadFileToWorkBuffer(char *path);
extern void  DISKIO_ParseConfigBuffer(char *buf, long len);
extern void  GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                     void *p, long size);

extern long  Global_REF_LONG_FILE_SCRATCH;
extern char *Global_PTR_WORK_BUFFER;
extern char  Global_STR_DF0_CONFIG_DAT_2[];
extern char  Global_STR_DISKIO_C_9[];

long DISKIO_LoadConfigFromDisk(void)
{
    char *buf;
    long  len;

    if (DISKIO_LoadFileToWorkBuffer(Global_STR_DF0_CONFIG_DAT_2) == -1)
        return -1;

    len = Global_REF_LONG_FILE_SCRATCH;
    buf = Global_PTR_WORK_BUFFER;

    DISKIO_ParseConfigBuffer(buf, Global_REF_LONG_FILE_SCRATCH + 1);

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO_C_9, 1344L, buf,
                                            len + 1);
    return 0;
}
