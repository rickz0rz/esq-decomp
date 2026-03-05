typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG ED_TextLimit;

extern const char Global_STR_LADFUNC_C_20[];
extern const char Global_STR_LADFUNC_C_21[];
extern const char Global_STR_LADFUNC_C_22[];
extern const char Global_STR_LADFUNC_C_23[];

extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern LONG NEWGRID_JMPTBL_MATH_DivS32(LONG num, LONG den);

void LADFUNC_ReflowEntryBuffers(UBYTE *outText, UBYTE *outAttr)
{
    LONG srcLen = 0;
    UBYTE *tmpText = (UBYTE *)0;
    UBYTE *tmpAttr = (UBYTE *)0;
    LONG outPos = 0;
    LONG row;

    while (outText[srcLen] != 0) {
        ++srcLen;
    }

    tmpText = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_20, 1025, srcLen + 1, 0x10001
    );
    tmpAttr = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_21, 1026, srcLen, 0x10001
    );
    if (tmpText == (UBYTE *)0 || tmpAttr == (UBYTE *)0) {
        goto cleanup;
    }

    {
        LONG i;
        for (i = 0; i <= srcLen; ++i) {
            tmpText[i] = outText[i];
            if (i < srcLen) {
                tmpAttr[i] = outAttr[i];
            }
        }
    }

    {
        LONG srcPos = 0;
        UBYTE ctrl = 0;
        UBYTE pen = 0;

        for (row = 0; row < ED_TextLimit; ++row) {
            UBYTE lineText[41];
            UBYTE lineAttr[41];
            LONG lineLen = 0;
            LONG remaining;
            LONG indent = 0;

            while (tmpText[srcPos] != 0 && lineLen < 40) {
                UBYTE ch = tmpText[srcPos];
                if (ch == 10 || ch == 13) {
                    ++srcPos;
                    continue;
                }
                if (ctrl == 0 && (ch == 24 || ch == 25 || ch == 26)) {
                    ctrl = ch;
                    pen = tmpAttr[srcPos];
                    ++srcPos;
                    continue;
                }
                if (ctrl != 0 && (ch == 24 || ch == 25 || ch == 26)) {
                    break;
                }
                lineText[lineLen] = ch;
                lineAttr[lineLen] = tmpAttr[srcPos];
                ++lineLen;
                ++srcPos;
            }

            lineText[lineLen] = 0;
            remaining = 40 - lineLen;
            if (ctrl == 24) {
                indent = 2;
            } else if (ctrl == 26) {
                indent = 1;
            } else {
                indent = 0;
            }

            while (indent > 0 && remaining > 0) {
                LONG n = NEWGRID_JMPTBL_MATH_DivS32(remaining, indent);
                LONG k;
                for (k = 0; k < n; ++k) {
                    outText[outPos] = 32;
                    outAttr[outPos] = pen;
                    ++outPos;
                }
                remaining -= n;
                --indent;
            }

            {
                LONG i;
                for (i = 0; i < lineLen; ++i) {
                    outText[outPos] = lineText[i];
                    outAttr[outPos] = lineAttr[i];
                    ++outPos;
                }
            }

            while (remaining > 0) {
                outText[outPos] = 32;
                outAttr[outPos] = pen;
                ++outPos;
                --remaining;
            }

            ctrl = 0;
            if (tmpText[srcPos] == 0) {
                break;
            }
        }
    }

    outText[outPos] = 0;

cleanup:
    if (tmpText != (UBYTE *)0) {
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_22, 1146, tmpText, srcLen + 1);
    }
    if (tmpAttr != (UBYTE *)0) {
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_23, 1148, tmpAttr, srcLen);
    }
}
