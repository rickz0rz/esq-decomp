extern unsigned char CLOCK_HalfHourSlotLookup[];

unsigned long ESQ_GetHalfHourSlotIndex(void *timePtr)
{
    short hour;
    short minute;
    short ampmFlag;
    short slot;
    unsigned char *base;

    base = (unsigned char *)timePtr;
    hour = *(short *)(base + 8);
    ampmFlag = *(short *)(base + 18);

    if (ampmFlag < 0) {
        hour = (short)(hour + 12);
    } else {
        if (hour == 12) {
            hour = 0;
        }
    }

    if (hour != 24) {
        hour = (short)(hour + hour);
    }

    slot = hour;
    minute = *(short *)(base + 10);
    if (minute >= 30) {
        slot = (short)(slot + 1);
    }

    return (unsigned long)CLOCK_HalfHourSlotLookup[(unsigned short)slot];
}
