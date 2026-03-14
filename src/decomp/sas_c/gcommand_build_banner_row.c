#include <exec/types.h>
typedef struct GCOMMAND_Bitmap {
    UBYTE pad0[8];
    ULONG plane0Ptr;
    ULONG plane1Ptr;
    ULONG plane2Ptr;
} GCOMMAND_Bitmap;

typedef struct GCOMMAND_BannerRowColors {
    UWORD color0;
    UWORD pad2;
    UWORD color1;
    UWORD pad6;
    UWORD color2;
    UWORD pad10;
    UWORD color3;
} GCOMMAND_BannerRowColors;

typedef struct GCOMMAND_PresetRow {
    UWORD values[64];
} GCOMMAND_PresetRow;

typedef struct GCOMMAND_BannerTable {
    UBYTE pad0[694];
    UWORD plane1Hi;
    UWORD pad696;
    UWORD plane1Lo;
    UWORD pad700;
    UWORD plane2Hi;
    UWORD pad704;
    UWORD plane2Lo;
    UBYTE pad708[6];
    UWORD plane0Hi;
    UWORD pad716;
    UWORD plane0Lo;
    UBYTE pad720[10];
    UWORD rowPtrHi;
    UWORD pad732;
    UWORD rowPtrLo;
    UBYTE pad736[10];
    GCOMMAND_BannerRowColors rowColors[17];
} GCOMMAND_BannerTable;

extern LONG GCOMMAND_PresetWorkEntryTable;
extern LONG GCOMMAND_PresetWorkEntry1;
extern LONG GCOMMAND_PresetWorkEntry2;
extern LONG GCOMMAND_PresetWorkEntry3;

extern LONG GCOMMAND_PresetWorkEntry0_ValueIndex;
extern LONG GCOMMAND_PresetWorkEntry1_ValueIndex;
extern LONG GCOMMAND_PresetWorkEntry2_ValueIndex;
extern LONG GCOMMAND_PresetWorkEntry3_ValueIndex;

extern UBYTE GCOMMAND_PresetValueTable[];
extern UWORD GCOMMAND_BannerRowFallbackOnFirstRowFlag;

extern void GCOMMAND_UpdateBannerRowPointers(void *tablePtr);

static UWORD GCOMMAND_LoadPresetWord(LONG presetBase, LONG valueIndex)
{
    return ((GCOMMAND_PresetRow *)GCOMMAND_PresetValueTable)[presetBase].values[valueIndex];
}

void GCOMMAND_BuildBannerRow(UBYTE *bitmapPtr, UBYTE *tablePtr, LONG rowIndex, LONG fallbackIndex, LONG baseOffset)
{
    GCOMMAND_BannerTable *tableView;
    GCOMMAND_Bitmap *bitmapView;
    LONG selected = (rowIndex > 0) ? rowIndex : fallbackIndex;
    LONG d4 = selected - 1;
    LONG rowOff = rowIndex << 5;
    ULONG addr;
    GCOMMAND_BannerRowColors *rowColors;

    bitmapView = (GCOMMAND_Bitmap *)bitmapPtr;
    tableView = (GCOMMAND_BannerTable *)tablePtr;

    addr = (ULONG)(tablePtr + rowOff + 744);
    tableView->rowPtrHi = (UWORD)((addr >> 16) & 0xFFFF);
    tableView->rowPtrLo = (UWORD)(addr & 0xFFFF);

    addr = (ULONG)(bitmapView->plane0Ptr + (ULONG)baseOffset);
    tableView->plane0Hi = (UWORD)((addr >> 16) & 0xFFFF);
    tableView->plane0Lo = (UWORD)(addr & 0xFFFF);

    addr = (ULONG)(bitmapView->plane1Ptr + (ULONG)baseOffset);
    tableView->plane1Hi = (UWORD)((addr >> 16) & 0xFFFF);
    tableView->plane1Lo = (UWORD)(addr & 0xFFFF);

    addr = (ULONG)(bitmapView->plane2Ptr + (ULONG)baseOffset);
    tableView->plane2Hi = (UWORD)((addr >> 16) & 0xFFFF);
    tableView->plane2Lo = (UWORD)(addr & 0xFFFF);

    rowColors = &tableView->rowColors[d4];

    if (GCOMMAND_BannerRowFallbackOnFirstRowFlag != 0 && d4 <= 0) {
        rowColors->color0 = 0x00F0;
        rowColors->color1 = 0x00F0;
        rowColors->color2 = 0x00F0;
        rowColors->color3 = 0x00F0;
    } else {
        rowColors->color0 = GCOMMAND_LoadPresetWord(GCOMMAND_PresetWorkEntryTable, GCOMMAND_PresetWorkEntry0_ValueIndex);
        rowColors->color1 = GCOMMAND_LoadPresetWord(GCOMMAND_PresetWorkEntry1, GCOMMAND_PresetWorkEntry1_ValueIndex);
        rowColors->color2 = GCOMMAND_LoadPresetWord(GCOMMAND_PresetWorkEntry2, GCOMMAND_PresetWorkEntry2_ValueIndex);
        rowColors->color3 = GCOMMAND_LoadPresetWord(GCOMMAND_PresetWorkEntry3, GCOMMAND_PresetWorkEntry3_ValueIndex);
    }

    GCOMMAND_UpdateBannerRowPointers(tablePtr);
}
