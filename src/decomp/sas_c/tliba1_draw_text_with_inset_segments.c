#include <exec/types.h>
#include <exec/memory.h>

extern void *Global_REF_GRAPHICS_LIBRARY;

extern void *MEMORY_AllocateMemory(ULONG byteSize, ULONG attributes);
extern void MEMORY_DeallocateMemory(void *ptr, ULONG byteSize);
extern char *STR_FindCharPtr(const char *s, LONG ch);
extern void _LVOMove(void *graphicsBase, char *rastPort, LONG x, LONG y);
extern void _LVOText(void *graphicsBase, char *rastPort, const char *text, LONG len);
extern void SCRIPT_DrawInsetTextWithFrame(char *rastPort, BYTE textPenOverride, BYTE framePen, const char *text);

static LONG TLIBA1_StrLen(const char *s)
{
    LONG len;

    len = 0;
    while (*s++ != '\0') {
        ++len;
    }

    return len;
}

static void TLIBA1_CopyCString(char *dst, const char *src)
{
    do {
        *dst++ = *src;
    } while (*src++ != '\0');
}

void TLIBA1_DrawTextWithInsetSegments(char *rastPort, LONG x, LONG y, LONG textPenOverride, LONG framePen, const char *text)
{
    char *scratchText;
    char *plainStart;
    char *insetStart;
    char *nextSegment;
    LONG scratchSize;

    scratchText = (char *)0;
    plainStart = (char *)0;
    insetStart = (char *)0;
    nextSegment = (char *)0;

    if (text != (const char *)0 && *text != '\0') {
        scratchSize = TLIBA1_StrLen(text) + 1;
        scratchText = (char *)MEMORY_AllocateMemory((ULONG)scratchSize, (MEMF_PUBLIC | MEMF_CLEAR));
        if (scratchText != (char *)0) {
            TLIBA1_CopyCString(scratchText, text);
            plainStart = scratchText;
        }
    }

    if (scratchText == (char *)0) {
        return;
    }

    insetStart = STR_FindCharPtr(plainStart, 19);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, x, y);

    while (insetStart != (char *)0) {
        nextSegment = STR_FindCharPtr(plainStart, 20);

        *insetStart++ = '\0';
        if (nextSegment != (char *)0) {
            *nextSegment++ = '\0';
        }

        if (*plainStart != '\0') {
            _LVOText(
                Global_REF_GRAPHICS_LIBRARY,
                rastPort,
                plainStart,
                TLIBA1_StrLen(plainStart));
        }

        SCRIPT_DrawInsetTextWithFrame(
            rastPort,
            (BYTE)textPenOverride,
            (BYTE)framePen,
            insetStart);

        plainStart = nextSegment;
        if (plainStart == (char *)0) {
            break;
        }

        insetStart = STR_FindCharPtr(plainStart, 19);
    }

    if (plainStart != (char *)0 && *plainStart != '\0') {
        _LVOText(
            Global_REF_GRAPHICS_LIBRARY,
            rastPort,
            plainStart,
            TLIBA1_StrLen(plainStart));
    }

    MEMORY_DeallocateMemory(scratchText, (ULONG)scratchSize);
}
