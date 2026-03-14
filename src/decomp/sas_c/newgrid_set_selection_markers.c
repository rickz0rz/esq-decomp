#include <exec/types.h>
void NEWGRID_SetSelectionMarkers(
    LONG primarySel,
    LONG secondarySel,
    char *m3,
    char *m2,
    char *m1,
    char *m0)
{
    if (primarySel == 1) {
        *m3 = (char)(UBYTE)0x80;
        *m2 = (char)(UBYTE)0x81;
    } else if (primarySel == 2) {
        *m3 = (char)(UBYTE)0x82;
        *m2 = (char)(UBYTE)0x83;
    } else {
        *m3 = 0;
        *m2 = 0;
    }

    if (secondarySel == 1) {
        *m1 = (char)(UBYTE)0x88;
        *m0 = (char)(UBYTE)0x89;
    } else if (secondarySel == 2) {
        *m1 = (char)(UBYTE)0x8a;
        *m0 = (char)(UBYTE)0x8b;
    } else {
        *m1 = 0;
        *m0 = 0;
    }
}
