#include <exec/types.h>
typedef struct {
    LONG presetIndex;
    LONG currentValue;
    LONG step;
    LONG baseValue;
    LONG phase;
    LONG mode;
} PresetWorkEntry;

extern PresetWorkEntry GCOMMAND_PresetWorkEntryTable[];

void GCOMMAND_TickPresetWorkEntries(void)
{
    LONG i;
    UBYTE *ptr = (UBYTE *)GCOMMAND_PresetWorkEntryTable;

    for (i = 0; i < 4; ++i) {
        PresetWorkEntry *entry = (PresetWorkEntry *)ptr;

        if (entry->mode != 0) {
            entry->mode -= 1;
        } else if (entry->baseValue > 0 && entry->step < entry->currentValue) {
            entry->phase += entry->baseValue;

            while (entry->phase >= 1000) {
                entry->step += 1;
                entry->phase -= 1000;
            }

            if (entry->step > entry->currentValue) {
                entry->baseValue = 0;
                entry->step = entry->currentValue;
            }
        }

        ptr += 24;
    }
}
