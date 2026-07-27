/* RESTORES: DISKIO2_WriteQTableIniFile
 * MODULE:   modules/groups/a/h/diskio2.s
 * STATUS:   behavioural
 *
 * Serialises the alias table to QTABLE.INI as a section header followed by one
 * quoted key=value line per alias. Every field is written with an explicit
 * length rather than a terminator, so the six writes per entry are the six
 * pieces of the line.
 *
 * The alias count is checked twice -- once before opening and once after. The
 * second check is not redundant in the original's terms: it returns -1 with the
 * file already open and never closed, which is a leak the original has and this
 * reproduces.
 *
 * 328 bytes in the original, 322 emitted plus one alignment NOP. Itemised in full
 * by tools/casm.py and all of it is the frame class plus one block reordering:
 * the header pointer and the current entry live at -4(A5) and -8(A5) in the
 * original and in registers here, which is -4, -2, -2, -2, -2 and -4 at the
 * individual accesses.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff4 2f07 / 2b7c...fffc / 206dfffc / 2f2dfffc / 2b50fff8
 *            / 226dfff8 (x2) / 2e2dfff0 4e5d
 *   got:     the two pointers held in registers throughout
 *   summary: The A5-frame class. Note the original's epilogue restores D7 with
 *            MOVE.L -16(A5),D7 rather than popping it -- the UNLK reclaims the
 *            stack, so the push never needs a matching pop.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: block-ordering
 *   summary: The two early -1 exits are placed differently. casm reports it as
 *            -12/+22/-8/+4; same instructions, different order.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the eleven cross-unit calls.
 */
#include <string.h>

extern long DISKIO_OpenFileWithBuffer(char *path, long mode);
extern void DISKIO_WriteBufferedBytes(long fh, char *p, long len);
extern long DISKIO_CloseBufferedFileAndFlush(long fh);

extern long DISKIO2_QTableIniFileHandle;
extern short TEXTDISP_AliasCount;

struct AliasEntry {
    char *key;      /* 0 */
    char *value;    /* 4 */
};

extern struct AliasEntry *TEXTDISP_AliasPtrTable[];

extern char CTASKS_PATH_QTABLE_INI[];
extern char DISKIO2_STR_QTABLE[];
extern char DISKIO2_STR_QTableLineBreakAfterHeader[];
extern char DISKIO2_STR_QTableEquals[];
extern char DISKIO2_STR_QTableValueQuoteOpen[];
extern char DISKIO2_STR_QTableValueQuoteClose[];
extern char DISKIO2_STR_QTableLineBreakAfterEntry[];

long DISKIO2_WriteQTableIniFile(void)
{
    char *header;
    struct AliasEntry *entry;
    unsigned short i;

    header = DISKIO2_STR_QTABLE;

    if (TEXTDISP_AliasCount < 1)
        return -1;

    DISKIO2_QTableIniFileHandle =
        DISKIO_OpenFileWithBuffer(CTASKS_PATH_QTABLE_INI, 1006L);
    if (DISKIO2_QTableIniFileHandle == 0)
        return -1;
    if (TEXTDISP_AliasCount == 0)
        return -1;

    DISKIO_WriteBufferedBytes(DISKIO2_QTableIniFileHandle, header,
                              (long)strlen(header));
    DISKIO_WriteBufferedBytes(DISKIO2_QTableIniFileHandle,
                              DISKIO2_STR_QTableLineBreakAfterHeader, 2L);

    for (i = 0; i < TEXTDISP_AliasCount; i++) {
        entry = TEXTDISP_AliasPtrTable[i];
        DISKIO_WriteBufferedBytes(DISKIO2_QTableIniFileHandle, entry->key,
                                  (long)strlen(entry->key));
        DISKIO_WriteBufferedBytes(DISKIO2_QTableIniFileHandle,
                                  DISKIO2_STR_QTableEquals, 1L);
        DISKIO_WriteBufferedBytes(DISKIO2_QTableIniFileHandle,
                                  DISKIO2_STR_QTableValueQuoteOpen, 1L);
        DISKIO_WriteBufferedBytes(DISKIO2_QTableIniFileHandle, entry->value,
                                  (long)strlen(entry->value));
        DISKIO_WriteBufferedBytes(DISKIO2_QTableIniFileHandle,
                                  DISKIO2_STR_QTableValueQuoteClose, 1L);
        DISKIO_WriteBufferedBytes(DISKIO2_QTableIniFileHandle,
                                  DISKIO2_STR_QTableLineBreakAfterEntry, 2L);
    }

    return DISKIO_CloseBufferedFileAndFlush(DISKIO2_QTableIniFileHandle);
}
