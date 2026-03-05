typedef signed long LONG;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

extern LONG ED_TextLimit;

extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern void GROUP_AW_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, LONG n);
extern void GROUP_AW_JMPTBL_MEM_Move(void *dst, const void *src, LONG n);

extern const char Global_STR_LADFUNC_C_24[];
extern const char Global_STR_LADFUNC_C_25[];
extern const char Global_STR_LADFUNC_C_26[];
extern const char Global_STR_LADFUNC_C_27[];

void LADFUNC_RepackEntryTextAndAttrBuffers(UBYTE *textBuf, UBYTE *attrBuf)
{
    LONG srcLen;
    UBYTE *textCopy;
    UBYTE *attrCopy;
    LONG outPos;
    LONG row;

    {
        UBYTE *p = textBuf;
        while (*p != 0) {
            ++p;
        }
        srcLen = (LONG)(p - textBuf);
    }

    textCopy = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_24,
        1214,
        srcLen + 1,
        (MEMF_PUBLIC + MEMF_CLEAR)
    );

    attrCopy = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_25,
        1215,
        srcLen,
        (MEMF_PUBLIC + MEMF_CLEAR)
    );

    if (textCopy != (UBYTE *)0 && attrCopy != (UBYTE *)0) {
        LONG i;
        UBYTE lineText[41];
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
            LONG rowOffset = NEWGRID_JMPTBL_MATH_Mulu32(row, 40);
            LONG lineLen;
            LONG k;
            UBYTE alignCode;
            UBYTE alignAttr;

            GROUP_AW_JMPTBL_STRING_CopyPadNul((char *)lineText, (const char *)(textCopy + rowOffset), 40);

            lineLen = 0;
            while (lineText[lineLen] != 0) {
                ++lineLen;
            }

            for (k = 0; k < lineLen; ++k) {
                lineAttr[k] = attrCopy[rowOffset + k];
            }

            if (lineLen < 40) {
                UBYTE fillAttr = lineAttr[lineLen];
                for (k = lineLen; k < 40; ++k) {
                    lineText[k] = ' ';
                    lineAttr[k] = fillAttr;
                }
            }

            if (lineText[0] == ' ') {
                alignCode = (lineText[39] == ' ') ? 24 : 26;
            } else {
                alignCode = 25;
            }

            alignAttr = 0;
            if (alignCode == 24) {
                LONG pad = 0;
                alignAttr = lineAttr[0];
                while (pad < 20 && lineText[pad] == ' ' && lineText[39 - pad] == ' ' &&
                       lineAttr[pad] == alignAttr && lineAttr[39 - pad] == alignAttr) {
                    ++pad;
                }

                if (pad > 0) {
                    LONG keep = 40 - pad;
                    lineText[keep] = 0;
                    GROUP_AW_JMPTBL_MEM_Move(lineText + pad, lineText, (41 - (pad * 2)));
                    GROUP_AW_JMPTBL_MEM_Move(lineAttr + pad, lineAttr, (40 - (pad * 2)));
                }
            } else if (alignCode == 25) {
                LONG pad = 0;
                alignAttr = lineAttr[39];
                while (pad < 40 && lineText[39 - pad] == ' ' && lineAttr[39 - pad] == alignAttr) {
                    ++pad;
                }

                if (pad > 0) {
                    lineText[40 - pad] = 0;
                }
            } else if (alignCode == 26) {
                LONG pad = 0;
                alignAttr = lineAttr[0];
                while (pad < 40 && lineText[pad] == ' ' && lineAttr[pad] == alignAttr) {
                    ++pad;
                }

                if (pad > 0) {
                    GROUP_AW_JMPTBL_MEM_Move(lineText + pad, lineText, (40 - pad + 1));
                    GROUP_AW_JMPTBL_MEM_Move(lineAttr + pad, lineAttr, (40 - pad));
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

    if (textCopy != (UBYTE *)0) {
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
