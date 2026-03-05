extern short WDISP_BannerCharRangeStart;
extern short WDISP_BannerCharRangeEnd;

void ESQ_ClampBannerCharRange(long value0, long value1, long value2)
{
    short d0;
    short d1;
    short d2;
    short d3;
    short d4;

    d0 = (short)value0;
    d1 = (short)value1;
    d2 = (short)value2;

    if (d1 < 65) {
        d1 = 65;
    } else {
        if (d1 >= 67) {
            d1 = 65;
        }
    }

    if (d2 < 65) {
        d2 = 69;
    } else {
        if (d2 > 73) {
            d2 = 69;
        }
    }

    d1 = (short)(d1 - 65);
    d2 = (short)(d2 - 65);
    d2 = (short)(d2 + 1);

    d4 = 48;
    d3 = d0;

    if (d1 != 0) {
        d0 = (short)(d0 - d1);
        if (d0 < 1) {
            d0 = (short)(d0 + d4);
        }
    }

    d3 = (short)(d3 + d2);
    if (d3 > d4) {
        d3 = (short)(d3 - d4);
    }

    WDISP_BannerCharRangeStart = d0;
    WDISP_BannerCharRangeEnd = d3;
}
