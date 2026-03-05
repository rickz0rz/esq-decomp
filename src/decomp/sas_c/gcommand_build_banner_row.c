typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

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
    LONG selected = (rowIndex > 0) ? rowIndex : fallbackIndex;
    LONG d4 = selected - 1;
    LONG rowOff = rowIndex << 5;
    UBYTE *table = tablePtr;
    ULONG addr;
    UWORD *dst;

    addr = (ULONG)(table + rowOff + 744);
    *(UWORD *)(table + 730) = (UWORD)((addr >> 16) & 0xFFFF);
    *(UWORD *)(table + 734) = (UWORD)(addr & 0xFFFF);

    addr = (ULONG)(*(ULONG *)(bitmapPtr + 8) + (ULONG)baseOffset);
    *(UWORD *)(table + 714) = (UWORD)((addr >> 16) & 0xFFFF);
    *(UWORD *)(table + 718) = (UWORD)(addr & 0xFFFF);

    addr = (ULONG)(*(ULONG *)(bitmapPtr + 12) + (ULONG)baseOffset);
    *(UWORD *)(table + 694) = (UWORD)((addr >> 16) & 0xFFFF);
    *(UWORD *)(table + 698) = (UWORD)(addr & 0xFFFF);

    addr = (ULONG)(*(ULONG *)(bitmapPtr + 16) + (ULONG)baseOffset);
    *(UWORD *)(table + 702) = (UWORD)((addr >> 16) & 0xFFFF);
    *(UWORD *)(table + 706) = (UWORD)(addr & 0xFFFF);

    dst = (UWORD *)(table + (d4 << 5) + 746);

    if (GCOMMAND_BannerRowFallbackOnFirstRowFlag != 0 && d4 <= 0) {
        *dst = 0x00F0;
        dst = (UWORD *)((UBYTE *)dst + 4);
        *dst = 0x00F0;
        dst = (UWORD *)((UBYTE *)dst + 4);
        *dst = 0x00F0;
        dst = (UWORD *)((UBYTE *)dst + 4);
        *dst = 0x00F0;
    } else {
        *dst = GCOMMAND_LoadPresetWord(GCOMMAND_PresetWorkEntryTable, GCOMMAND_PresetWorkEntry0_ValueIndex);
        dst = (UWORD *)((UBYTE *)dst + 4);
        *dst = GCOMMAND_LoadPresetWord(GCOMMAND_PresetWorkEntry1, GCOMMAND_PresetWorkEntry1_ValueIndex);
        dst = (UWORD *)((UBYTE *)dst + 4);
        *dst = GCOMMAND_LoadPresetWord(GCOMMAND_PresetWorkEntry2, GCOMMAND_PresetWorkEntry2_ValueIndex);
        dst = (UWORD *)((UBYTE *)dst + 4);
        *dst = GCOMMAND_LoadPresetWord(GCOMMAND_PresetWorkEntry3, GCOMMAND_PresetWorkEntry3_ValueIndex);
    }

    GCOMMAND_UpdateBannerRowPointers(table);
}
