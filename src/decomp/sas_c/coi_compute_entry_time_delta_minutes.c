typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

extern UWORD CLOCK_HalfHourSlotIndex;
extern UBYTE TEXTDISP_PrimaryGroupCode;

LONG GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(const void *entry);
const char *GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG mode, LONG idx);
LONG TEXTDISP_ComputeTimeOffset(LONG groupCode, const char *title, LONG slot);

typedef struct COI_AuxEntry {
    UBYTE pad0[56];
    const char *titleTable[49];
    UBYTE pad252[246];
    UBYTE groupCode498;
} COI_AuxEntry;

LONG COI_ComputeEntryTimeDeltaMinutes(const void *entry, WORD slot)
{
    const LONG SLOT_INVALID = 49;
    const LONG SLOT_FIRST = 1;
    const LONG SLOT_LAST = 48;
    const LONG AUX_POINTER_MODE_SECONDARY = 2;
    const LONG DELTA_DAY_MINUTES = 2880;
    const LONG SLOT_MINUTES = 30;
    const LONG DELTA_INVALID = -1;
    const COI_AuxEntry *e;
    LONG out;
    LONG s;

    e = (const COI_AuxEntry *)entry;
    s = SLOT_INVALID;
    out = DELTA_INVALID;

    if (slot <= 0 || slot >= SLOT_INVALID) {
        return out;
    }

    s = (LONG)slot + 1;
    while (s < SLOT_INVALID && e->titleTable[s] == 0) {
        s += 1;
    }

    if (s > SLOT_LAST && TEXTDISP_PrimaryGroupCode == e->groupCode498) {
        s = GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(e);
        e = (const COI_AuxEntry *)GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(s, AUX_POINTER_MODE_SECONDARY);
        if (e != (const COI_AuxEntry *)0) {
            s = SLOT_FIRST;
            while (s < SLOT_INVALID && e->titleTable[s] == 0) {
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

    out = TEXTDISP_ComputeTimeOffset((LONG)e->groupCode498, (const char *)e, s);
    return out;
}
