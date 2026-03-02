#include "esq_types.h"

extern u8 CLOCK_AlignedInsetRenderGateFlag;
extern u8 CLEANUP_AlignedInsetNibblePrimary;
extern u8 CLEANUP_AlignedInsetNibbleSecondary;

char *STR_FindCharPtr(char *text, s32 ch) __attribute__((noinline));
s32 _LVOTextLength(void *rastport, const char *text, s32 len) __attribute__((noinline));
s32 MEM_Move(u8 *src, u8 *dst, s32 length) __attribute__((noinline));
s32 TLIBA1_ParseStyleCodeChar(u8 style_ch) __attribute__((noinline));
void TLIBA1_DrawTextWithInsetSegments(void *rast, s32 x, s32 y, s32 style0, s32 style1, char *text) __attribute__((noinline));
s32 TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(s32 packed) __attribute__((noinline));
s32 TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(s32 packed) __attribute__((noinline));
void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(void *rast, s32 x, s32 y, char *text) __attribute__((noinline));

static s32 local_strlen(const char *s)
{
    s32 n = 0;
    while (s[n] != '\0') {
        ++n;
    }
    return n;
}

void TLIBA1_DrawInlineStyledText(
    void *rast,
    s32 x,
    s32 y,
    char *text) __attribute__((noinline, used));

void TLIBA1_DrawInlineStyledText(
    void *rast,
    s32 x,
    s32 y,
    char *text)
{
    s32 inset_total = 0;
    s32 plain_total = 0;
    s32 style_low = 0;
    s8 style_high = 0;
    char *p;

    if (CLOCK_AlignedInsetRenderGateFlag != 0) {
        if (STR_FindCharPtr(text, 19) != (char *)0 && STR_FindCharPtr(text, 20) != (char *)0) {
            TLIBA1_DrawTextWithInsetSegments(
                rast,
                x,
                y,
                (s32)CLEANUP_AlignedInsetNibbleSecondary,
                (s32)CLEANUP_AlignedInsetNibblePrimary,
                text);
            CLOCK_AlignedInsetRenderGateFlag = 0;
            return;
        }
    }

    p = STR_FindCharPtr(text, 30);
    if (p != (char *)0) {
        while (p != (char *)0) {
            s32 seg_len = 1;
            char *q = p + 1;
            while ((u8)(*q) > 32) {
                ++q;
                ++seg_len;
            }

            plain_total += _LVOTextLength(rast, p, seg_len);

            if (seg_len > 2) {
                style_high = (s8)TLIBA1_ParseStyleCodeChar((u8)p[1]);
                style_low = TLIBA1_ParseStyleCodeChar((u8)p[2]);
            } else {
                style_low = 0;
                style_high = 0;
            }

            if (!((style_high == -1 || ((style_high >= 1) && (style_high <= 7))) &&
                  (style_low == -1 || ((style_low >= 1) && (style_low <= 7))) &&
                  ((u8)p[3] > 32))) {
                s32 n = local_strlen(q) + 1;
                MEM_Move((u8 *)q, (u8 *)p, n);
            } else {
                char *ins_end;
                s32 body_len = seg_len - 3;

                *p = 19;
                MEM_Move((u8 *)(p + 3), (u8 *)(p + 1), body_len);

                ins_end = p + seg_len;
                ins_end[-2] = 20;
                ins_end -= 1;

                {
                    s32 n = local_strlen(q) + 1;
                    MEM_Move((u8 *)q, (u8 *)ins_end, n);
                }

                inset_total += _LVOTextLength(rast, p + 1, body_len);
                if (style_high != -1) {
                    inset_total += 8;
                }
            }

            p = STR_FindCharPtr(text, 30);
        }

        {
            s32 delta = plain_total - inset_total;
            if (delta < 0) {
                delta += 1;
            }
            x += (delta >> 1);
        }

        TLIBA1_DrawTextWithInsetSegments(rast, x, y, style_low, (s32)style_high, text);
        return;
    }

    p = STR_FindCharPtr(text, 23);
    if (p != (char *)0) {
        s8 nib_hi;
        s32 nib_lo;

        *p++ = 19;

        {
            s32 w = _LVOTextLength(rast, p, 1);
            if (w < 0) {
                w += 1;
            }
            x += (w >> 1);
        }

        nib_hi = (s8)TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble((u8)*p);
        if (nib_hi < 1 || nib_hi > 7) {
            nib_hi = -1;
        }

        nib_lo = TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble((u8)*p);
        if (nib_lo < 1 || nib_lo > 7) {
            nib_lo = -1;
        }

        while ((u8)p[1] > 32) {
            *p = p[1];
            ++p;
        }

        *p = 20;

        TLIBA1_DrawTextWithInsetSegments(rast, x, y, nib_lo, (s32)nib_hi, text);
        return;
    }

    UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(rast, x, y, text);
}
