/* RESTORES: _DISKIO2_WriteCurDayDataFile
 * MODULE:   modules/groups/a/h/diskio2_diskio2_writecurdaydatafile.s
 * STATUS:   behavioural
 *
 * Writes `curday.dat` back out from the primary tables. 864 bytes, and the inverse
 * of diskio2_load_cur_day_data_file.c.
 *
 * TWO GUARDS RETURN 0, NOT AN ERROR: more than 200 entries, and the save-ready flag
 * being clear. Both mean "not now" rather than "failed", which is why the two
 * genuine failures below them return -1 instead.
 *
 * The save-ready flag is CLEARED on entry and set again at every exit that got as
 * far as allocating, including the failures. So a failed save re-arms itself and a
 * successful one does too; only a return through the two early guards leaves it as
 * it was.
 *
 * EVERY STRING IS WRITTEN WITH ITS TERMINATOR -- `strlen + 1` -- because the loader
 * consumes NUL-terminated strings. The fixed-length pieces are not: the status
 * packet is 21 bytes and the revision tag is 7.
 *
 * WHEN THERE IS NO WEATHER TEXT the original writes a one-byte local that it
 * cleared on entry, i.e. an empty string, rather than skipping the field. The
 * loader would desynchronise if the field vanished, so `emptyText` here is that
 * local and not an optimisation to remove.
 *
 * ABOVE 100 ENTRIES THE SLOT TEXT IS REBUILT rather than written from the table:
 * DISKIO2_CopyAndSanitizeSlotString renders it into the 1000-byte scratch. Below
 * that threshold the stored pointer is written directly. That is a real behavioural
 * fork, not two spellings of one thing.
 *
 * Slots are skipped unless ESQ_TestBit1Based returns -1 for them, and a slot with
 * no stored text is skipped before that test is even reached.
 *
 * MEASURED: 812 emitted against 864 in the original, -52 over 24 regions.
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

extern char  ESQ_STR_B[];
extern char  CTASKS_PATH_CURDAY_DAT[];
extern char  Global_STR_DREV_5_1[];

extern long  DISKIO_SaveOperationReadyFlag;
extern long  DISKIO2_OutputFileHandle;
extern short DST_PrimaryCountdown;
extern char  WDISP_WeatherStatusLabelBuffer[];
extern char *WDISP_WeatherStatusTextPtr;
extern unsigned char TEXTDISP_PrimaryGroupCode;
extern unsigned char TEXTDISP_PrimaryGroupRecordChecksum;
extern short TEXTDISP_PrimaryGroupRecordLength;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern struct DkEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern struct DkTitle *TEXTDISP_PrimaryTitlePtrTable[];

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

long DISKIO2_WriteCurDayDataFile(void)
{
    struct DkEntry *entry;
    struct DkTitle *title;
    char *scratch;
    char *text;
    char  emptyText;
    short n;
    short s;

    if (TEXTDISP_PrimaryGroupEntryCount > 200)
        return 0;
    if (DISKIO_SaveOperationReadyFlag == 0)
        return 0;

    DISKIO_SaveOperationReadyFlag = 0;
    emptyText = 0;

    scratch = (char *)MEMORY_AllocateMemory(
        "DISKIO2.c", 152, 1000, MEMF_PUBLIC | MEMF_CLEAR);
    if (scratch == 0) {
        DISKIO_SaveOperationReadyFlag = 1;
        return -1;
    }

    DISKIO2_OutputFileHandle = DISKIO_OpenFileWithBuffer(CTASKS_PATH_CURDAY_DAT,
                                                        MODE_NEWFILE);
    if (DISKIO2_OutputFileHandle == 0) {
        MEMORY_DeallocateMemory("DISKIO2.c", 176,
                                                scratch, 1000);
        DISKIO_SaveOperationReadyFlag = 1;
        return -1;
    }

    DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, ESQ_STR_B, 21L);
    DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle,
                             (long)DST_PrimaryCountdown);
    DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, Global_STR_DREV_5_1, 7L);
    DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle,
                              WDISP_WeatherStatusLabelBuffer,
                              strlen(WDISP_WeatherStatusLabelBuffer) + 1);

    if (WDISP_WeatherStatusTextPtr == 0)
        text = &emptyText;
    else
        text = WDISP_WeatherStatusTextPtr;
    DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, text, strlen(text) + 1);

    DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle,
                             (long)TEXTDISP_PrimaryGroupCode);
    DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle,
                             (long)TEXTDISP_PrimaryGroupEntryCount);
    DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle,
                             (long)TEXTDISP_PrimaryGroupRecordChecksum);
    DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle,
                             (long)TEXTDISP_PrimaryGroupRecordLength);

    for (n = 0; n < TEXTDISP_PrimaryGroupEntryCount; n++) {
        entry = TEXTDISP_PrimaryEntryPtrTable[n];
        title = TEXTDISP_PrimaryTitlePtrTable[n];

        DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, (char *)entry, 48L);
        DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, (char *)title,
                                  strlen((char *)title) + 1);

        for (s = 0; s < 49; s++) {
            if (title->slotText[s] == 0)
                continue;
            if (ESQ_TestBit1Based(entry->bits28, (long)s) != -1)
                continue;

            DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)s);
            DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle,
                                     (long)title->slotFlag[s]);
            DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle,
                                     (long)title->extA[s]);
            DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle,
                                     (long)title->extB[s]);
            DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle,
                                     (long)title->extC[s]);

            if (TEXTDISP_PrimaryGroupEntryCount > 100)
                text = DISKIO2_CopyAndSanitizeSlotString(scratch, entry, title,
                                                         (long)s);
            else
                text = title->slotText[s];

            DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, text,
                                      strlen(text) + 1);
        }

        DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)s);
    }

    DISKIO_CloseBufferedFileAndFlush(DISKIO2_OutputFileHandle);
    DISKIO_SaveOperationReadyFlag = 1;
    MEMORY_DeallocateMemory("DISKIO2.c", 275, scratch,
                                            1000);
    return 0;
}
