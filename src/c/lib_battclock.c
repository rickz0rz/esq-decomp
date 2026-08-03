/* RESTORES: BATTCLOCK_GetSecondsFromBatteryBackedClock
 * MODULE:   modules/submodules/unknown40_battclock_getsecondsfrombatterybackedclock.s
 * STATUS:   exact
 *
 * BYTE-IDENTICAL at 16 bytes, with the one relocated field compared
 * positionally. 16 is a multiple of 4, so the object needs no padding and this
 * restoration costs the linked image nothing. It is in src/c/replacements.txt.
 *
 * Its sibling `lib_battclock_write.c` does NOT match -- 28 bytes against 20 --
 * because the original saves and restores A6 by hand around the call. Leave it
 * behavioural.
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
