typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern void *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern UWORD LADFUNC_LineSlotWriteIndex;
extern UWORD LADFUNC_LineControlCodeTable[];
extern char *LADFUNC_LineTextBufferPtrs[];

extern LONG _LVOTextLength(void *graphicsBase, void *rastPort, const char *text, LONG length);
extern void GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding(char *text, LONG controlCode);

void LADFUNC_BuildHighlightLinesFromText(char *src)
{
    const UWORD LINE_SLOT_COUNT = 20;
    const LONG LINE_PIXEL_WIDTH = 624;
    LONG segLen;
    LONG remaining;
    UBYTE control;
    UBYTE ch;
    char segment[84];

    LADFUNC_LineControlCodeTable[LADFUNC_LineSlotWriteIndex] = 4;
    LADFUNC_LineSlotWriteIndex = (UWORD)(LADFUNC_LineSlotWriteIndex + 1);
    if (LADFUNC_LineSlotWriteIndex >= LINE_SLOT_COUNT) {
        LADFUNC_LineSlotWriteIndex = 0;
    }

    segLen = 0;
    remaining = LINE_PIXEL_WIDTH;
    control = src[0];
    if (control == 24 || control == 25 || control == 26) {
        ++src;
    }

    for (;;) {
        ch = *src++;
        if (ch == 0) {
            break;
        }
        if (ch == 13 || ch == 10) {
            continue;
        }

        if (remaining <= 0 || ch == 24 || ch == 25 || ch == 26) {
            char *dst;
            LONG i;

            segment[segLen] = 0;
            GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding(segment, control);

            dst = LADFUNC_LineTextBufferPtrs[LADFUNC_LineSlotWriteIndex];
            for (i = 0;; ++i) {
                dst[i] = segment[i];
                if (segment[i] == 0) {
                    break;
                }
            }

            LADFUNC_LineControlCodeTable[LADFUNC_LineSlotWriteIndex] = 0;
            LADFUNC_LineSlotWriteIndex = (UWORD)(LADFUNC_LineSlotWriteIndex + 1);
            if (LADFUNC_LineSlotWriteIndex >= LINE_SLOT_COUNT) {
                LADFUNC_LineSlotWriteIndex = 0;
            }

            segLen = 0;
            remaining = LINE_PIXEL_WIDTH;
            control = ch;
            continue;
        }

        segment[segLen++] = ch;
        remaining -= _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, &ch, 1);
    }

    segment[segLen] = 0;
    GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding(segment, control);

    {
        char *dst;
        LONG i;

        dst = LADFUNC_LineTextBufferPtrs[LADFUNC_LineSlotWriteIndex];
        for (i = 0;; ++i) {
            dst[i] = segment[i];
            if (segment[i] == 0) {
                break;
            }
        }
    }

    LADFUNC_LineControlCodeTable[LADFUNC_LineSlotWriteIndex] = 0;
    LADFUNC_LineSlotWriteIndex = (UWORD)(LADFUNC_LineSlotWriteIndex + 1);
    if (LADFUNC_LineSlotWriteIndex >= LINE_SLOT_COUNT) {
        LADFUNC_LineSlotWriteIndex = 0;
    }

    LADFUNC_LineControlCodeTable[LADFUNC_LineSlotWriteIndex] = 4;
    LADFUNC_LineSlotWriteIndex = (UWORD)(LADFUNC_LineSlotWriteIndex + 1);
    if (LADFUNC_LineSlotWriteIndex >= LINE_SLOT_COUNT) {
        LADFUNC_LineSlotWriteIndex = 0;
    }
}
