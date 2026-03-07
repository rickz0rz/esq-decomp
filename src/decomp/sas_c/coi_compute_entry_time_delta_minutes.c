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
    const LONG SLOT_INVALID = 49;
    const LONG SLOT_FIRST = 1;
    const LONG SLOT_LAST = 48;
    const LONG AUX_TITLE_TABLE_OFFSET = 56;
    const LONG AUX_GROUPCODE_OFFSET = 498;
    const LONG AUX_POINTER_MODE_SECONDARY = 2;
    const LONG SLOT_PTR_SHIFT = 2;
    const LONG DELTA_DAY_MINUTES = 2880;
    const LONG SLOT_MINUTES = 30;
    const LONG DELTA_INVALID = -1;
    UBYTE *e;
    LONG out;
    LONG s;

    e = (UBYTE *)entry;
    s = SLOT_INVALID;
    out = DELTA_INVALID;

    if (slot <= 0 || slot >= SLOT_INVALID) {
        return out;
    }

    s = (LONG)slot + 1;
    while (s < SLOT_INVALID && *(LONG *)(e + AUX_TITLE_TABLE_OFFSET + (s << SLOT_PTR_SHIFT)) == 0) {
        s += 1;
    }

    if (s > SLOT_LAST && TEXTDISP_PrimaryGroupCode == e[AUX_GROUPCODE_OFFSET]) {
        s = GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(e);
        e = (UBYTE *)GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(s, AUX_POINTER_MODE_SECONDARY);
        if (e != (UBYTE *)0) {
            s = SLOT_FIRST;
            while (s < SLOT_INVALID && *(LONG *)(e + AUX_TITLE_TABLE_OFFSET + (s << SLOT_PTR_SHIFT)) == 0) {
                s += 1;
            }
        } else {
            s = SLOT_INVALID;
        }
    }

    if (s > SLOT_LAST) {
        out = DELTA_DAY_MINUTES - ((LONG)CLOCK_HalfHourSlotIndex * SLOT_MINUTES);
        return out;
    }

    out = GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset((LONG)e[AUX_GROUPCODE_OFFSET], e, s);
    return out;
}
