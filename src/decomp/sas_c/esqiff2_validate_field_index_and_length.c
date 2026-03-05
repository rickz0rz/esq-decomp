typedef short WORD;
typedef long LONG;

LONG ESQIFF2_ValidateFieldIndexAndLength(WORD field_index, WORD field_length)
{
    if (field_index > 3) {
        return 0;
    }

    if (field_index == 1) {
        if (field_length > 10) {
            return 0;
        }
    } else {
        if (field_length > 7) {
            return 0;
        }
    }

    return 1;
}
