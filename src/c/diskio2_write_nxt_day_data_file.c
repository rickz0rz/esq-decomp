/* RESTORES: DISKIO2_WriteNxtDayDataFile
 * MODULE:   modules/groups/a/h/diskio2_diskio2_writenxtdaydatafile.s
 * STATUS:   behavioural
 *
 * Writes `nxtday.dat` back out from the SECONDARY tables. 708 bytes, and the same
 * routine as diskio2_write_cur_day_data_file.c with the header cut down: no status
 * packet, no revision tag, no weather label and no weather text, so the one-byte
 * empty-string local that the current-day writer needs does not exist here either.
 * It writes only the four decimal header fields.
 *
 * It also uses its OWN file handle global, DISKIO2_NxtDayFileHandle, not the one
 * the current-day writer uses -- so the two can be in flight at once.
 *
 * Everything else matches: the two "not now" guards returning 0, the two failures
 * returning -1, the save-ready flag cleared on entry and restored at every exit
 * past the allocation, `strlen + 1` for every string, the slot skipped unless
 * ESQ_TestBit1Based returns -1, and the rebuild-above-100-entries fork.
 *
 * MEASURED: 652 emitted against 708 in the original, -56 over 23 regions.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....              JSR (d16,PC)
 *   got:     61000000              BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffe8 ... 4e5d     LINK.W A5,#-24 / UNLK A5
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
#include <dos/dos.h>
#include <string.h>

struct DkEntry {
    char          pad0;         /*  0 */
    char          name[26];     /*  1 */
    unsigned char filterArg;    /* 27 */
    char          bits28[12];   /* 28 -- the bit field tested at +0x1c */
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

extern long  DISKIO_SaveOperationReadyFlag;
extern long  DISKIO2_NxtDayFileHandle;
extern unsigned char TEXTDISP_SecondaryGroupCode;
extern unsigned char TEXTDISP_SecondaryGroupRecordChecksum;
extern short TEXTDISP_SecondaryGroupRecordLength;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern struct DkEntry *TEXTDISP_SecondaryEntryPtrTable[];
extern struct DkTitle *TEXTDISP_SecondaryTitlePtrTable[];

extern long  DISKIO_OpenFileWithBuffer(char *name, long mode);
extern void  DISKIO_WriteBufferedBytes(long fh, char *p, long n);
extern void  DISKIO_WriteDecimalField(long fh, long v);
extern void  DISKIO_CloseBufferedFileAndFlush(long fh);
extern long  ESQ_TestBit1Based(char *bits, long index);
extern char *DISKIO2_CopyAndSanitizeSlotString(char *buf, struct DkEntry *e,
                                               struct DkTitle *t, long slot);
extern void *MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                     void *p, long size);

long DISKIO2_WriteNxtDayDataFile(void)
{
    struct DkEntry *entry;
    struct DkTitle *title;
    char *scratch;
    char *text;
    short n;
    short s;

    if (TEXTDISP_SecondaryGroupEntryCount > 200)
        return 0;
    if (DISKIO_SaveOperationReadyFlag == 0)
        return 0;

    DISKIO_SaveOperationReadyFlag = 0;

    scratch = (char *)MEMORY_AllocateMemory(
        "DISKIO2.c", 817, 1000, MEMF_PUBLIC | MEMF_CLEAR);
    if (scratch == 0) {
        DISKIO_SaveOperationReadyFlag = 1;
        return -1;
    }

    DISKIO2_NxtDayFileHandle = DISKIO_OpenFileWithBuffer(Global_STR_DF0_NXTDAY_DAT,
                                                       MODE_NEWFILE);
    if (DISKIO2_NxtDayFileHandle == 0) {
        MEMORY_DeallocateMemory("DISKIO2.c", 839,
                                                scratch, 1000);
        DISKIO_SaveOperationReadyFlag = 1;
        return -1;
    }

    DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle,
                             (long)TEXTDISP_SecondaryGroupCode);
    DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle,
                             (long)TEXTDISP_SecondaryGroupEntryCount);
    DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle,
                             (long)TEXTDISP_SecondaryGroupRecordChecksum);
    DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle,
                             (long)TEXTDISP_SecondaryGroupRecordLength);

    for (n = 0; n < TEXTDISP_SecondaryGroupEntryCount; n++) {
        entry = TEXTDISP_SecondaryEntryPtrTable[n];
        title = TEXTDISP_SecondaryTitlePtrTable[n];

        DISKIO_WriteBufferedBytes(DISKIO2_NxtDayFileHandle, (char *)entry, 48L);
        DISKIO_WriteBufferedBytes(DISKIO2_NxtDayFileHandle, (char *)title,
                                  strlen((char *)title) + 1);

        for (s = 0; s < 49; s++) {
            if (title->slotText[s] == 0)
                continue;
            if (ESQ_TestBit1Based(entry->bits28, (long)s) != -1)
                continue;

            DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, (long)s);
            DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle,
                                     (long)title->slotFlag[s]);
            DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle,
                                     (long)title->extA[s]);
            DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle,
                                     (long)title->extB[s]);
            DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle,
                                     (long)title->extC[s]);

            if (TEXTDISP_SecondaryGroupEntryCount > 100)
                text = DISKIO2_CopyAndSanitizeSlotString(scratch, entry, title,
                                                         (long)s);
            else
                text = title->slotText[s];

            DISKIO_WriteBufferedBytes(DISKIO2_NxtDayFileHandle, text,
                                      strlen(text) + 1);
        }

        DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, (long)s);
    }

    DISKIO_CloseBufferedFileAndFlush(DISKIO2_NxtDayFileHandle);
    DISKIO_SaveOperationReadyFlag = 1;
    MEMORY_DeallocateMemory("DISKIO2.c", 927, scratch,
                                            1000);
    return 0;
}
