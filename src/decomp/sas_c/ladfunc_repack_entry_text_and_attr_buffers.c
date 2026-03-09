typedef signed long LONG;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

extern LONG ED_TextLimit;

extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern char *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern void GROUP_AW_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, LONG n);
extern void GROUP_AW_JMPTBL_MEM_Move(void *dst, const void *src, LONG n);

extern const char Global_STR_LADFUNC_C_24[];
extern const char Global_STR_LADFUNC_C_25[];
extern const char Global_STR_LADFUNC_C_26[];
extern const char Global_STR_LADFUNC_C_27[];

void LADFUNC_RepackEntryTextAndAttrBuffers(char *textBuf, UBYTE *attrBuf)
{
    const LONG ROW_COLS = 40;
    const LONG ROW_TEXT_BUF_LEN = 41;
    const LONG ROW_LAST_COL = 39;
    const LONG CENTER_PAD_LIMIT = 20;
    const UBYTE SPACE_CHAR = ' ';
    const LONG MEMF_PUBLIC_CLEAR = (MEMF_PUBLIC + MEMF_CLEAR);
    LONG srcLen;
    char *textCopy;
    UBYTE *attrCopy;
    LONG outPos;
    LONG row;

    {
        char *p = textBuf;
        while (*p != 0) {
            ++p;
        }
        srcLen = (LONG)(p - textBuf);
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
        char lineText[41];
        UBYTE lineAttr[40];

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
            LONG rowOffset = NEWGRID_JMPTBL_MATH_Mulu32(row, ROW_COLS);
            LONG lineLen;
            LONG k;
            char alignCode;
            UBYTE alignAttr;

            GROUP_AW_JMPTBL_STRING_CopyPadNul(lineText, textCopy + rowOffset, ROW_COLS);

            lineLen = 0;
            while (lineText[lineLen] != 0) {
                ++lineLen;
            }

            for (k = 0; k < lineLen; ++k) {
                lineAttr[k] = attrCopy[rowOffset + k];
            }

            if (lineLen < ROW_COLS) {
                UBYTE fillAttr = lineAttr[lineLen];
                for (k = lineLen; k < ROW_COLS; ++k) {
                    lineText[k] = SPACE_CHAR;
                    lineAttr[k] = fillAttr;
                }
            }

            if (lineText[0] == SPACE_CHAR) {
                alignCode = (lineText[ROW_LAST_COL] == SPACE_CHAR) ? 24 : 26;
            } else {
                alignCode = 25;
            }

            alignAttr = 0;
            if (alignCode == 24) {
                LONG pad = 0;
                alignAttr = lineAttr[0];
                while (pad < CENTER_PAD_LIMIT && lineText[pad] == SPACE_CHAR && lineText[ROW_LAST_COL - pad] == SPACE_CHAR &&
                       lineAttr[pad] == alignAttr && lineAttr[ROW_LAST_COL - pad] == alignAttr) {
                    ++pad;
                }

                if (pad > 0) {
                    LONG keep = ROW_COLS - pad;
                    lineText[keep] = 0;
                    GROUP_AW_JMPTBL_MEM_Move(lineText + pad, lineText, (ROW_TEXT_BUF_LEN - (pad * 2)));
                    GROUP_AW_JMPTBL_MEM_Move(lineAttr + pad, lineAttr, (ROW_COLS - (pad * 2)));
                }
            } else if (alignCode == 25) {
                LONG pad = 0;
                alignAttr = lineAttr[ROW_LAST_COL];
                while (pad < ROW_COLS && lineText[ROW_LAST_COL - pad] == SPACE_CHAR && lineAttr[ROW_LAST_COL - pad] == alignAttr) {
                    ++pad;
                }

                if (pad > 0) {
                    lineText[ROW_COLS - pad] = 0;
                }
            } else if (alignCode == 26) {
                LONG pad = 0;
                alignAttr = lineAttr[0];
                while (pad < ROW_COLS && lineText[pad] == SPACE_CHAR && lineAttr[pad] == alignAttr) {
                    ++pad;
                }

                if (pad > 0) {
                    GROUP_AW_JMPTBL_MEM_Move(lineText + pad, lineText, (ROW_COLS - pad + 1));
                    GROUP_AW_JMPTBL_MEM_Move(lineAttr + pad, lineAttr, (ROW_COLS - pad));
                }
            }

            textBuf[outPos] = alignCode;
            ++outPos;
            attrBuf[outPos - 1] = alignAttr;

            for (k = 0; lineText[k] != 0; ++k) {
                textBuf[outPos] = lineText[k];
                attrBuf[outPos] = lineAttr[k];
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
