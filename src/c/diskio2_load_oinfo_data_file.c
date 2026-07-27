/* RESTORES: _DISKIO2_LoadOinfoDataFile
 * MODULE:   modules/groups/a/h/diskio2.s
 * STATUS:   behavioural
 *
 * 194 bytes in the original, 164 emitted, only FIVE differing regions.
 *
 * The reader half of the pair whose writer is diskio2_write_oinfo_data_file.c.
 * Reproduces: the load-and-test where the result is incremented before the zero
 * test, the file length and buffer base captured before anything is consumed, the
 * group-code check that silently skips the whole update on a mismatch while still
 * freeing the buffer, both string consumptions, the -1 sentinel test on each, and
 * the deallocation of length+1 at the end regardless of which path was taken.
 *
 * Two details worth noting:
 *
 *   - The parsed code is masked with 0xFF built as MOVEQ #0 / NOT.B -- another
 *     sighting of the constant form recorded in docs/compiler-version.md, and the
 *     second time 255 specifically has been reached that way.
 *
 *   - The sentinel is loaded with MOVEA.W #$ffff,A0, which sign-extends to
 *     0xFFFFFFFF. Comparing against (char *)-1L reproduces it; comparing against
 *     0xFFFF would not, and would also be wrong.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffec                   LINK.W A5,#-20
 *   got:     (none)                     MOVEM only
 *   summary: The A5-frame class. All three pointers stay in registers for SAS/C
 *            and the original reloads them from the frame at each use, which is
 *            the whole -30.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the six cross-unit calls.
 */
extern long  DISKIO_LoadFileToWorkBuffer(char *path);
extern long  DISKIO_ParseLongFromWorkBuffer(void);
extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(char *newstr, char *old);
extern void  GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
extern long  Global_REF_LONG_FILE_SCRATCH;
extern char *Global_PTR_WORK_BUFFER;
extern char  TEXTDISP_PrimaryGroupCode;
extern char *ESQIFF_PrimaryLineHeadPtr;
extern char *ESQIFF_PrimaryLineTailPtr;
extern char  CTASKS_PATH_OINFO_DAT[];
extern char  Global_STR_DISKIO2_C_23[];

long DISKIO2_LoadOinfoDataFile(void)
{
    char *head;
    char *tail;
    char *base;
    register long len;
    register long code;

    tail = 0;
    head = 0;

    if (DISKIO_LoadFileToWorkBuffer(CTASKS_PATH_OINFO_DAT) + 1 == 0)
        return -1;

    len  = Global_REF_LONG_FILE_SCRATCH;
    base = Global_PTR_WORK_BUFFER;

    code = DISKIO_ParseLongFromWorkBuffer() & 0xFF;

    if ((char)code == TEXTDISP_PrimaryGroupCode) {
        head = DISKIO_ConsumeCStringFromWorkBuffer();
        tail = DISKIO_ConsumeCStringFromWorkBuffer();
        if (head != (char *)-1L && tail != (char *)-1L) {
            ESQIFF_PrimaryLineHeadPtr =
                GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(head, ESQIFF_PrimaryLineHeadPtr);
            ESQIFF_PrimaryLineTailPtr =
                GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(tail, ESQIFF_PrimaryLineTailPtr);
        }
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_23, 1191, base, len + 1);
    return 0;
}
