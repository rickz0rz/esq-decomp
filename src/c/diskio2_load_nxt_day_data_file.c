/* RESTORES: _DISKIO2_LoadNxtDayDataFile
 * MODULE:   modules/groups/a/h/diskio2_diskio2_loadnxtdaydatafile.s
 * STATUS:   behavioural
 *
 * Loads `nxtday.dat` into the SECONDARY entry and title tables. 790 bytes, and a
 * near-copy of diskio2_load_cur_day_data_file.c with four differences that are
 * worth naming, because each one looks like something the transcription dropped:
 *
 *   1. NO STATUS PACKET and no weather label -- the next-day file has no header
 *      beyond the group code.
 *   2. NO REVISION TAG. The record length is hard-wired to 48 rather than chosen
 *      from a DREV string, and the loop that copies it uses an UNSIGNED compare
 *      (`BCC`), so the counter here is unsigned where the current-day loop's is
 *      signed. Per AGENTS.md that is the tell for an unsigned counter, so it is
 *      written that way.
 *   3. THE THREE EXTRA PER-SLOT BYTES ARE READ UNCONDITIONALLY. The current-day
 *      loader guards them with `revision > 1`; this one does not. The sparse-slot
 *      path is still guarded by `revision > 4`, reading the SAME global the
 *      current-day loader set -- so this function depends on having been called
 *      after that one.
 *   4. It does not touch TEXTDISP_GroupMutationState or
 *      TEXTDISP_MaxEntryTitleLength.
 *
 * Otherwise the shape is identical, including the leaking failure path: a
 * consume-string failure on the title jumps to the shared exit without freeing the
 * entry and title it has just allocated.
 *
 * MEASURED: 784 emitted against 790 in the original, -6 over 29 regions.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....              JSR (d16,PC)
 *   got:     61000000              BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffd0 ... 4e5d     LINK.W A5,#-48 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: NOT itemised. Recorded as a known-unknown per AGENTS.md rule 3.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>
#include <exec/memory.h>
#include <string.h>

struct DkEntry {
    char          pad0;         /*  0 */
    char          name[26];     /*  1 */
    unsigned char filterArg;    /* 27 */
    char          pad28[12];    /* 28 */
    unsigned char flags40;      /* 40 */
    char          pad41[11];    /* 41, to the 52-byte record */
};

struct DkTitle {
    char          pad0[7];      /*   0 */
    unsigned char slotFlag[49]; /*   7 */
    char         *slotText[49]; /*  56 */
    unsigned char extA[49];     /* 252 */
    unsigned char extB[49];     /* 301 */
    unsigned char extC[49];     /* 350 */
    char          pad399[101];  /* 399, to the 500-byte record */
};

extern char  Global_STR_DF0_NXTDAY_DAT[];

extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;
extern short DISKIO_CurrentDriveRevisionIndex;
extern unsigned char TEXTDISP_SecondaryGroupCode;
extern unsigned char TEXTDISP_SecondaryGroupHeaderCode;
extern unsigned char TEXTDISP_SecondaryGroupRecordChecksum;
extern unsigned char TEXTDISP_SecondaryGroupPresentFlag;
extern short TEXTDISP_SecondaryGroupRecordLength;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern struct DkEntry *TEXTDISP_SecondaryEntryPtrTable[];
extern struct DkTitle *TEXTDISP_SecondaryTitlePtrTable[];
extern unsigned char CTASKS_SecondaryOiWritePendingFlag;
extern unsigned char CTASKS_PendingSecondaryOiDiskId;

extern long  DISKIO_LoadFileToWorkBuffer(char *name);
extern long  DISKIO_ParseLongFromWorkBuffer(void);
extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern void  ESQSHARED_InitEntryDefaults(struct DkEntry *e);
extern void  ESQSHARED_ApplyProgramTitleTextFilters(char *s,
                                                                   long arg);
extern void  COI_EnsureAnimObjectAllocated(struct DkEntry *e);
extern long  COI_LoadOiDataFile(unsigned char diskId);
extern char *ESQPARS_ReplaceOwnedString(char *newText,
                                                        char *oldText);
extern void *MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                     void *p, long size);

long DISKIO2_LoadNxtDayDataFile(void)
{
    struct DkEntry *entry;
    struct DkTitle *title;
    char *str;
    char *work;
    char *dstCursor;
    long  fileLen;
    long  status;
    short sparseLimit;
    short entryCount;
    short n;
    short s;
    unsigned short k;
    unsigned char groupCode;

    if (DISKIO_LoadFileToWorkBuffer(Global_STR_DF0_NXTDAY_DAT) == -1)
        return -1;

    fileLen = Global_REF_LONG_FILE_SCRATCH;
    work = Global_PTR_WORK_BUFFER;

    groupCode = (unsigned char)(DISKIO_ParseLongFromWorkBuffer() & 0xFF);
    n = 0;

    if (groupCode != TEXTDISP_SecondaryGroupCode) {
        status = 0;
        goto finish;
    }

    entryCount = (short)DISKIO_ParseLongFromWorkBuffer();
    TEXTDISP_SecondaryGroupRecordChecksum =
        (unsigned char)DISKIO_ParseLongFromWorkBuffer();
    TEXTDISP_SecondaryGroupRecordLength =
        (short)DISKIO_ParseLongFromWorkBuffer();
    TEXTDISP_SecondaryGroupPresentFlag = 1;
    status = 0;

    for (n = 0; n < entryCount; n++) {
        entry = (struct DkEntry *)MEMORY_AllocateMemory(
            "DISKIO2.c", 948, 52, MEMF_PUBLIC | MEMF_CLEAR);
        if (entry == 0) {
            status = -1;
            goto finish;
        }
        title = (struct DkTitle *)MEMORY_AllocateMemory(
            "DISKIO2.c", 954, 500, MEMF_PUBLIC | MEMF_CLEAR);
        if (title == 0) {
            status = -1;
            MEMORY_DeallocateMemory("DISKIO2.c", 958,
                                                    entry, 52);
            goto finish;
        }

        ESQSHARED_InitEntryDefaults(entry);
        COI_EnsureAnimObjectAllocated(entry);

        dstCursor = (char *)entry;
        for (k = 0; k < 48; k++) {
            *dstCursor++ = *Global_PTR_WORK_BUFFER++;
            Global_REF_LONG_FILE_SCRATCH = Global_REF_LONG_FILE_SCRATCH - 1;
        }

        entry->flags40 = entry->flags40 & 0x7f;

        str = DISKIO_ConsumeCStringFromWorkBuffer();
        if (str == (char *)-1) {
            /* the original leaks entry and title here; see the header */
            status = -1;
            goto finish;
        }
        strcpy((char *)title, str);

        sparseLimit = -1;
        for (s = 0; s < 49; s++) {
            title->slotFlag[s] = 1;
            title->slotText[s] = 0;

            if (DISKIO_CurrentDriveRevisionIndex > 4) {
                if (sparseLimit < 0)
                    sparseLimit = (short)DISKIO_ParseLongFromWorkBuffer();
                if (s < sparseLimit)
                    continue;
                sparseLimit = -1;
            }

            title->slotFlag[s] =
                (unsigned char)DISKIO_ParseLongFromWorkBuffer();
            title->extA[s] = (unsigned char)DISKIO_ParseLongFromWorkBuffer();
            title->extB[s] = (unsigned char)DISKIO_ParseLongFromWorkBuffer();
            title->extC[s] = (unsigned char)DISKIO_ParseLongFromWorkBuffer();

            str = DISKIO_ConsumeCStringFromWorkBuffer();
            if (str == (char *)-1) {
                status = -1;
                break;
            }

            ESQSHARED_ApplyProgramTitleTextFilters(
                str, (long)entry->filterArg);
            title->slotText[s] = ESQPARS_ReplaceOwnedString(
                str, title->slotText[s]);
            if (title->slotText[s] != 0)
                entry->flags40 = entry->flags40 | 0x80;
        }

        if (DISKIO_CurrentDriveRevisionIndex > 4 && sparseLimit == -1)
            sparseLimit = (short)DISKIO_ParseLongFromWorkBuffer();

        if (status == -1) {
            MEMORY_DeallocateMemory("DISKIO2.c",
                                                    1027, entry, 52);
            MEMORY_DeallocateMemory("DISKIO2.c",
                                                    1028, title, 500);
            goto finish;
        }

        TEXTDISP_SecondaryEntryPtrTable[n] = entry;
        TEXTDISP_SecondaryTitlePtrTable[n] = title;
    }

finish:
    TEXTDISP_SecondaryGroupHeaderCode = groupCode;
    TEXTDISP_SecondaryGroupEntryCount = n;
    MEMORY_DeallocateMemory("DISKIO2.c", 1041, work,
                                            fileLen + 1);

    if (COI_LoadOiDataFile(groupCode) != -1) {
        CTASKS_SecondaryOiWritePendingFlag = 1;
        CTASKS_PendingSecondaryOiDiskId = groupCode;
    } else {
        CTASKS_SecondaryOiWritePendingFlag = 0;
        CTASKS_PendingSecondaryOiDiskId = 0;
    }

    return status;
}
