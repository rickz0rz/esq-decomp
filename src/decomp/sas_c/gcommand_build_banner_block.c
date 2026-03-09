typedef signed long LONG;
typedef signed short WORD;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct GCOMMAND_BannerBlock {
    UBYTE lineByte0;
    UBYTE lineByte1;
    UWORD lineWord2;
    UWORD colorReg0188;
    UWORD colorValue0;
    UWORD colorReg018A;
    UWORD colorValue1;
    UWORD colorReg018C;
    UWORD colorValue2;
    UWORD colorReg018E;
    UWORD colorValue3;
    UWORD ptrReg0084;
    UWORD ptrHi;
    UWORD ptrReg0086;
    UWORD ptrLo;
    UWORD termReg008A;
    UWORD termValue;
} GCOMMAND_BannerBlock;

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
    GCOMMAND_BannerBlock *out = (GCOMMAND_BannerBlock *)tablePtr;
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
        GCOMMAND_BannerBlock *next = out + 1;
        ULONG p = (ULONG)next;

        out->lineByte0 = *srcBytePtr;
        *srcBytePtr = (UBYTE)(*srcBytePtr + stepByte);
        out->lineByte1 = byte1;
        out->lineWord2 = word2;
        out->colorReg0188 = 0x0188;
        out->colorValue0 = c0;
        out->colorReg018A = 0x018A;
        out->colorValue1 = c1;
        out->colorReg018C = 0x018C;
        out->colorValue2 = c2;
        out->colorReg018E = 0x018E;
        out->colorValue3 = c3;
        out->ptrReg0084 = 0x0084;
        out->ptrHi = (UWORD)((p >> 16) & 0xFFFF);
        out->ptrReg0086 = 0x0086;
        out->ptrLo = (UWORD)(p & 0xFFFF);
        out->termReg008A = 0x008A;
        out->termValue = 0;

        GCOMMAND_TickPresetWorkEntries();
        out = next;
    }

    return (UBYTE *)out;
}
