typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct P_TYPE_Entry {
    UBYTE pad0[2];
    LONG payloadLength;
    UBYTE *payload;
} P_TYPE_Entry;

extern UBYTE *P_TYPE_PrimaryGroupListPtr;

LONG P_TYPE_ConsumePrimaryTypeIfPresent(UBYTE *inOutBytePtr)
{
    LONG found;
    LONG i;
    P_TYPE_Entry *entry;
    UBYTE *payload;

    found = 0;

    if (P_TYPE_PrimaryGroupListPtr) {
        entry = (P_TYPE_Entry *)P_TYPE_PrimaryGroupListPtr;
        if (entry->payloadLength > 0) {
            i = 0;
            while (found == 0) {
                entry = (P_TYPE_Entry *)P_TYPE_PrimaryGroupListPtr;
                if (i >= entry->payloadLength) {
                    break;
                }

                payload = entry->payload;
                if (*inOutBytePtr == payload[i]) {
                    found = 1;
                }
                i += 1;
            }
        }
    }

    *inOutBytePtr = 0;
    return found;
}
