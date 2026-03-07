extern short WDISP_BannerCharRangeStart;
extern short WDISP_BannerCharRangeEnd;

void ESQ_ClampBannerCharRange(long currentChar, long startBandChar, long endBandChar)
{
    short clampedStart;
    short clampedEnd;
    short startOffset;
    short endOffsetPlusOne;
    short rangeEndChar;
    short wrapMax;

    clampedStart = (short)currentChar;
    startOffset = (short)startBandChar;
    endOffsetPlusOne = (short)endBandChar;

    if (startOffset < 65) {
        startOffset = 65;
    } else {
        if (startOffset >= 67) {
            startOffset = 65;
        }
    }

    if (endOffsetPlusOne < 65) {
        endOffsetPlusOne = 69;
    } else {
        if (endOffsetPlusOne > 73) {
            endOffsetPlusOne = 69;
        }
    }

    startOffset = (short)(startOffset - 65);
    endOffsetPlusOne = (short)(endOffsetPlusOne - 65);
    endOffsetPlusOne = (short)(endOffsetPlusOne + 1);

    wrapMax = 48;
    rangeEndChar = clampedStart;

    if (startOffset != 0) {
        clampedStart = (short)(clampedStart - startOffset);
        if (clampedStart < 1) {
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
