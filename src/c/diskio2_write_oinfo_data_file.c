/* RESTORES: DISKIO2_WriteOinfoDataFile
 * MODULE:   modules/groups/a/h/diskio2.s
 * STATUS:   behavioural
 *
 * 186 bytes in the original, 176 emitted, 6 differing regions.
 *
 * Reproduces: the open-or-fail with -1, the group code written as a decimal
 * field, and both string writes each guarded by a null test that substitutes a
 * pointer to a single stack NUL byte when the pointer is absent -- so an empty
 * record still writes one byte and the reader stays in step.
 *
 * That empty-byte substitution is the detail worth preserving. Skipping the write
 * entirely when the pointer is null would be the natural simplification and would
 * silently desynchronise the file format, since the matching reader consumes a
 * length-prefixed field either way.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff8                   LINK.W A5,#-8
 *   got:     594f 2f0d                  SUBQ.W #4,A7 / MOVE.L A5,-(A7)
 *   summary: The A5-frame class. Note SAS/C still needs a stack slot here because
 *            the empty byte has its address taken; only the base register and the
 *            saved-register choice differ.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the five cross-unit calls.
 */
#include <string.h>

extern long DISKIO_OpenFileWithBuffer(char *path, long mode);
extern void DISKIO_WriteDecimalField(long fh, long v);
extern void DISKIO_WriteBufferedBytes(long fh, char *p, long len);
extern void DISKIO_CloseBufferedFileAndFlush(long fh);
extern long  DISKIO2_OinfoFileHandle;
extern char  TEXTDISP_PrimaryGroupCode;
extern char *ESQIFF_PrimaryLineHeadPtr;
extern char *ESQIFF_PrimaryLineTailPtr;
extern char  CTASKS_PATH_OINFO_DAT[];

long DISKIO2_WriteOinfoDataFile(void)
{
    char empty;
    char *p;

    DISKIO2_OinfoFileHandle = DISKIO_OpenFileWithBuffer(CTASKS_PATH_OINFO_DAT, 1006);
    if (DISKIO2_OinfoFileHandle == 0)
        return -1;

    empty = 0;
    DISKIO_WriteDecimalField(DISKIO2_OinfoFileHandle, (long)TEXTDISP_PrimaryGroupCode);

    if (ESQIFF_PrimaryLineHeadPtr)
        p = ESQIFF_PrimaryLineHeadPtr;
    else
        p = &empty;
    DISKIO_WriteBufferedBytes(DISKIO2_OinfoFileHandle, p, (long)strlen(p) + 1);

    if (ESQIFF_PrimaryLineTailPtr)
        p = ESQIFF_PrimaryLineTailPtr;
    else
        p = &empty;
    DISKIO_WriteBufferedBytes(DISKIO2_OinfoFileHandle, p, (long)strlen(p) + 1);

    DISKIO_CloseBufferedFileAndFlush(DISKIO2_OinfoFileHandle);
    return 0;
}
