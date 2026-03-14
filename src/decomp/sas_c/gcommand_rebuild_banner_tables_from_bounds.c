#include <exec/types.h>
extern WORD Global_UIBusyFlag;

extern UBYTE ESQ_CopperListBannerA[];
extern UBYTE ESQ_CopperListBannerB[];

extern LONG GCOMMAND_BannerStepLeft;
extern LONG GCOMMAND_BannerStepTop;
extern LONG GCOMMAND_BannerStepRight;
extern LONG GCOMMAND_BannerStepBottom;

extern LONG GCOMMAND_BannerBoundLeft;
extern LONG GCOMMAND_BannerBoundTop;
extern LONG GCOMMAND_BannerBoundRight;
extern LONG GCOMMAND_BannerBoundBottom;

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
extern WORD GCOMMAND_BannerRebuildPendingFlag;

extern void GCOMMAND_InitPresetWorkEntry(void *entryPtr, LONG presetIndex, LONG span, LONG baseValue);
extern void GCOMMAND_TickPresetWorkEntries(void);

typedef struct GCOMMAND_PresetRow {
    UWORD values[64];
} GCOMMAND_PresetRow;

typedef struct GCOMMAND_BannerRow {
    UBYTE pad0[6];
    UWORD value0;
    UBYTE pad8[2];
    UWORD value1;
    UBYTE pad12[2];
    UWORD value2;
    UBYTE pad16[2];
    UWORD value3;
    UBYTE pad20[12];
} GCOMMAND_BannerRow;

static UWORD GCOMMAND_LoadPresetValueOrFallback(LONG presetId, LONG valueIndex, UBYTE fallback)
{
    LONG presetBase;
    GCOMMAND_PresetRow *rows;

    if (valueIndex < 0) {
        return (UWORD)fallback;
    }

    if (presetId == 0) {
        presetBase = GCOMMAND_PresetWorkEntryTable;
    } else if (presetId == 1) {
        presetBase = GCOMMAND_PresetWorkEntry1;
    } else if (presetId == 2) {
        presetBase = GCOMMAND_PresetWorkEntry2;
    } else {
        presetBase = GCOMMAND_PresetWorkEntry3;
    }

    rows = (GCOMMAND_PresetRow *)GCOMMAND_PresetValueTable;
    return rows[presetBase].values[valueIndex];
}

void GCOMMAND_RebuildBannerTablesFromBounds(void)
{
    LONG seed;
    LONG row;
    GCOMMAND_BannerRow *tableA;
    GCOMMAND_BannerRow *tableB;

    tableA = (GCOMMAND_BannerRow *)(ESQ_CopperListBannerA + 0x80);
    tableB = (GCOMMAND_BannerRow *)(ESQ_CopperListBannerB + 0x80);

    if (Global_UIBusyFlag != 0) {
        seed = 0;
    } else {
        seed = 17;
    }

    GCOMMAND_InitPresetWorkEntry((void *)&GCOMMAND_PresetWorkEntryTable, GCOMMAND_BannerBoundLeft, seed, GCOMMAND_BannerStepLeft);
    GCOMMAND_InitPresetWorkEntry((void *)&GCOMMAND_PresetWorkEntry1, GCOMMAND_BannerBoundTop, seed, GCOMMAND_BannerStepTop);
    GCOMMAND_InitPresetWorkEntry((void *)&GCOMMAND_PresetWorkEntry2, GCOMMAND_BannerBoundRight, seed, GCOMMAND_BannerStepRight);
    GCOMMAND_InitPresetWorkEntry((void *)&GCOMMAND_PresetWorkEntry3, GCOMMAND_BannerBoundBottom, seed, GCOMMAND_BannerStepBottom);

    for (row = 0; row < 17; ++row) {
        UWORD v0 = GCOMMAND_LoadPresetValueOrFallback(0, GCOMMAND_PresetWorkEntry0_ValueIndex, GCOMMAND_PresetFallbackValue0);
        UWORD v1 = GCOMMAND_LoadPresetValueOrFallback(1, GCOMMAND_PresetWorkEntry1_ValueIndex, GCOMMAND_PresetFallbackValue1);
        UWORD v2 = GCOMMAND_LoadPresetValueOrFallback(2, GCOMMAND_PresetWorkEntry2_ValueIndex, GCOMMAND_PresetFallbackValue2);
        UWORD v3 = GCOMMAND_LoadPresetValueOrFallback(3, GCOMMAND_PresetWorkEntry3_ValueIndex, GCOMMAND_PresetFallbackValue3);

        tableA[row].value0 = v0;
        tableB[row].value0 = v0;
        tableA[row].value1 = v1;
        tableB[row].value1 = v1;
        tableA[row].value2 = v2;
        tableB[row].value2 = v2;
        tableA[row].value3 = v3;
        tableB[row].value3 = v3;

        GCOMMAND_TickPresetWorkEntries();
    }

    GCOMMAND_BannerRebuildPendingFlag = 0;
}
