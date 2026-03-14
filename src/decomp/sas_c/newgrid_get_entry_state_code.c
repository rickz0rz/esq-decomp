#include <exec/types.h>
typedef struct NEWGRID_Entry {
    UBYTE pad0[28];
    UBYTE selectionBits[1];
} NEWGRID_Entry;

extern LONG ESQ_TestBit1Based(const UBYTE *bitset, LONG bitIndex);

LONG NEWGRID_GetEntryStateCode(const void *gridCtx, const void *entryAuxBase, WORD rowIndex)
{
    const NEWGRID_Entry *entry;
    const UBYTE *aux;
    const char * const *titleTable;
    LONG row;

    row = (LONG)rowIndex;
    if (gridCtx == 0 || entryAuxBase == 0 || row <= 0 || row >= 49) {
        return 1;
    }

    entry = (const NEWGRID_Entry *)gridCtx;
    aux = (const UBYTE *)entryAuxBase;
    titleTable = (const char * const *)(aux + 56);

    if (ESQ_TestBit1Based(entry->selectionBits, row) + 1 != 0) {
        return 0;
    }

    if (titleTable[row] == 0) {
        return 3;
    }

    if ((aux[7 + row] & 0x80) == 0) {
        return 2;
    }

    return 3;
}
