typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern void ESQSHARED_UpdateMatchingEntriesByTitle(
    char *title_key,
    ULONG arg2,
    ULONG arg3,
    ULONG arg4,
    UBYTE *payload_ptr
);

void ESQSHARED_ParseCompactEntryRecord(UBYTE *record)
{
    UBYTE group_code;
    UBYTE slot_index;
    UBYTE mode_byte;
    UBYTE i;
    char title_key[9];

    group_code = *record++;
    slot_index = *record++;

    i = 0;
    do {
        UBYTE c = *record++;
        title_key[i] = (char)c;
        if (c == 0x12) {
            break;
        }
        if (i >= 8) {
            break;
        }
        ++i;
    } while (1);

    title_key[i] = '\0';
    mode_byte = *record++;

    ESQSHARED_UpdateMatchingEntriesByTitle(
        title_key,
        (ULONG)slot_index,
        (ULONG)group_code,
        (ULONG)mode_byte,
        record
    );
}
