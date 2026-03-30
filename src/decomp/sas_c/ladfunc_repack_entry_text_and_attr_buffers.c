#include <exec/memory.h>
#include <exec/types.h>

#define MEMF_PUBLIC_CLEAR (MEMF_PUBLIC | MEMF_CLEAR)
#define LADFUNC_ROW_COLS 40
#define LADFUNC_CENTER_LIMIT 20

extern LONG ED_TextLimit;

extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern char *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern char *GROUP_AW_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG n);
extern void GROUP_AW_JMPTBL_MEM_Move(void *dst, const void *src, LONG n);

extern const char Global_STR_LADFUNC_C_24[];
extern const char Global_STR_LADFUNC_C_25[];
extern const char Global_STR_LADFUNC_C_26[];
extern const char Global_STR_LADFUNC_C_27[];

void LADFUNC_RepackEntryTextAndAttrBuffers(char *textBuf, UBYTE *attrBuf)
{
    LONG srcLen;
    char *textCopy;
    UBYTE *attrCopy;
    LONG outPos;
    LONG row;

    srcLen = 0;
    while (textBuf[srcLen] != 0) {
        ++srcLen;
    }

    textCopy = NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_24,
        1214,
        srcLen + 1,
        MEMF_PUBLIC_CLEAR
    );
    attrCopy = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_25,
        1215,
        srcLen,
        MEMF_PUBLIC_CLEAR
    );

    if (textCopy != (char *)0 && attrCopy != (UBYTE *)0) {
        LONG i;

        for (i = 0;; ++i) {
            textCopy[i] = textBuf[i];
            if (textBuf[i] == 0) {
                break;
            }
        }

        for (i = 0; i < srcLen; ++i) {
            attrCopy[i] = attrBuf[i];
        }

        outPos = 0;
        for (row = 0; row < ED_TextLimit; ++row) {
            LONG rowOffset;
            char lineText[LADFUNC_ROW_COLS + 1];
            UBYTE lineAttr[LADFUNC_ROW_COLS];
            LONG lineLen;
            UBYTE mode;
            UBYTE modeAttr;

            rowOffset = NEWGRID_JMPTBL_MATH_Mulu32(row, LADFUNC_ROW_COLS);
            GROUP_AW_JMPTBL_STRING_CopyPadNul(lineText, textCopy + rowOffset, LADFUNC_ROW_COLS);

            lineLen = 0;
            while (lineText[lineLen] != 0) {
                ++lineLen;
            }

            for (i = 0; i < lineLen; ++i) {
                lineAttr[i] = attrCopy[rowOffset + i];
            }

            if (lineLen < LADFUNC_ROW_COLS) {
                UBYTE fillAttr = 0;

                if (lineLen > 0) {
                    fillAttr = lineAttr[lineLen - 1];
                }

                for (i = lineLen; i < LADFUNC_ROW_COLS; ++i) {
                    lineText[i] = ' ';
                    lineAttr[i] = fillAttr;
                }
            }

            if (lineText[0] == ' ') {
                if (lineText[LADFUNC_ROW_COLS - 1] == ' ') {
                    mode = 24;
                } else {
                    mode = 26;
                }
            } else {
                mode = 25;
            }

            if (mode == 24) {
                LONG pad = 0;

                modeAttr = lineAttr[0];
                while (pad < LADFUNC_CENTER_LIMIT &&
                       lineText[pad] == ' ' &&
                       lineText[(LADFUNC_ROW_COLS - 1) - pad] == ' ' &&
                       lineAttr[pad] == modeAttr &&
                       lineAttr[(LADFUNC_ROW_COLS - 1) - pad] == modeAttr) {
                    ++pad;
                }

                if (pad > 0) {
                    LONG keep = LADFUNC_ROW_COLS - pad;

                    lineText[keep] = 0;
                    GROUP_AW_JMPTBL_MEM_Move(lineText, lineText + pad, (LADFUNC_ROW_COLS - (pad * 2)) + 1);
                    GROUP_AW_JMPTBL_MEM_Move(lineAttr, lineAttr + pad, LADFUNC_ROW_COLS - (pad * 2));
                }
            } else if (mode == 25) {
                LONG pad = 0;

                modeAttr = lineAttr[LADFUNC_ROW_COLS - 1];
                while (pad < LADFUNC_ROW_COLS &&
                       lineText[(LADFUNC_ROW_COLS - 1) - pad] == ' ' &&
                       lineAttr[(LADFUNC_ROW_COLS - 1) - pad] == modeAttr) {
                    ++pad;
                }

                if (pad > 0) {
                    lineText[LADFUNC_ROW_COLS - pad] = 0;
                }
            } else {
                LONG pad = 0;

                modeAttr = lineAttr[0];
                while (pad < LADFUNC_ROW_COLS &&
                       lineText[pad] == ' ' &&
                       lineAttr[pad] == modeAttr) {
                    ++pad;
                }

                if (pad > 0) {
                    GROUP_AW_JMPTBL_MEM_Move(lineText, lineText + pad, (LADFUNC_ROW_COLS - pad) + 1);
                    GROUP_AW_JMPTBL_MEM_Move(lineAttr, lineAttr + pad, LADFUNC_ROW_COLS - pad);
                }
            }

            textBuf[outPos] = (char)mode;
            attrBuf[outPos] = modeAttr;
            ++outPos;

            for (i = 0; lineText[i] != 0; ++i) {
                textBuf[outPos] = lineText[i];
                attrBuf[outPos] = lineAttr[i];
                ++outPos;
            }
        }

        textBuf[outPos] = 0;
    }

    if (textCopy != (char *)0) {
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_LADFUNC_C_26,
            1322,
            textCopy,
            srcLen + 1
        );
    }

    if (attrCopy != (UBYTE *)0) {
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_LADFUNC_C_27,
            1324,
            attrCopy,
            srcLen
        );
    }
}
