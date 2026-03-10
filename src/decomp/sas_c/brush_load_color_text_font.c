typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef long LONG;

extern void *Global_REF_DOS_LIBRARY_2;
extern const char Global_STR_BRUSH_C_1[];
extern const char Global_STR_BRUSH_C_2[];
extern const char Global_STR_BRUSH_C_3[];
extern const char Global_STR_BRUSH_C_4[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *tag, LONG line, LONG bytes, ULONG flags);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *tag, LONG line, void *ptr, LONG bytes);
LONG _LVORead(LONG fh, void *buf, LONG len);

#define BRUSH_NULL 0
#define BRUSH_NIBBLE_SHIFT 4
#define BRUSH_LOW_NIBBLE_MASK 0x0FU
#define COLOR_TEXT_FONT_SIZE 96
#define COLOR_FONT_BLOCK_BYTES 3
#define MEMF_PUBLIC 1
#define BRUSH_COLOR_FONT_STATUS_ERROR (-1)
#define BRUSH_COLOR_FONT_STATUS_OK 1
#define BRUSH_ALLOC_LINE 396
#define BRUSH_FREE_ALLOC_FAIL_LINE 416
#define BRUSH_FREE_READ_FAIL_LINE 431
#define BRUSH_FREE_DONE_LINE 445

LONG BRUSH_LoadColorTextFont(LONG fileHandle, LONG byteCount, UBYTE *outBuf)
{
    UBYTE *tmp;
    LONG outputIndex;
    LONG blockOffset;
    UBYTE *p;

    (void)Global_REF_DOS_LIBRARY_2;
    tmp = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_BRUSH_C_1,
        BRUSH_ALLOC_LINE,
        COLOR_TEXT_FONT_SIZE,
        MEMF_PUBLIC
    );
    if (tmp == (UBYTE *)BRUSH_NULL) {
        return BRUSH_COLOR_FONT_STATUS_ERROR;
    }

    if (byteCount > COLOR_TEXT_FONT_SIZE) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_BRUSH_C_2, BRUSH_FREE_ALLOC_FAIL_LINE, (void *)tmp, COLOR_TEXT_FONT_SIZE);
        return BRUSH_COLOR_FONT_STATUS_ERROR;
    }

    if (_LVORead(fileHandle, (void *)tmp, byteCount) != byteCount) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_BRUSH_C_3, BRUSH_FREE_READ_FAIL_LINE, (void *)tmp, COLOR_TEXT_FONT_SIZE);
        return BRUSH_COLOR_FONT_STATUS_ERROR;
    }

    outputIndex = BRUSH_NULL;
    p = tmp;
    for (blockOffset = BRUSH_NULL; blockOffset < byteCount; blockOffset += COLOR_FONT_BLOCK_BYTES) {
        UWORD inner_i;
        for (inner_i = BRUSH_NULL; inner_i < COLOR_FONT_BLOCK_BYTES; inner_i++) {
            outBuf[outputIndex++] = (UBYTE)((*p >> BRUSH_NIBBLE_SHIFT) & BRUSH_LOW_NIBBLE_MASK);
            p++;
        }
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_BRUSH_C_4, BRUSH_FREE_DONE_LINE, (void *)tmp, COLOR_TEXT_FONT_SIZE);
    return BRUSH_COLOR_FONT_STATUS_OK;
}
