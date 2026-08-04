/* RESTORES: _DISKIO2_LoadCurDayDataFile
 * MODULE:   modules/groups/a/h/diskio2_diskio2_loadcurdaydatafile.s
 * STATUS:   behavioural
 *
 * Loads `curday.dat` into the primary entry and title tables. 1388 bytes.
 *
 * The file starts with a 21-byte status packet, a countdown, a REVISION TAG and a
 * weather label. The revision tag decides two things at once: which revision index
 * the rest of the program sees, and how many bytes of each entry record are copied
 * verbatim -- 40, 41, 46, 48, 48 for tags 1 to 5. An unrecognised tag frees the
 * buffer and returns -1.
 *
 * REVISION 5 AND ABOVE STORE THE SLOT TABLE SPARSELY. A run-length is read, and
 * while the slot index is below it the slot keeps its default (flag 1, no text) and
 * nothing is consumed. When the index reaches the run-length the counter is reset
 * to -1 so the next slot reads a fresh one. Revisions 1 to 4 read every slot.
 * That is the whole reason the slot loop has two shapes in one body.
 *
 * REVISION 2 AND ABOVE carry three extra per-slot bytes, at title offsets 252, 301
 * and 350. Those are three parallel 49-byte arrays after the text pointers, which
 * is why `struct DkTitle` spells them out rather than treating the record as
 * opaque.
 *
 * ONE FAILURE PATH LEAKS, in the original. When the per-entry title string cannot
 * be consumed, control jumps straight to the shared exit without freeing the entry
 * or the title it has just allocated -- unlike the two allocation failures and the
 * slot-loop failure, which both free first. The `goto finish` here reproduces it.
 *
 * The status packet is seeded from ESQ_STR_B byte by byte rather than copied,
 * because the original does that with an indexed load per byte and a `memcpy`
 * would inline to a different loop.
 *
 * MEASURED: 1396 emitted against 1388 in the original, +8 over 41 regions.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....              JSR (d16,PC)
 *   got:     61000000              BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffb4 ... 4e5d     LINK.W A5,#-76 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: byte-flag-via-word-mask
 *   ref:     0240 ff7f             ANDI.W #$ff7f,D0 on a zero-extended byte
 *   got:     a byte AND
 *   summary: the original clears and sets bit 7 of the entry flag byte by
 *            zero-extending it to a word, masking the word, and storing the byte
 *            back. Written here as `&= 0x7f` / `|= 0x80` on the byte.
 *   scope:   anywhere a byte flag is masked.
 *   retest:  a compiler that widens a byte mask to a word.
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

extern char  ESQ_STR_B[];
extern char  CTASKS_PATH_CURDAY_DAT[];
extern char  DISKIO_ErrorMessageScratch[];
extern char  DISKIO2_STR_DREV_1[];
extern char  DISKIO2_STR_DREV_2[];
extern char  DISKIO2_STR_DREV_3[];
extern char  DISKIO2_STR_DREV_4[];
extern char  DISKIO2_STR_DREV_5[];
extern char  Global_STR_DISKIO2_C_4[];
extern char  Global_STR_DISKIO2_C_5[];
extern char  Global_STR_DISKIO2_C_6[];
extern char  Global_STR_DISKIO2_C_7[];
extern char  Global_STR_DISKIO2_C_8[];
extern char  Global_STR_DISKIO2_C_9[];
extern char  Global_STR_DISKIO2_C_10[];
extern char  Global_STR_DISKIO2_C_11[];
extern char  Global_STR_DISKIO2_C_12[];
extern char  Global_STR_DISKIO2_C_13[];

extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;
extern short DST_PrimaryCountdown;
extern short DISKIO_CurrentDriveRevisionIndex;
extern char  WDISP_WeatherStatusLabelBuffer[];
extern char *WDISP_WeatherStatusTextPtr;
extern unsigned char TEXTDISP_PrimaryGroupCode;
extern unsigned char TEXTDISP_PrimaryGroupHeaderCode;
extern unsigned char TEXTDISP_PrimaryGroupRecordChecksum;
extern unsigned char TEXTDISP_PrimaryGroupPresentFlag;
extern short TEXTDISP_PrimaryGroupRecordLength;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern short TEXTDISP_GroupMutationState;
extern short TEXTDISP_MaxEntryTitleLength;
extern struct DkEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern struct DkTitle *TEXTDISP_PrimaryTitlePtrTable[];
extern unsigned char CTASKS_PrimaryOiWritePendingFlag;
extern unsigned char CTASKS_PendingPrimaryOiDiskId;

extern long  DISKIO_LoadFileToWorkBuffer(char *name);
extern long  DISKIO_ParseLongFromWorkBuffer(void);
extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern void  ESQIFF2_ApplyIncomingStatusPacket(char *p);
extern char  ESQ_WildcardMatch(char *pattern, char *text);
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

long DISKIO2_LoadCurDayDataFile(void)
{
    char  statusPacket[21];
    struct DkEntry *entry;
    struct DkTitle *title;
    char *str;
    char *work;
    char *dstCursor;
    long  fileLen;
    long  headerLen;
    long  status;
    short sparseLimit;
    short entryCount;
    short n;
    short s;
    short k;
    short len;
    unsigned char groupCode;

    sparseLimit = -1;
    for (n = 0; n < 21; n++)
        statusPacket[n] = ESQ_STR_B[n];

    if (DISKIO_LoadFileToWorkBuffer(CTASKS_PATH_CURDAY_DAT) == -1) {
        DST_PrimaryCountdown = 0;
        ESQIFF2_ApplyIncomingStatusPacket(statusPacket);
        return -1;
    }

    fileLen = Global_REF_LONG_FILE_SCRATCH;
    work = Global_PTR_WORK_BUFFER;

    for (n = 0; Global_REF_LONG_FILE_SCRATCH > 0 && n < 21; n++) {
        statusPacket[n] = *Global_PTR_WORK_BUFFER++;
        Global_REF_LONG_FILE_SCRATCH = Global_REF_LONG_FILE_SCRATCH - 1;
    }

    DST_PrimaryCountdown = (short)DISKIO_ParseLongFromWorkBuffer();
    ESQIFF2_ApplyIncomingStatusPacket(statusPacket);

    str = DISKIO_ConsumeCStringFromWorkBuffer();
    if (str == (char *)-1) {
        MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_4, 520,
                                                work, fileLen + 1);
        return -1;
    }
    strcpy(DISKIO_ErrorMessageScratch, str);

    if (ESQ_WildcardMatch(DISKIO_ErrorMessageScratch,
                                          DISKIO2_STR_DREV_1) == 0) {
        DISKIO_CurrentDriveRevisionIndex = 1;
        headerLen = 40;
    } else if (ESQ_WildcardMatch(DISKIO_ErrorMessageScratch,
                                                 DISKIO2_STR_DREV_2) == 0) {
        DISKIO_CurrentDriveRevisionIndex = 2;
        headerLen = 41;
    } else if (ESQ_WildcardMatch(DISKIO_ErrorMessageScratch,
                                                 DISKIO2_STR_DREV_3) == 0) {
        DISKIO_CurrentDriveRevisionIndex = 3;
        headerLen = 46;
    } else if (ESQ_WildcardMatch(DISKIO_ErrorMessageScratch,
                                                 DISKIO2_STR_DREV_4) == 0) {
        DISKIO_CurrentDriveRevisionIndex = 4;
        headerLen = 48;
    } else if (ESQ_WildcardMatch(DISKIO_ErrorMessageScratch,
                                                 DISKIO2_STR_DREV_5) == 0) {
        DISKIO_CurrentDriveRevisionIndex = 5;
        headerLen = 48;
    } else {
        MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_5, 561,
                                                work, fileLen + 1);
        return -1;
    }

    str = DISKIO_ConsumeCStringFromWorkBuffer();
    if (str == (char *)-1) {
        MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_6, 570,
                                                work, fileLen + 1);
        return -1;
    }
    strcpy(WDISP_WeatherStatusLabelBuffer, str);

    if (DISKIO_CurrentDriveRevisionIndex > 0) {
        str = DISKIO_ConsumeCStringFromWorkBuffer();
        if (str == (char *)-1) {
            MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_7, 588,
                                                    work, fileLen + 1);
            return -1;
        }
        WDISP_WeatherStatusTextPtr = ESQPARS_ReplaceOwnedString(
            str, WDISP_WeatherStatusTextPtr);
    }

    groupCode = (unsigned char)(DISKIO_ParseLongFromWorkBuffer() & 0xFF);
    n = 0;

    if (groupCode != TEXTDISP_PrimaryGroupCode) {
        status = -1;
        goto finish;
    }

    entryCount = (short)DISKIO_ParseLongFromWorkBuffer();
    TEXTDISP_PrimaryGroupRecordChecksum =
        (unsigned char)DISKIO_ParseLongFromWorkBuffer();
    TEXTDISP_PrimaryGroupRecordLength =
        (short)DISKIO_ParseLongFromWorkBuffer();
    TEXTDISP_PrimaryGroupPresentFlag = 1;
    TEXTDISP_GroupMutationState = 1;
    TEXTDISP_MaxEntryTitleLength = 0;
    status = 0;

    for (n = 0; n < entryCount; n++) {
        entry = (struct DkEntry *)MEMORY_AllocateMemory(
            Global_STR_DISKIO2_C_8, 634, 52, MEMF_PUBLIC | MEMF_CLEAR);
        if (entry == 0) {
            status = -1;
            goto finish;
        }
        title = (struct DkTitle *)MEMORY_AllocateMemory(
            Global_STR_DISKIO2_C_9, 640, 500, MEMF_PUBLIC | MEMF_CLEAR);
        if (title == 0) {
            status = -1;
            MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_10, 644,
                                                    entry, 52);
            goto finish;
        }

        ESQSHARED_InitEntryDefaults(entry);
        COI_EnsureAnimObjectAllocated(entry);

        dstCursor = (char *)entry;
        for (k = 0; (long)k < headerLen; k++) {
            *dstCursor++ = *Global_PTR_WORK_BUFFER++;
            Global_REF_LONG_FILE_SCRATCH = Global_REF_LONG_FILE_SCRATCH - 1;
        }

        entry->flags40 = entry->flags40 & 0x7f;

        len = (short)strlen(entry->name);
        if (len > TEXTDISP_MaxEntryTitleLength)
            TEXTDISP_MaxEntryTitleLength = len;

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

            if (DISKIO_CurrentDriveRevisionIndex > 1) {
                title->extA[s] =
                    (unsigned char)DISKIO_ParseLongFromWorkBuffer();
                title->extB[s] =
                    (unsigned char)DISKIO_ParseLongFromWorkBuffer();
                title->extC[s] =
                    (unsigned char)DISKIO_ParseLongFromWorkBuffer();
            }

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
            MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_11, 736,
                                                    entry, 52);
            MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_12, 737,
                                                    title, 500);
            goto finish;
        }

        TEXTDISP_PrimaryEntryPtrTable[n] = entry;
        TEXTDISP_PrimaryTitlePtrTable[n] = title;
    }

finish:
    TEXTDISP_PrimaryGroupHeaderCode = groupCode;
    TEXTDISP_PrimaryGroupEntryCount = n;
    MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_13, 764, work,
                                            fileLen + 1);

    if (COI_LoadOiDataFile(groupCode) != -1) {
        CTASKS_PrimaryOiWritePendingFlag = 1;
        CTASKS_PendingPrimaryOiDiskId = groupCode;
    } else {
        CTASKS_PrimaryOiWritePendingFlag = 0;
        CTASKS_PendingPrimaryOiDiskId = 0;
    }

    return status;
}
