typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

extern UWORD CLOCK_HalfHourSlotIndex;
extern UBYTE TEXTDISP_PrimaryGroupCode;

LONG GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(void *entry);
void *GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG mode, LONG idx);
LONG GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(LONG lead, void *entry, LONG slot);

LONG COI_ComputeEntryTimeDeltaMinutes(void *entry, WORD slot)
{
    UBYTE *e;
    LONG out;
    LONG s;

    e = (UBYTE *)entry;
    s = 49;
    out = -1;

    if (slot <= 0 || slot >= 49) {
        return out;
    }

    s = (LONG)slot + 1;
    while (s < 49 && *(LONG *)(e + 56 + (s << 2)) == 0) {
        s += 1;
    }

    if (s > 48 && TEXTDISP_PrimaryGroupCode == e[498]) {
        s = GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(e);
        e = (UBYTE *)GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(s, 2);
        if (e != (UBYTE *)0) {
            s = 1;
            while (s < 49 && *(LONG *)(e + 56 + (s << 2)) == 0) {
                s += 1;
            }
        } else {
            s = 49;
        }
    }

    if (s > 48) {
        out = 2880 - ((LONG)CLOCK_HalfHourSlotIndex * 30);
        return out;
    }

    out = GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset((LONG)e[498], e, s);
    return out;
}
