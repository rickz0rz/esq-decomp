typedef signed long LONG;
typedef signed short WORD;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern WORD Global_UIBusyFlag;

extern LONG GCOMMAND_PresetWorkEntryTable;
extern LONG GCOMMAND_PresetWorkEntry1;
extern LONG GCOMMAND_PresetWorkEntry2;
extern LONG GCOMMAND_PresetWorkEntry3;

extern LONG GCOMMAND_PresetWorkEntry0_ValueIndex;
extern LONG GCOMMAND_PresetWorkEntry1_ValueIndex;
extern LONG GCOMMAND_PresetWorkEntry2_ValueIndex;
extern LONG GCOMMAND_PresetWorkEntry3_ValueIndex;

extern UBYTE GCOMMAND_PresetFallbackValue0;
extern UBYTE GCOMMAND_PresetFallbackValue1;
extern UBYTE GCOMMAND_PresetFallbackValue2;
extern UBYTE GCOMMAND_PresetFallbackValue3;
extern UBYTE GCOMMAND_PresetValueTable[];

extern LONG GCOMMAND_ComputePresetIncrement(LONG presetIndex, LONG span);
extern void GCOMMAND_InitPresetWorkEntry(void *entryPtr, LONG presetIndex, LONG span, LONG baseValue);
extern void GCOMMAND_TickPresetWorkEntries(void);

static UWORD GCOMMAND_LoadColorOrFallback(LONG presetBase, LONG valueIndex, UBYTE fallback)
{
    if (valueIndex < 0) {
        return (UWORD)fallback;
    }
    return *(UWORD *)(GCOMMAND_PresetValueTable + (presetBase << 7) + (valueIndex << 1));
}

UBYTE *GCOMMAND_BuildBannerBlock(UBYTE *tablePtr, LONG count, UBYTE *srcBytePtr, UBYTE byte1, UWORD word2, UBYTE stepByte)
{
    LONG seed;
    UBYTE *out = tablePtr;
    LONG i;

    if (Global_UIBusyFlag != 0) {
        seed = 0;
    } else {
        seed = count;
    }

    GCOMMAND_InitPresetWorkEntry((void *)&GCOMMAND_PresetWorkEntryTable, 0, seed, GCOMMAND_ComputePresetIncrement(0, seed));
    GCOMMAND_InitPresetWorkEntry((void *)&GCOMMAND_PresetWorkEntry1, 5, seed, GCOMMAND_ComputePresetIncrement(5, seed));
    GCOMMAND_InitPresetWorkEntry((void *)&GCOMMAND_PresetWorkEntry2, 6, seed, GCOMMAND_ComputePresetIncrement(6, seed));
    GCOMMAND_InitPresetWorkEntry((void *)&GCOMMAND_PresetWorkEntry3, 7, seed, GCOMMAND_ComputePresetIncrement(7, seed));

    for (i = 0; i < count; ++i) {
        UWORD c0 = GCOMMAND_LoadColorOrFallback(GCOMMAND_PresetWorkEntryTable, GCOMMAND_PresetWorkEntry0_ValueIndex, GCOMMAND_PresetFallbackValue0);
        UWORD c1 = GCOMMAND_LoadColorOrFallback(GCOMMAND_PresetWorkEntry1, GCOMMAND_PresetWorkEntry1_ValueIndex, GCOMMAND_PresetFallbackValue1);
        UWORD c2 = GCOMMAND_LoadColorOrFallback(GCOMMAND_PresetWorkEntry2, GCOMMAND_PresetWorkEntry2_ValueIndex, GCOMMAND_PresetFallbackValue2);
        UWORD c3 = GCOMMAND_LoadColorOrFallback(GCOMMAND_PresetWorkEntry3, GCOMMAND_PresetWorkEntry3_ValueIndex, GCOMMAND_PresetFallbackValue3);
        UBYTE *next = out + 32;
        ULONG p = (ULONG)next;

        out[0] = *srcBytePtr;
        *srcBytePtr = (UBYTE)(*srcBytePtr + stepByte);
        out[1] = byte1;
        *(UWORD *)(out + 2) = word2;
        *(UWORD *)(out + 4) = 0x0188;
        *(UWORD *)(out + 6) = c0;
        *(UWORD *)(out + 8) = 0x018A;
        *(UWORD *)(out + 10) = c1;
        *(UWORD *)(out + 12) = 0x018C;
        *(UWORD *)(out + 14) = c2;
        *(UWORD *)(out + 16) = 0x018E;
        *(UWORD *)(out + 18) = c3;
        *(UWORD *)(out + 20) = 0x0084;
        *(UWORD *)(out + 22) = (UWORD)((p >> 16) & 0xFFFF);
        *(UWORD *)(out + 24) = 0x0086;
        *(UWORD *)(out + 26) = (UWORD)(p & 0xFFFF);
        *(UWORD *)(out + 28) = 0x008A;
        *(UWORD *)(out + 30) = 0;

        GCOMMAND_TickPresetWorkEntries();
        out += 32;
    }

    return out;
}
