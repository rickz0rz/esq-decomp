enum {
    RANGE_BOUND_A_OFFSET = 8,
    RANGE_BOUND_B_OFFSET = 12,
    RANGE_FLAG_DESCENDING = 16,
    RANGE_FLAG_IN_RANGE = 1,
    RANGE_FLAG_ABOVE_OR_EQUAL_HIGH = 2,
    RANGE_CASE_IN_RANGE = 1,
    RANGE_CASE_DESCENDING_IN_RANGE = 14,
    RANGE_CASE_DESCENDING_ONLY = 16,
    RANGE_RESULT_FALSE = 0,
    RANGE_RESULT_TRUE = 1
};

long DATETIME_ClassifyValueInRange(void *rangePtr, long value)
{
    unsigned char flags;
    long boundA;
    long boundB;
    long low;
    long high;

    flags = 0;
    if (rangePtr == 0) {
        return RANGE_RESULT_FALSE;
    }

    boundA = *(long *)((char *)rangePtr + RANGE_BOUND_A_OFFSET);
    boundB = *(long *)((char *)rangePtr + RANGE_BOUND_B_OFFSET);

    if (boundA < boundB) {
        low = boundA;
        high = boundB;
    } else if (boundA > boundB) {
        flags |= RANGE_FLAG_DESCENDING;
        low = boundB;
        high = boundA;
    } else {
        return RANGE_RESULT_FALSE;
    }

    if (value >= low) {
        if (value >= high) {
            flags |= RANGE_FLAG_ABOVE_OR_EQUAL_HIGH;
        } else {
            flags |= RANGE_FLAG_IN_RANGE;
        }
    }

    switch (flags) {
        case RANGE_CASE_IN_RANGE:
        case RANGE_CASE_DESCENDING_IN_RANGE:
        case RANGE_CASE_DESCENDING_ONLY:
            return RANGE_RESULT_TRUE;
        default:
            return RANGE_RESULT_FALSE;
    }
}
