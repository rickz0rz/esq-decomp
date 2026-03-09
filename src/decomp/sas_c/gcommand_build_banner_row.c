typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

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
    UBYTE *p = GCOMMAND_PresetValueTable + (presetBase << 7) + (valueIndex << 1);
    return *(UWORD *)p;
}

void GCOMMAND_BuildBannerRow(UBYTE *bitmapPtr, UBYTE *tablePtr, LONG rowIndex, LONG fallbackIndex, LONG baseOffset)
{
    GCOMMAND_Bitmap *bitmapView;
    LONG selected = (rowIndex > 0) ? rowIndex : fallbackIndex;
    LONG d4 = selected - 1;
    LONG rowOff = rowIndex << 5;
    UBYTE *table = tablePtr;
    ULONG addr;
    GCOMMAND_BannerRowColors *rowColors;

    bitmapView = (GCOMMAND_Bitmap *)bitmapPtr;

    addr = (ULONG)(table + rowOff + 744);
    *(UWORD *)(table + 730) = (UWORD)((addr >> 16) & 0xFFFF);
    *(UWORD *)(table + 734) = (UWORD)(addr & 0xFFFF);

    addr = (ULONG)(bitmapView->plane0Ptr + (ULONG)baseOffset);
    *(UWORD *)(table + 714) = (UWORD)((addr >> 16) & 0xFFFF);
    *(UWORD *)(table + 718) = (UWORD)(addr & 0xFFFF);

    addr = (ULONG)(bitmapView->plane1Ptr + (ULONG)baseOffset);
    *(UWORD *)(table + 694) = (UWORD)((addr >> 16) & 0xFFFF);
    *(UWORD *)(table + 698) = (UWORD)(addr & 0xFFFF);

    addr = (ULONG)(bitmapView->plane2Ptr + (ULONG)baseOffset);
    *(UWORD *)(table + 702) = (UWORD)((addr >> 16) & 0xFFFF);
    *(UWORD *)(table + 706) = (UWORD)(addr & 0xFFFF);

    rowColors = (GCOMMAND_BannerRowColors *)(table + (d4 << 5) + 746);

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

    GCOMMAND_UpdateBannerRowPointers(table);
}
