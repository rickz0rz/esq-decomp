typedef struct ClockSlotTime {
    short unknown0;
    short unknown2;
    short unknown4;
    short unknown6;
    short hour;
    short minute;
    short unknown12;
    short unknown14;
    short unknown16;
    short ampmFlag;
} ClockSlotTime;

extern unsigned char CLOCK_HalfHourSlotLookup[];

unsigned long ESQ_GetHalfHourSlotIndex(ClockSlotTime *timePtr)
{
    unsigned short slot;

    slot = (unsigned short)timePtr->hour;
    if (timePtr->ampmFlag < 0) {
        slot = (unsigned short)(slot + 12);
    } else if (slot == 12) {
        slot = 0;
    }

    if (slot != 24) {
        slot = (unsigned short)(slot + slot);
    }

    if (timePtr->minute >= 30) {
        slot = (unsigned short)(slot + 1);
    }

    return (unsigned long)CLOCK_HalfHourSlotLookup[slot];
}
