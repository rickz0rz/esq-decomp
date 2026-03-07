typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE *P_TYPE_PrimaryGroupListPtr;

LONG P_TYPE_ConsumePrimaryTypeIfPresent(UBYTE *inOutBytePtr)
{
    LONG found;
    LONG i;
    UBYTE *entry;
    UBYTE *payload;

    found = 0;

    if (P_TYPE_PrimaryGroupListPtr != (UBYTE *)0) {
        entry = P_TYPE_PrimaryGroupListPtr;
        if (*(LONG *)(entry + 2) > 0) {
            i = 0;
            while (found == 0) {
                entry = P_TYPE_PrimaryGroupListPtr;
                if (i >= *(LONG *)(entry + 2)) {
                    break;
                }

                payload = *(UBYTE **)(entry + 6);
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
