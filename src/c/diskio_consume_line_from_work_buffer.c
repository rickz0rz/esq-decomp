/* RESTORES: DISKIO_ConsumeLineFromWorkBuffer
 * MODULE:   modules/groups/a/g/diskio_p3.s
 * STATUS:   behavioural
 *
 * Terminates the current line in the shared work buffer and steps the buffer
 * cursor past the line separator. Returns the start of the line, or -1 when
 * the byte budget in Global_REF_LONG_FILE_SCRATCH ran out.
 *
 * The trailing CR/LF skip loop does NOT re-test the byte budget. That is what
 * the original does. It decrements the budget inside the loop, but it never
 * reads the budget again.
 *
 * Sibling of DISKIO_ConsumeCStringFromWorkBuffer and it carries the same
 * divergence class.
 *
 * 140 bytes against 130.
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fffc 2b7900008004fffc ... 202dfffc 4e5d
 *   got:     48e70104 2a790000000000   ... 200d     4cdf2080
 *   summary: the original holds the returned line start in -4(A5) behind a
 *            LINK A5,#-4. SAS/C 6.51 allocates it to A2 and emits no frame.
 *            Same class as gcommand_find_path_separator.c.
 *   tried:   nothing source-side. The address of the local is never taken.
 *   scope:   program-wide. See gcommand_find_path_separator.c for the list.
 *   retest:  tools/mismatches.py --recheck on a compiler that spills the local.
 *
 * SASC-MISMATCH: word-immediate-pointer
 *   ref:     307cffff       MOVEA.W #-1,A0    (4 bytes, sign-extends)
 *   got:     207c0000ffff   MOVEA.L #$FFFF,A0 (6 bytes)
 *   summary: the error return is the same value either way. Every caller tests
 *            it only for non-NULL, and both the sign-extended -1 and the literal
 *            0xFFFF pass that test. (char *)-1 emits a 6-byte MOVEA.L #-1, so
 *            no spelling reaches 4 bytes.
 *   tried:   (char *)-1, (char *)0xFFFF, (char *)(short)-1.
 *   scope:   both DISKIO consume routines.
 *   retest:  a compiler that narrows a small pointer constant to MOVEA.W.
 */
extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;

char *DISKIO_ConsumeLineFromWorkBuffer(void)
{
    char *start = Global_PTR_WORK_BUFFER;
    long  c;

    while (Global_REF_LONG_FILE_SCRATCH-- > 0) {
        c = *Global_PTR_WORK_BUFFER;
        if (c == 13 || c == 10)
            break;
        Global_PTR_WORK_BUFFER++;
    }
    *Global_PTR_WORK_BUFFER++ = 0;
    if (Global_REF_LONG_FILE_SCRATCH < 0)
        return (char *)0xFFFF;
    while ((c = *Global_PTR_WORK_BUFFER) == 13 || c == 10) {
        Global_PTR_WORK_BUFFER++;
        Global_REF_LONG_FILE_SCRATCH--;
    }
    return start;
}
