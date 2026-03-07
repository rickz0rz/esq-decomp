enum {
    RANGE_BOUND_A_OFFSET = 8,
    RANGE_BOUND_B_OFFSET = 12,
    RANGE_FLAG_DESCENDING = 16,
    RANGE_FLAG_IN_RANGE = 1,
    RANGE_FLAG_ABOVE_OR_EQUAL_HIGH = 2
};

long DATETIME_ClassifyValueInRange(void *range_ptr, long value)
{
    unsigned char flags;
    long bound_a;
    long bound_b;
    long low;
    long high;

    flags = 0;
    if (range_ptr == 0) {
        return 0;
    }

    bound_a = *(long *)((char *)range_ptr + RANGE_BOUND_A_OFFSET);
    bound_b = *(long *)((char *)range_ptr + RANGE_BOUND_B_OFFSET);

    if (bound_a < bound_b) {
        low = bound_a;
        high = bound_b;
    } else if (bound_a > bound_b) {
        flags |= RANGE_FLAG_DESCENDING;
        low = bound_b;
        high = bound_a;
    } else {
        return 0;
    }

    if (value >= low) {
        if (value >= high) {
            flags |= RANGE_FLAG_ABOVE_OR_EQUAL_HIGH;
        } else {
            flags |= RANGE_FLAG_IN_RANGE;
        }
    }

    switch (flags) {
        case 1:
        case 14:
        case 16:
            return 1;
        default:
            return 0;
    }
}
