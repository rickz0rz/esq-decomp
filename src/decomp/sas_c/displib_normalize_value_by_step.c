long DISPLIB_NormalizeValueByStep(short value, short lowerBound, short step)
{
    while (value < lowerBound) {
        value = (short)(value + step);
    }

    while (value > step) {
        value = (short)(value - step);
    }

    return (long)value;
}
