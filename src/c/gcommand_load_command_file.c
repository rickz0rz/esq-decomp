/* RESTORES: GCOMMAND_LoadCommandFile
 * MODULE:   modules/groups/a/s/gcommand.s
 * STATUS:   behavioural
 *
 * Despite the name this WRITES the command file: it opens with MODE_NEWFILE
 * (0x3EE), dumps a 32-byte copy of the niche state, then the listings string,
 * then closes and flushes.
 *
 * The 32-byte copy is a STRUCT ASSIGNMENT -- MOVEQ #7 / MOVE.L (A0)+,(A1)+ /
 * DBF, eight longs. AGENTS.md records that struct assignment gives the MOVE.L
 * loop where memcpy of the same bytes gives a MOVE.B loop, so the local is
 * declared with the struct type.
 *
 * The listings pointer is lifted OUT of the copy and the copy's own field is
 * zeroed before the write, so the file never contains a live pointer. That is
 * the whole reason the function takes a copy rather than writing the global.
 *
 * The string is written with strlen + 1, terminator included.
 *
 * 120 ref vs 116 got. The 32-byte struct copy is VERBATIM (7007 22d8 51c8fffc),
 * which is the evidence the struct-assignment form is right here rather than
 * memcpy. So are the PEA $3ee open mode, the PEA 32 length, the inline strlen,
 * the ADDQ.L #1, the argument-slot reuse (2e80 / 2e87) and the LEA 20(A7),A7.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffd8 ... 4e5d       LINK.W A5,#-40 / UNLK
 *   got:     9efc0020 ... defc0020   SUBA.W #32,A7 / ADDA.W #32,A7
 *   summary: the frame class, and 6.51 takes 32 bytes where the original takes
 *            40 -- the original reserves two extra longwords it uses as spill
 *            slots for the listings pointer, which 6.51 keeps in an address
 *            register (204d / 91cd against 206dfff8 / 91edfff4).
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-dos.h"
#include <string.h>

struct GCommandNicheState {
    char  pad0[28];
    char *listings;             /* +28 */
};

extern BPTR GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(char *path, long mode);
extern long GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(BPTR fh, char *src,
                                                      long len);
extern void GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(BPTR fh);

extern struct GCommandNicheState GCOMMAND_DigitalNicheEnabledFlag;
extern char GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile[];

void GCOMMAND_LoadCommandFile(void)
{
    struct GCommandNicheState tmp;
    char *listings;
    BPTR  fh;

    fh = GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(
        GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile, 0x3eeL);
    if (fh == 0)
        return;

    tmp = GCOMMAND_DigitalNicheEnabledFlag;

    listings     = tmp.listings;
    tmp.listings = 0;

    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(fh, (char *)&tmp, 32L);
    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(fh, listings,
                                              (long)strlen(listings) + 1);
    GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(fh);
}
