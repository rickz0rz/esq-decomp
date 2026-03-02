#include "esq_types.h"

extern void *PARSEINI_ParsedDescriptorListHead;
extern void *PARSEINI_CurrentWeatherBlockTempPtr;
extern void *PARSEINI_CurrentWeatherBlockPtr;
extern const char Global_STR_PARSEINI_C_3[];
extern const char PARSEINI_TAG_FILENAME_WeatherBlock[];
extern const char PARSEINI_STR_LOADCOLOR[];
extern const char PARSEINI_TAG_ALL[];
extern const char PARSEINI_TAG_NONE[];
extern const char PARSEINI_TAG_TEXT[];
extern const char PARSEINI_TAG_XPOS[];
extern const char PARSEINI_TAG_TYPE[];
extern const char PARSEINI_TAG_DITHER[];
extern const char PARSEINI_TAG_YPOS[];
extern const char PARSEINI_TAG_XSOURCE[];
extern const char PARSEINI_TAG_YSOURCE[];
extern const char PARSEINI_TAG_SIZEX[];
extern const char PARSEINI_TAG_SIZEY[];
extern const char PARSEINI_TAG_SOURCE[];
extern const char PARSEINI_TAG_PPV[];
extern const char PARSEINI_STR_HORIZONTAL[];
extern const char PARSEINI_TAG_RIGHT[];
extern const char PARSEINI_TAG_CENTER_HorizontalAlign[];
extern const char PARSEINI_TAG_VERTICAL[];
extern const char PARSEINI_TAG_BOTTOM[];
extern const char PARSEINI_TAG_CENTER_VerticalAlign[];
extern const char PARSEINI_TAG_ID[];

s32 PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b) __attribute__((noinline));
s32 SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *s) __attribute__((noinline));
void *PARSEINI_JMPTBL_BRUSH_AllocBrushNode(const char *path, void *tail) __attribute__((noinline));
void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(const char *owner, s32 line, s32 bytes, s32 flags) __attribute__((noinline));
void SCRIPT3_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, s32 count) __attribute__((noinline));

static void write_long(void *base, s32 off, s32 value)
{
    *(s32 *)((u8 *)base + off) = value;
}

static s32 string_len(const char *s)
{
    s32 n = 0;
    while (s[n] != '\0') {
        n++;
    }
    return n;
}

s32 PARSEINI_ProcessWeatherBlocks(const char *key, const char *value) __attribute__((noinline, used));

s32 PARSEINI_ProcessWeatherBlocks(const char *key, const char *value)
{
    void *prev_tmp = 0;
    void *node;

    if (PARSEINI_ParsedDescriptorListHead == 0) {
        PARSEINI_CurrentWeatherBlockTempPtr = 0;
        PARSEINI_CurrentWeatherBlockPtr = 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_FILENAME_WeatherBlock) == 0) {
        PARSEINI_CurrentWeatherBlockTempPtr = 0;
        node = PARSEINI_JMPTBL_BRUSH_AllocBrushNode(value, PARSEINI_CurrentWeatherBlockPtr);
        *((u8 *)node + 190) = 1;
        PARSEINI_CurrentWeatherBlockPtr = node;
        if (PARSEINI_ParsedDescriptorListHead == 0) {
            PARSEINI_ParsedDescriptorListHead = node;
        }
    }

    node = PARSEINI_CurrentWeatherBlockPtr;
    if (node == 0) {
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_STR_LOADCOLOR) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(value, PARSEINI_TAG_ALL) == 0) {
            write_long(node, 194, 0);
        } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(value, PARSEINI_TAG_NONE) == 0) {
            write_long(node, 194, 2);
        } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(value, PARSEINI_TAG_TEXT) == 0) {
            write_long(node, 194, 3);
        } else {
            write_long(node, 194, 1);
        }
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_XPOS) == 0) {
        write_long(node, 198, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(value));
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_TYPE) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(value, PARSEINI_TAG_DITHER) == 0) {
            *((u8 *)node + 190) = 2;
        }
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_YPOS) == 0) {
        write_long(node, 202, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(value));
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_XSOURCE) == 0) {
        write_long(node, 206, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(value));
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_YSOURCE) == 0) {
        write_long(node, 210, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(value));
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_SIZEX) == 0) {
        write_long(node, 214, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(value));
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_SIZEY) == 0) {
        write_long(node, 218, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(value));
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_SOURCE) == 0) {
        if (string_len(value) > 0) {
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(value, PARSEINI_TAG_PPV) == 0) {
                *((u8 *)node + 190) = 3;
                return 0;
            }

            prev_tmp = PARSEINI_CurrentWeatherBlockTempPtr;
            PARSEINI_CurrentWeatherBlockTempPtr =
                SCRIPT_JMPTBL_MEMORY_AllocateMemory(Global_STR_PARSEINI_C_3, 670, 12, 0x10001);
            if (PARSEINI_CurrentWeatherBlockTempPtr == 0) {
                return 0;
            }

            *(void **)((u8 *)PARSEINI_CurrentWeatherBlockTempPtr + 8) = 0;
            {
                const char *src = value;
                char *dst = (char *)PARSEINI_CurrentWeatherBlockTempPtr;
                while ((*dst++ = *src++) != '\0') {
                }
            }

            if (*(void **)((u8 *)node + 230) == 0) {
                *(void **)((u8 *)node + 230) = PARSEINI_CurrentWeatherBlockTempPtr;
            } else {
                *(void **)((u8 *)prev_tmp + 8) = PARSEINI_CurrentWeatherBlockTempPtr;
            }
        }
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_STR_HORIZONTAL) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(value, PARSEINI_TAG_RIGHT) == 0) {
            write_long(node, 222, 2);
        } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(value, PARSEINI_TAG_CENTER_HorizontalAlign) == 0) {
            write_long(node, 222, 1);
        } else {
            write_long(node, 222, 0);
        }
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_VERTICAL) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(value, PARSEINI_TAG_BOTTOM) == 0) {
            write_long(node, 226, 2);
        } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(value, PARSEINI_TAG_CENTER_VerticalAlign) == 0) {
            write_long(node, 226, 1);
        } else {
            write_long(node, 226, 0);
        }
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_ID) == 0) {
        SCRIPT3_JMPTBL_STRING_CopyPadNul((char *)((u8 *)node + 191), value, 2);
        *((u8 *)node + 193) = 0;
    }

    return 0;
}
