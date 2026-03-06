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

    bound_a = *(long *)((char *)range_ptr + 8);
    bound_b = *(long *)((char *)range_ptr + 12);

    if (bound_a < bound_b) {
        low = bound_a;
        high = bound_b;
    } else if (bound_a > bound_b) {
        flags |= 16;
        low = bound_b;
        high = bound_a;
    } else {
        return 0;
    }

    if (value >= low) {
        if (value >= high) {
            flags |= 2;
        } else {
            flags |= 1;
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
