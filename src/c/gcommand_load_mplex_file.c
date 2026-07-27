/* RESTORES: GCOMMAND_LoadMplexFile
 * MODULE:   modules/groups/a/s/gcommand_gcommand_loadmplexfile.s
 * STATUS:   behavioural
 *
 * Serialises the Digital Mplex parameter block to DF0:Digital_Mplex.dat. The two
 * trailing template pointers are stashed, zeroed, the whole 52-byte record is
 * written, and then the pointers are put back and the two strings appended -- the
 * first without its terminator and separated by a 0x12 byte, the second with its
 * terminator. Zeroing before the write is what keeps host addresses out of the
 * file; restoring afterwards is what keeps the live record usable.
 *
 * 182 bytes in the original, 180 emitted, 6 differing regions -- and the -2 is
 * fully itemised below: +6 in the frame, -8 from the stashed pointers living in
 * registers. Every other region is the same instruction on a different base.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffc0 2f07              LINK.W A5,#-64 / MOVE.L D7,-(A7)
 *   got:     9efc0034 48e70114          SUBA.W #52,A7 / MOVEM.L D7/A3/A5,-(A7)
 *   summary: The A5-frame class. The original reserves A5 as a frame pointer and
 *            addresses the record at -64(A5); 6.51 frees A5, adjusts A7 directly
 *            and addresses the record at 52(A7). Costs +2 in the prologue and +4
 *            in the epilogue.
 *   scope:   program-wide; 364 LINK.W A5 sites in the original, 0 MOVEM masks
 *            including A5. See docs/compiler-version.md.
 *   retest:  a compiler that reserves A5 fixes the frame and the register
 *            allocation below at the same time.
 *
 * SASC-MISMATCH: stashed-pointers-in-freed-registers
 *   ref:     2b6dfff0fff8 ... 2b6dfff4ffec  both template pointers saved and
 *                                           restored through -8(A5)/-12(A5)
 *   got:     2a6f003c 266f0038 ... 2f4b0044 the same values held in A5 and A3
 *   summary: A consequence of the frame class rather than an independent one:
 *            with no frame pointer, A5 and A3 are free, so the two stashed
 *            pointers never reach memory. 26 bytes in the original against 18
 *            emitted, which is the -8.
 *   retest:  same fix as above -- reserving A5 forces both back to stack slots.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     91edfff0                  SUBA.L -16(A5),A0
 *   got:     2008 ... 91c0             MOVE.L A0,D0 / SUBA.L D0,A0
 *   summary: Both inlined strlen sites: the original re-reads the struct member
 *            to recover the scan base, 6.51 keeps a copy in D0. Two bytes each
 *            way at both sites, so this class costs nothing here.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the five cross-unit calls.
 */
#include <string.h>

struct MplexParams {
    short  enabled;                 /*  0 */
    long   modeCycleCount;          /*  2 */
    long   searchRowLimit;          /*  6 */
    long   clockOffsetMinutes;      /* 10 */
    long   messageTextPen;          /* 14 */
    long   messageFramePen;         /* 18 */
    long   editorLayoutPen;         /* 22 */
    long   editorRowPen;            /* 26 */
    long   detailLayoutPen;         /* 30 */
    long   detailInitialLineIndex;  /* 34 */
    long   detailRowPen;            /* 38 */
    char   workflowMode;            /* 42 */
    char   detailLayoutFlag;        /* 43 */
    char  *listingsTemplate;        /* 44 */
    char  *atTemplate;              /* 48 */
};                                  /* 52 */

extern long DISKIO_OpenFileWithBuffer(char *path, long mode);
extern void DISKIO_WriteBufferedBytes(long fh, char *p, long len);
extern void DISKIO_CloseBufferedFileAndFlush(long fh);

extern struct MplexParams GCOMMAND_DigitalMplexEnabledFlag;
extern char GCOMMAND_MplexTemplateFieldSeparatorByteStorage[];
extern char GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateSave[];

void GCOMMAND_LoadMplexFile(void)
{
    struct MplexParams rec;
    char *savedAt;
    char *savedListings;
    long fh;

    fh = DISKIO_OpenFileWithBuffer(
             GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateSave, 1006L);
    if (fh == 0)
        return;

    rec = GCOMMAND_DigitalMplexEnabledFlag;
    savedAt = rec.atTemplate;
    savedListings = rec.listingsTemplate;
    rec.atTemplate = rec.listingsTemplate = 0;
    DISKIO_WriteBufferedBytes(fh, (char *)&rec, (long)sizeof(rec));

    rec.atTemplate = savedAt;
    rec.listingsTemplate = savedListings;
    DISKIO_WriteBufferedBytes(fh, rec.atTemplate, (long)strlen(rec.atTemplate));
    DISKIO_WriteBufferedBytes(fh, GCOMMAND_MplexTemplateFieldSeparatorByteStorage, 1L);
    DISKIO_WriteBufferedBytes(fh, rec.listingsTemplate,
                              (long)strlen(rec.listingsTemplate) + 1);
    DISKIO_CloseBufferedFileAndFlush(fh);
}
