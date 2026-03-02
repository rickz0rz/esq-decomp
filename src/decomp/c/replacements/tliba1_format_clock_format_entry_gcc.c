#include "esq_types.h"

extern u8 TLIBA1_FormatFallbackBuffer[];
extern u8 WDISP_CharClassTable[];
extern const u8 *TEXTDISP_FormatEntryFallbackTable[];
extern u8 TLIBA1_FormatFallbackFieldPtr0[];
extern u8 TLIBA1_FormatFallbackFieldPtr1[];
extern u8 TLIBA1_FormatFallbackFieldPtr2[];
extern u8 TLIBA1_FormatFallbackFieldPtr3[];
extern const char TLIBA1_FMT_PCT_C_PCT_S[];

s32 WDISP_SPrintf(char *dst, const char *fmt, ...) __attribute__((noinline));
char *STRING_AppendAtNull(char *dst, const char *src) __attribute__((noinline));

void TLIBA1_FormatClockFormatEntry(
    char *dst,
    const u8 *format_state,
    const char *field1,
    const char *field2,
    const char *field3,
    const char *field0,
    s32 mode_word_carrier) __attribute__((noinline, used));

void TLIBA1_FormatClockFormatEntry(
    char *dst,
    const u8 *format_state,
    const char *field1,
    const char *field2,
    const char *field3,
    const char *field0,
    s32 mode_word_carrier)
{
    char local_fmt[0x200];
    const u8 *fallback_chars;
    const char *fields[4];
    s32 i;
    s32 code;
    u8 d5;
    s16 mode_word = (s16)mode_word_carrier;

    for (i = 0; i < 0x200; ++i) {
        local_fmt[i] = (char)TLIBA1_FormatFallbackBuffer[i];
    }

    code = (format_state != (const u8 *)0) ? (s32)format_state[2] : 65;
    if ((WDISP_CharClassTable[code] & (1u << 1)) != 0) {
        code -= 32;
    }

    d5 = (u8)((code - 65) + 1);
    if (mode_word == 0 && d5 < 2) {
        fallback_chars = TEXTDISP_FormatEntryFallbackTable[d5];
    } else {
        fallback_chars = TEXTDISP_FormatEntryFallbackTable[0];
    }

    fields[0] = (field0 != (const char *)0) ? field0 : (const char *)TLIBA1_FormatFallbackFieldPtr0;
    fields[1] = (field1 != (const char *)0) ? field1 : (const char *)TLIBA1_FormatFallbackFieldPtr1;
    fields[2] = (field3 != (const char *)0) ? field3 : (const char *)TLIBA1_FormatFallbackFieldPtr2;
    fields[3] = (field2 != (const char *)0) ? field2 : (const char *)TLIBA1_FormatFallbackFieldPtr3;

    dst[0] = '\0';
    for (i = 0; i < 4; ++i) {
        s32 len_field = 0;
        s32 len_dst = 0;
        const char *p;

        p = fields[i];
        while (*p != '\0') {
            ++len_field;
            ++p;
        }

        if (len_field <= 0 || len_field >= 0x200) {
            continue;
        }

        p = dst;
        while (*p != '\0') {
            ++len_dst;
            ++p;
        }

        if ((len_field + len_dst) >= 0x200) {
            continue;
        }

        local_fmt[0] = '\0';
        WDISP_SPrintf(local_fmt, TLIBA1_FMT_PCT_C_PCT_S, (s32)fallback_chars[i], fields[i]);
        STRING_AppendAtNull(dst, local_fmt);
    }
}
