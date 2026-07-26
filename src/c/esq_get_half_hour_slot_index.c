/* RESTORES: ESQ_GetHalfHourSlotIndex
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     206f00042f027000720c302800084a6800126a04d0416006b041660270007218b0416702d0403428000a721eb4416d02524043f90000016410310000241f4e75
 *   got:     48e703042a6f00103e2d0008302d00124a406a060647000c6008700cbe4066027e007018be4067063007d0472e003c2d000a701ebc406d02524741f900000000d0c7700010104cdf20c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char CLOCK_HalfHourSlotLookup[];
struct ClockSlotRec { char pad[8]; short hour; short minute; char pad2[6]; short pmFlag; };

long ESQ_GetHalfHourSlotIndex(struct ClockSlotRec *c)
{
    short slot = c->hour;
    short minute;

    if (c->pmFlag < 0)
        slot += 12;
    else if (slot == 12)
        slot = 0;
    if (slot != 24)
        slot += slot;
    minute = c->minute;
    if (minute >= 30)
        slot++;
    return CLOCK_HalfHourSlotLookup[slot];
}
