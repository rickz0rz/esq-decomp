typedef short WORD;
typedef signed long LONG;

LONG ESQDISP_TestWordIsZeroBooleanize(WORD value)
{
    if (value == 0) {
        return -1;
    }
    return 0;
}
