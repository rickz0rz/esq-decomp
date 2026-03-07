extern short WDISP_BannerCharRangeStart;
extern short WDISP_BannerCharRangeEnd;

void ESQ_ClampBannerCharRange(long currentChar, long startBandChar, long endBandChar)
{
    const short kBandCharA = 65;
    const short kBandCharC = 67;
    const short kBandCharE = 69;
    const short kBandCharI = 73;
    const short kWrapMax = 48;
    const short kMinRangeStart = 1;
    const short kZero = 0;
    short clampedStart;
    short clampedEnd;
    short startOffset;
    short endOffsetPlusOne;
    short rangeEndChar;
    short wrapMax;

    clampedStart = (short)currentChar;
    startOffset = (short)startBandChar;
    endOffsetPlusOne = (short)endBandChar;

    if (startOffset < kBandCharA) {
        startOffset = kBandCharA;
    } else {
        if (startOffset >= kBandCharC) {
            startOffset = kBandCharA;
        }
    }

    if (endOffsetPlusOne < kBandCharA) {
        endOffsetPlusOne = kBandCharE;
    } else {
        if (endOffsetPlusOne > kBandCharI) {
            endOffsetPlusOne = kBandCharE;
        }
    }

    startOffset = (short)(startOffset - kBandCharA);
    endOffsetPlusOne = (short)(endOffsetPlusOne - kBandCharA);
    endOffsetPlusOne = (short)(endOffsetPlusOne + 1);

    wrapMax = kWrapMax;
    rangeEndChar = clampedStart;

    if (startOffset != kZero) {
        clampedStart = (short)(clampedStart - startOffset);
        if (clampedStart < kMinRangeStart) {
            clampedStart = (short)(clampedStart + wrapMax);
        }
    }

    rangeEndChar = (short)(rangeEndChar + endOffsetPlusOne);
    if (rangeEndChar > wrapMax) {
        rangeEndChar = (short)(rangeEndChar - wrapMax);
    }

    WDISP_BannerCharRangeStart = clampedStart;
    WDISP_BannerCharRangeEnd = rangeEndChar;
}
