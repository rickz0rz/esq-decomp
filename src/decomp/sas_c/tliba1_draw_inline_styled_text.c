typedef signed long LONG;
typedef signed char BYTE;
typedef unsigned char UBYTE;

extern UBYTE CLOCK_AlignedInsetRenderGateFlag;
extern UBYTE CLEANUP_AlignedInsetNibbleSecondary;
extern UBYTE CLEANUP_AlignedInsetNibblePrimary;

extern char *STR_FindCharPtr(const char *s, LONG ch);
extern LONG _LVOTextLength(char *rastPort, const char *text, LONG len);
extern LONG MEM_Move(UBYTE *src, UBYTE *dst, LONG len);
extern LONG TLIBA1_ParseStyleCodeChar(UBYTE c);
extern LONG TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(LONG v);
extern LONG TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(LONG v);
extern void TLIBA1_DrawTextWithInsetSegments(char *rastPort, LONG x, LONG y, LONG styleA, LONG styleB, const char *text);
extern void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text);

static LONG TLIBA1_StrLen(const char *s)
{
    LONG n;
    n = 0;
    while (s[n] != 0) {
        ++n;
    }
    return n;
}

void TLIBA1_DrawInlineStyledText(char *rastPort, LONG x, LONG y, char *text)
{
    LONG insetTotal;
    LONG plainTotal;
    LONG styleLow;
    BYTE styleHigh;
    char *p;

    insetTotal = 0;
    plainTotal = 0;
    styleLow = 0;
    styleHigh = 0;

    if (CLOCK_AlignedInsetRenderGateFlag != 0) {
        if (STR_FindCharPtr(text, 19) != (char *)0 && STR_FindCharPtr(text, 20) != (char *)0) {
            TLIBA1_DrawTextWithInsetSegments(rastPort, x, y, (LONG)CLEANUP_AlignedInsetNibblePrimary, (LONG)CLEANUP_AlignedInsetNibbleSecondary, text);
            CLOCK_AlignedInsetRenderGateFlag = 0;
            return;
        }
    }

    p = STR_FindCharPtr(text, 30);
    if (p != (char *)0) {
        while (p != (char *)0) {
            LONG segLen;
            char *q;

            segLen = 1;
            q = p + 1;
            while ((UBYTE)(*q) > 32) {
                ++q;
                ++segLen;
            }

            plainTotal += _LVOTextLength(rastPort, p, segLen);

            if (segLen > 2) {
                styleHigh = (BYTE)TLIBA1_ParseStyleCodeChar((UBYTE)p[1]);
                styleLow = TLIBA1_ParseStyleCodeChar((UBYTE)p[2]);
            } else {
                styleLow = 0;
                styleHigh = 0;
            }

            if (!((styleHigh == -1 || ((styleHigh >= 1) && (styleHigh <= 7))) && (styleLow == -1 || ((styleLow >= 1) && (styleLow <= 7))) && ((UBYTE)p[3] > 32))) {
                LONG n;

                n = TLIBA1_StrLen(q) + 1;
                MEM_Move((UBYTE *)q, (UBYTE *)p, n);
            } else {
                char *insEnd;
                LONG bodyLen;

                bodyLen = segLen - 3;
                *p = 19;
                MEM_Move((UBYTE *)(p + 3), (UBYTE *)(p + 1), bodyLen);

                insEnd = p + segLen;
                insEnd[-2] = 20;
                insEnd -= 1;

                {
                    LONG n;
                    n = TLIBA1_StrLen(q) + 1;
                    MEM_Move((UBYTE *)q, (UBYTE *)insEnd, n);
                }

                insetTotal += _LVOTextLength(rastPort, p + 1, bodyLen);
                if (styleHigh != -1) {
                    insetTotal += 8;
                }
            }

            p = STR_FindCharPtr(text, 30);
        }

        {
            LONG delta;
            delta = plainTotal - insetTotal;
            if (delta < 0) {
                delta += 1;
            }
            x += (delta >> 1);
        }

        TLIBA1_DrawTextWithInsetSegments(rastPort, x, y, styleLow, (LONG)styleHigh, text);
        return;
    }

    p = STR_FindCharPtr(text, 23);
    if (p != (char *)0) {
        BYTE nibHi;
        LONG nibLo;

        *p++ = 19;

        {
            LONG w;
            w = _LVOTextLength(rastPort, p, 1);
            if (w < 0) {
                w += 1;
            }
            x += (w >> 1);
        }

        nibHi = (BYTE)TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble((LONG)(UBYTE)*p);
        if (nibHi < 1 || nibHi > 7) {
            nibHi = -1;
        }

        nibLo = TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble((LONG)(UBYTE)*p);
        if (nibLo < 1 || nibLo > 7) {
            nibLo = -1;
        }

        while (p[1] > 32) {
            *p = p[1];
            ++p;
        }

        *p = 20;

        TLIBA1_DrawTextWithInsetSegments(rastPort, x, y, nibLo, (LONG)nibHi, text);
        return;
    }

    UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(rastPort, x, y, text);
}
