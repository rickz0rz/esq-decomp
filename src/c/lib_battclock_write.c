/* RESTORES: BATTCLOCK_WriteSecondsToBatteryBackedClock
 * MODULE:   modules/submodules/unknown40_battclock_writesecondstobatterybackedclock.s
 * STATUS:   behavioural
 *
 * SAS/C library code: the write half of the battery-clock pair. See
 * lib_battclock.c for why the resource's base needed a label adding.
 *
 * IT RETURNS NOTHING. The original falls straight into the epilogue after the
 * call, so whatever WriteBattClock left in D0 is what the caller sees -- and no
 * caller reads it.
 */
#include "esq-battclock.h"

void BATTCLOCK_WriteSecondsToBatteryBackedClock(unsigned long seconds)
{
    WriteBattClock(seconds);
}
