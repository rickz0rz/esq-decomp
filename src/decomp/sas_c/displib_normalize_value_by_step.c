long DISPLIB_NormalizeValueByStep(short value, short lowerBound, short step)
{
    const short upperWrapBound = step;

    while (value < lowerBound) {
        value = (short)(value + step);
    }

    while (value > upperWrapBound) {
        value = (short)(value - step);
    }

    return (long)value;
}
