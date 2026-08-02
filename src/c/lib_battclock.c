/* RESTORES: BATTCLOCK_GetSecondsFromBatteryBackedClock
 * MODULE:   modules/submodules/unknown40_battclock_getsecondsfrombatterybackedclock.s
 * STATUS:   behavioural
 *
 * SAS/C library code: a thin wrapper on battclock.resource's ReadBattClock.
 *
 * battclock IS A RESOURCE, NOT A LIBRARY, and it is opened with OpenResource
 * rather than OpenLibrary -- but the call convention is identical, base in A6 and
 * a negative LVO offset, so the SAS/C pragmas work unchanged.
 *
 * THE BASE IS _BattClockBase, labelled beside _Global_REF_BATTCLOCK_RESOURCE in
 * src/data/esq.s. Adding the label is byte-neutral and it is what gives the
 * pragma a symbol to load.
 *
 * NO NULL CHECK. If the resource failed to open the base is zero and the call
 * dereferences it. The original has no guard and none is added -- every caller
 * reaches this only after startup has opened the resource.
 */
#include "esq-battclock.h"

unsigned long BATTCLOCK_GetSecondsFromBatteryBackedClock(void)
{
    return ReadBattClock();
}
