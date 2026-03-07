typedef unsigned char UBYTE;
typedef unsigned long ULONG;

enum {
    DISPLIB_INLINE_ALIGN_CENTER = 24,
    DISPLIB_INLINE_ALIGN_RIGHT = 26,
    DISPLIB_INLINE_TARGET_WIDTH_PX = 624,
    MEMF_PUBLIC = 0x1UL
};

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;
extern const char Global_STR_DISPLIB_C_1[];
extern const char Global_STR_DISPLIB_C_2[];
extern const char DISPLIB_STR_InlineAlignPadCharCenter[];
extern const char DISPLIB_STR_InlineAlignPadCharRight[];

extern long _LVOTextLength(void *graphicsBase, void *rastPort, const char *text, long len);
extern long GROUP_AG_JMPTBL_MATH_DivS32(long numer, long denom);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *file, ULONG line, ULONG size, ULONG flags);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, ULONG line, void *ptr, ULONG size);
extern char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);

void DISPLIB_ApplyInlineAlignmentPadding(char *text, UBYTE alignCode)
{
    long textLen = 0;
    long widthRemaining;
    long padCount = 0;
    char *scratch;

    while (text[textLen] != 0) {
        textLen++;
    }

    widthRemaining =
        DISPLIB_INLINE_TARGET_WIDTH_PX -
        _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, text, textLen);
    if (widthRemaining <= 0) {
        return;
    }

    if (alignCode == DISPLIB_INLINE_ALIGN_CENTER) {
        long chWidth = _LVOTextLength(
            Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DISPLIB_STR_InlineAlignPadCharCenter, 1);
        long q = GROUP_AG_JMPTBL_MATH_DivS32(widthRemaining, chWidth);
        if (q < 0) {
            q++;
        }
        padCount = q >> 1;
    } else if (alignCode == DISPLIB_INLINE_ALIGN_RIGHT) {
        long chWidth = _LVOTextLength(
            Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DISPLIB_STR_InlineAlignPadCharRight, 1);
        padCount = GROUP_AG_JMPTBL_MATH_DivS32(widthRemaining, chWidth);
    }

    if (padCount == 0) {
        return;
    }

    scratch = (char *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISPLIB_C_1, 194, (ULONG)(textLen + 1), MEMF_PUBLIC);
    if (scratch == 0) {
        return;
    }

    {
        long i = 0;
        while ((scratch[i] = text[i]) != 0) {
            i++;
        }
        for (i = 0; i < padCount; i++) {
            scratch[textLen + i] = ' ';
        }
        scratch[textLen + padCount] = 0;
    }

    GROUP_AI_JMPTBL_STRING_AppendAtNull(text, scratch);
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_DISPLIB_C_2, 204, scratch, (ULONG)(textLen + 1));
}
