/* RESTORES: DISKIO_LoadFileToWorkBuffer
 * MODULE:   modules/groups/a/g/diskio_p2.s
 * STATUS:   behavioural
 *
 * Opens a file, allocates a work buffer one byte bigger than it, reads the
 * whole thing in, and answers the length -- or -1 on any failure.
 *
 * FOUR failure paths, and every one of them closes the file except the first,
 * which never opened it. The buffer is freed only on the read failure, which is
 * the only path where it exists and is not being handed back.
 *
 * The allocation is length + 1, so the caller can terminate the buffer; the
 * FREE on the read-failure path also passes length + 1, computed fresh from the
 * global.
 *
 * A file of length zero or less is a failure -- TST.L / BGT, not BGE.
 *
 * The successful return value is re-read from Global_REF_LONG_FILE_SCRATCH
 * after the close, not carried in a register.
 *
 * The volatile DOS header is required: the tracking allocator is ESQ assembly
 * and returns with A6 pointing at ExecBase, which is why the original reloads
 * Global_REF_DOS_LIBRARY_2 before every one of its five DOS calls.
 *
 * 222 ref vs 228 got. The PEA $3ed open mode, the TST.L / BGT length guard, the
 * ADDQ.L #1 on both the allocation and the free, the MEMF word, the PEA 472 and
 * PEA 492 line numbers, the Read length compare and all five Close calls with
 * their DOS base reloads match in kind and size. The 6 bytes are the A3/A5
 * class plus one store-ordering difference around the allocation result --
 * both settled, docs/compiler-version.md.
 */
#include <exec/memory.h>
#include "esq-dos.h"

extern BPTR  GROUP_AG_JMPTBL_DOS_OpenFileWithMode(char *path, long mode);
extern long  DISKIO_GetFilesizeFromHandle(BPTR fh);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);
extern void  GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                     void *p, long size);

extern long  Global_REF_LONG_FILE_SCRATCH;
extern char *Global_PTR_WORK_BUFFER;
extern char  Global_STR_DISKIO_C_3[];
extern char  Global_STR_DISKIO_C_4[];

long DISKIO_LoadFileToWorkBuffer(char *path)
{
    BPTR fh;

    fh = GROUP_AG_JMPTBL_DOS_OpenFileWithMode(path, 0x3edL);
    if (fh == 0)
        return -1;

    Global_REF_LONG_FILE_SCRATCH = DISKIO_GetFilesizeFromHandle(fh);
    if (Global_REF_LONG_FILE_SCRATCH <= 0) {
        Close(fh);
        return -1;
    }

    Global_PTR_WORK_BUFFER = (char *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISKIO_C_3, 472L, Global_REF_LONG_FILE_SCRATCH + 1,
        MEMF_PUBLIC | MEMF_CLEAR);

    if (Global_PTR_WORK_BUFFER == 0) {
        Close(fh);
        return -1;
    }

    if (Read(fh, Global_PTR_WORK_BUFFER, Global_REF_LONG_FILE_SCRATCH)
        != Global_REF_LONG_FILE_SCRATCH) {

        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_DISKIO_C_4, 492L, Global_PTR_WORK_BUFFER,
            Global_REF_LONG_FILE_SCRATCH + 1);

        Close(fh);
        return -1;
    }

    Close(fh);
    return Global_REF_LONG_FILE_SCRATCH;
}
