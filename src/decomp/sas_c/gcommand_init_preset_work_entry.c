#include <exec/types.h>
typedef struct {
    LONG presetIndex;
    LONG currentValue;
    LONG step;
    LONG baseValue;
    LONG phase;
    LONG mode;
} PresetWorkEntry;

extern void GCOMMAND_SetPresetEntry(LONG row, LONG value);
extern UWORD GCOMMAND_DefaultPresetTable[];

void GCOMMAND_InitPresetWorkEntry(PresetWorkEntry *entry, LONG presetIndex, LONG span, LONG baseValue)
{
    const LONG PRESET_INDEX_MIN = 0;
    const LONG PRESET_INDEX_MAX = 16;
    const LONG PRESET_FALLBACK_INDEX = 6;
    const LONG PRESET_FALLBACK_VALUE = 1365;
    const LONG SPAN_THRESHOLD = 4;
    const LONG MODE_SPANNED = 2;
    const LONG STEP_ONE = 1;
    const LONG ZERO = 0;

    if (presetIndex < PRESET_INDEX_MIN || presetIndex >= PRESET_INDEX_MAX) {
        entry->presetIndex = PRESET_FALLBACK_INDEX;
        entry->phase = ZERO;
        entry->baseValue = ZERO;
        entry->currentValue = ZERO;
        entry->mode = ZERO;
        entry->step = ZERO;
        GCOMMAND_SetPresetEntry(PRESET_FALLBACK_INDEX, PRESET_FALLBACK_VALUE);
        return;
    }

    entry->presetIndex = presetIndex;
    entry->phase = ZERO;

    if (span > SPAN_THRESHOLD) {
        entry->baseValue = baseValue;
        entry->currentValue = (LONG)GCOMMAND_DefaultPresetTable[presetIndex] - STEP_ONE;
        entry->mode = MODE_SPANNED;
        entry->step = STEP_ONE;
        return;
    }

    if (span >= PRESET_INDEX_MIN) {
        entry->baseValue = ZERO;
        entry->currentValue = ZERO;
        entry->mode = ZERO;
        entry->step = ZERO;
    }
}
