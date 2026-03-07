typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef long LONG;

extern void *Global_REF_DOS_LIBRARY_2;
extern const UBYTE Global_STR_BRUSH_C_1[];
extern const UBYTE Global_STR_BRUSH_C_2[];
extern const UBYTE Global_STR_BRUSH_C_3[];
extern const UBYTE Global_STR_BRUSH_C_4[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);
LONG _LVORead(LONG fh, void *buf, LONG len);

enum {
    COLOR_TEXT_FONT_SIZE = 96,
    COLOR_FONT_BLOCK_BYTES = 3,
    MEMF_PUBLIC = 1,
    BRUSH_COLOR_FONT_STATUS_ERROR = -1,
    BRUSH_COLOR_FONT_STATUS_OK = 1
};

LONG BRUSH_LoadColorTextFont(LONG fh, LONG byte_count, UBYTE *out_buf)
{
    UBYTE *tmp;
    LONG out_i;
    LONG block_i;
    UBYTE *p;

    (void)Global_REF_DOS_LIBRARY_2;
    tmp = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_BRUSH_C_1,
        396,
        COLOR_TEXT_FONT_SIZE,
        MEMF_PUBLIC
    );
    if (tmp == (UBYTE *)0) {
        return BRUSH_COLOR_FONT_STATUS_ERROR;
    }

    if (byte_count > COLOR_TEXT_FONT_SIZE) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_2, 416, (void *)tmp, COLOR_TEXT_FONT_SIZE);
        return BRUSH_COLOR_FONT_STATUS_ERROR;
    }

    if (_LVORead(fh, (void *)tmp, byte_count) != byte_count) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_3, 431, (void *)tmp, COLOR_TEXT_FONT_SIZE);
        return BRUSH_COLOR_FONT_STATUS_ERROR;
    }

    out_i = 0;
    p = tmp;
    for (block_i = 0; block_i < byte_count; block_i += COLOR_FONT_BLOCK_BYTES) {
        UWORD inner_i;
        for (inner_i = 0; inner_i < COLOR_FONT_BLOCK_BYTES; inner_i++) {
            out_buf[out_i++] = (UBYTE)((*p >> 4) & 0x0FU);
            p++;
        }
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_4, 445, (void *)tmp, COLOR_TEXT_FONT_SIZE);
    return BRUSH_COLOR_FONT_STATUS_OK;
}
