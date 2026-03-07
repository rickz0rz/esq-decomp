typedef signed long LONG;
typedef unsigned char UBYTE;

LONG P_TYPE_GetSubtypeIfType20(UBYTE *entry)
{
    LONG subtype;

    subtype = 0;
    if (entry != (UBYTE *)0) {
        if (entry[0] == (UBYTE)20 && entry[1] != (UBYTE)0) {
            subtype = (LONG)entry[1];
        }
    }

    return subtype;
}
