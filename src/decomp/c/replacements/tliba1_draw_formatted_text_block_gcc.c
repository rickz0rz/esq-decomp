#include "esq_types.h"

extern s16 TEXTDISP_LinePenOverrideEnabledFlag;
extern u8 CLOCK_AlignedInsetRenderGateFlag;
extern u8 CLEANUP_AlignedInsetNibblePrimary;
extern void *Global_HANDLE_PREVUE_FONT;
extern const char Global_STR_TLIBA1_C_3[];
extern const char TLIBA1_STR_TLIBA1_DOT_C[];

u32 MATH_Mulu32(u32 a, u32 b) __attribute__((noinline));
s32 MATH_DivS32(s32 dividend, s32 divisor) __attribute__((noinline));
void *MEMORY_AllocateMemory(const void *owner, s32 line, s32 bytes, u32 flags) __attribute__((noinline));
void MEMORY_DeallocateMemory(const void *owner, s32 line, void *ptr, u32 bytes) __attribute__((noinline));
s32 _LVOTextLength(void *rastport, const char *text, s32 len) __attribute__((noinline));
void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void _LVOSetFont(void *rastport, void *font) __attribute__((noinline));
void TLIBA1_DrawInlineStyledText(void *rast, s32 x, s32 y, char *text) __attribute__((noinline));

static s32 local_strlen(const char *s)
{
    s32 n = 0;
    while (s[n] != '\0') {
        ++n;
    }
    return n;
}

void TLIBA1_DrawFormattedTextBlock(
    void *rast,
    char *text,
    s16 left,
    s16 top,
    s16 right,
    s16 bottom,
    s16 arg7,
    u8 arg8,
    s16 arg9,
    void *arg10,
    void *arg11,
    void *arg12,
    void *arg13,
    s16 arg14,
    s16 arg15,
    s16 arg16,
    s16 arg17) __attribute__((noinline, used));

void TLIBA1_DrawFormattedTextBlock(
    void *rast,
    char *text,
    s16 left,
    s16 top,
    s16 right,
    s16 bottom,
    s16 arg7,
    u8 arg8,
    s16 arg9,
    void *arg10,
    void *arg11,
    void *arg12,
    void *arg13,
    s16 arg14,
    s16 arg15,
    s16 arg16,
    s16 arg17)
{
    s32 box_w = (s32)right - (s32)left + 1;
    s32 box_h = (s32)bottom - (s32)top + 1;
    s32 run_count = 0;
    s32 run_gate = 0;
    char *p = text;
    u8 saved_pen = *((u8 *)rast + 25);
    void *saved_font = *(void **)((u8 *)rast + 52);
    u8 *records;
    u32 alloc_size;
    s32 line_width;
    s32 x;
    s32 y;

    (void)arg7;
    (void)arg8;
    (void)arg9;
    (void)arg10;
    (void)arg11;
    (void)arg12;
    (void)arg13;
    (void)arg14;
    (void)arg15;
    (void)arg16;
    (void)arg17;
    (void)MATH_DivS32(box_h, 1);

    while (*p != '\0') {
        u8 c = (u8)*p;
        if (c == 24 || c == 25 || c == 6) {
            if (run_gate == 0) {
                run_count += 1;
                run_gate = 1;
            }
        } else {
            run_gate = 0;
        }
        ++p;
    }

    if (run_count == 0) {
        return;
    }

    alloc_size = MATH_Mulu32((u32)run_count, 10u);
    records = (u8 *)MEMORY_AllocateMemory(Global_STR_TLIBA1_C_3, 2115, (s32)alloc_size, 0x10001u);
    if (records == (u8 *)0) {
        return;
    }

    if (TEXTDISP_LinePenOverrideEnabledFlag != 0) {
        _LVOSetAPen(rast, 0);
    }

    _LVOSetFont(rast, Global_HANDLE_PREVUE_FONT);

    line_width = _LVOTextLength(rast, text, local_strlen(text));
    if (CLOCK_AlignedInsetRenderGateFlag != 0 && CLEANUP_AlignedInsetNibblePrimary != 0xFFu) {
        line_width += 8;
    }
    if (line_width > box_w) {
        line_width = box_w;
    }

    {
        s32 dx = box_w - line_width;
        if (dx < 0) {
            dx += 1;
        }
        x = (s32)left + (dx >> 1);
    }

    {
        s32 dy = box_h - 1;
        if (dy < 0) {
            dy += 1;
        }
        y = (s32)top + (dy >> 1);
    }

    TLIBA1_DrawInlineStyledText(rast, x, y, text);

    _LVOSetAPen(rast, (s32)saved_pen);
    _LVOSetFont(rast, saved_font);

    MEMORY_DeallocateMemory(TLIBA1_STR_TLIBA1_DOT_C, 2385, records, alloc_size);
}
