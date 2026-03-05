typedef signed long LONG;
typedef unsigned short UWORD;

extern UWORD LADFUNC_EntryCount;
extern void *LADFUNC_EntryPtrTable[];

extern LONG MATH_DivS32(LONG a, LONG b);
extern void TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview(LONG entryIndex);

void TEXTDISP_DrawNextEntryPreview(void)
{
    void *entry;

    for (;;) {
        entry = LADFUNC_EntryPtrTable[(LONG)LADFUNC_EntryCount];
        if (*(UWORD *)((unsigned char *)entry + 4) == 1) {
            break;
        }

        LADFUNC_EntryCount = (UWORD)MATH_DivS32((LONG)LADFUNC_EntryCount + 1, 46);
    }

    TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview((LONG)LADFUNC_EntryCount);
    LADFUNC_EntryCount = (UWORD)(LADFUNC_EntryCount + 1);
}
