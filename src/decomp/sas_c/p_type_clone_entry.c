#include <exec/types.h>
typedef struct P_TYPE_Entry {
    UBYTE typeByte;
    UBYTE subtypeByte;
    LONG payloadLength;
    UBYTE *payload;
} P_TYPE_Entry;

extern void P_TYPE_FreeEntry(UBYTE *entry);
extern UBYTE *P_TYPE_AllocateEntry(UBYTE typeByte, LONG length, UBYTE *dataPtr);

UBYTE *P_TYPE_CloneEntry(UBYTE *dstEntry, UBYTE *srcEntry)
{
    UBYTE scratch[104];
    P_TYPE_Entry *srcEntryView;
    LONG i;

    P_TYPE_FreeEntry(dstEntry);
    dstEntry = 0;

    if (srcEntry) {
        srcEntryView = (P_TYPE_Entry *)srcEntry;
        i = 0;
        while (i < srcEntryView->payloadLength) {
            scratch[i] = srcEntryView->payload[i];
            i += 1;
        }
        scratch[i] = 0;
        dstEntry = P_TYPE_AllocateEntry(srcEntryView->typeByte, srcEntryView->payloadLength, scratch);
    }

    return dstEntry;
}
