typedef signed long LONG;
typedef unsigned char UBYTE;

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
    UBYTE *result;
    P_TYPE_Entry *srcEntryView;
    LONG i;
    LONG len;

    P_TYPE_FreeEntry(dstEntry);
    result = 0;

    if (srcEntry) {
        srcEntryView = (P_TYPE_Entry *)srcEntry;
        i = 0;
        len = srcEntryView->payloadLength;
        while (i < len) {
            scratch[i] = srcEntryView->payload[i];
            i += 1;
        }
        scratch[i] = 0;
        result = P_TYPE_AllocateEntry(srcEntryView->typeByte, len, scratch);
    }

    return result;
}
