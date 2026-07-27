/* RESTORES: GCOMMAND_LoadPPVTemplate
 * MODULE:   modules/groups/a/s/gcommand_gcommand_loadppvtemplate.s
 * STATUS:   behavioural
 *
 * Serialises the Digital PPV parameter block to DF0:Digital_PPV3.dat. The two
 * trailing template pointers are stashed, zeroed, the whole 56-byte record is
 * written, and then the pointers are put back and the two strings appended -- the
 * first without its terminator and separated by a 0x12 byte, the second with its
 * terminator. Zeroing before the write is what keeps host addresses out of the
 * file; restoring afterwards is what keeps the live record usable.
 *
 * 182 bytes in the original, 180 emitted, 5 differing regions -- and the -2 is
 * fully itemised below: +6 in the frame, -8 from the stashed pointers living in
 * registers. Every other region is the same instruction on a different base.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffbc 2f07              LINK.W A5,#-68 / MOVE.L D7,-(A7)
 *   got:     9efc0038 48e70114          SUBA.W #56,A7 / MOVEM.L D7/A3/A5,-(A7)
 *   summary: The A5-frame class. The original reserves A5 as a frame pointer and
 *            addresses the record at -68(A5); 6.51 frees A5, adjusts A7 directly
 *            and addresses the record at 56(A7). Costs +2 in the prologue and +4
 *            in the epilogue.
 *   scope:   program-wide; 364 LINK.W A5 sites in the original, 0 MOVEM masks
 *            including A5. See docs/compiler-version.md.
 *   retest:  a compiler that reserves A5 fixes the frame and the register
 *            allocation below at the same time.
 *
 * SASC-MISMATCH: stashed-pointers-in-freed-registers
 *   ref:     2b6dffecfff8 ... 2b6dfff4ffe8  both template pointers saved and
 *                                           restored through -8(A5)/-12(A5)
 *   got:     2a6f003c 266f0038 ... 2f4b0044 the same values held in A5 and A3
 *   summary: A consequence of the frame class rather than an independent one:
 *            with no frame pointer, A5 and A3 are free, so the two stashed
 *            pointers never reach memory. 26 bytes in the original against 18
 *            emitted, which is the -8.
 *   retest:  same fix as above -- reserving A5 forces both back to stack slots.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     91edffec                  SUBA.L -20(A5),A0
 *   got:     2008 ... 91c0             MOVE.L A0,D0 / SUBA.L D0,A0
 *   summary: Both inlined strlen sites: the original re-reads the struct member
 *            to recover the scan base, 6.51 keeps a copy in D0. Two bytes each
 *            way at both sites, so this class costs nothing here.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the five cross-unit calls.
 */
#include <string.h>

struct PpvParams {
    short  enabled;                 /*  0 */
    long   modeCycleCount;          /*  2 */
    long   selectionWindowMinutes;  /*  6 */
    long   selectionToleranceMins;  /* 10 */
    long   messageTextPen;          /* 14 */
    long   messageFramePen;         /* 18 */
    long   editorLayoutPen;         /* 22 */
    long   editorRowPen;            /* 26 */
    long   showtimesLayoutPen;      /* 30 */
    long   showtimesInitialLine;    /* 34 */
    long   showtimesRowPen;         /* 38 */
    char   showtimesWorkflowMode;   /* 42 */
    char   detailLayoutFlag;        /* 43 */
    char  *listingsTemplate;        /* 44 */
    char  *periodTemplate;          /* 48 */
    long   showtimesRowSpan;        /* 52 */
};                                  /* 56 */

extern long DISKIO_OpenFileWithBuffer(char *path, long mode);
extern void DISKIO_WriteBufferedBytes(long fh, char *p, long len);
extern void DISKIO_CloseBufferedFileAndFlush(long fh);

extern struct PpvParams GCOMMAND_DigitalPpvEnabledFlag;
extern char GCOMMAND_PpvTemplateFieldSeparatorByteStorage[];
extern char GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplateSave[];

void GCOMMAND_LoadPPVTemplate(void)
{
    struct PpvParams rec;
    char *savedPeriod;
    char *savedListings;
    long fh;

    fh = DISKIO_OpenFileWithBuffer(
             GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplateSave, 1006L);
    if (fh == 0)
        return;

    rec = GCOMMAND_DigitalPpvEnabledFlag;
    savedPeriod = rec.periodTemplate;
    savedListings = rec.listingsTemplate;
    rec.periodTemplate = rec.listingsTemplate = 0;
    DISKIO_WriteBufferedBytes(fh, (char *)&rec, (long)sizeof(rec));

    rec.periodTemplate = savedPeriod;
    rec.listingsTemplate = savedListings;
    DISKIO_WriteBufferedBytes(fh, rec.periodTemplate, (long)strlen(rec.periodTemplate));
    DISKIO_WriteBufferedBytes(fh, GCOMMAND_PpvTemplateFieldSeparatorByteStorage, 1L);
    DISKIO_WriteBufferedBytes(fh, rec.listingsTemplate,
                              (long)strlen(rec.listingsTemplate) + 1);
    DISKIO_CloseBufferedFileAndFlush(fh);
}
