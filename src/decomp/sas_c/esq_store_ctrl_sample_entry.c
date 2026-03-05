extern unsigned char ED_StateRingTable[];
extern unsigned long ED_StateRingWriteIndex;
extern unsigned char CTRL_SampleEntryScratch[];

void ESQ_StoreCtrlSampleEntry(void)
{
    unsigned char *dst;
    unsigned char *src;
    unsigned long idx;

    idx = ED_StateRingWriteIndex;
    dst = ED_StateRingTable + (unsigned short)(idx * 5UL);
    src = CTRL_SampleEntryScratch;

    do {
        *dst++ = *src;
    } while (*src++ != 0);

    idx++;
    if (idx >= 20UL) {
        idx = 0;
    }

    ED_StateRingWriteIndex = idx;
}
