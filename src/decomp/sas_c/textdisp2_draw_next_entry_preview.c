typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct LADFUNC_PreviewEntry {
    UBYTE pad0[4];
    UWORD state;
} LADFUNC_PreviewEntry;

extern UWORD LADFUNC_EntryCount;
extern void *LADFUNC_EntryPtrTable[];

extern LONG MATH_DivS32(LONG a, LONG b);
extern void TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview(LONG entryIndex);

void TEXTDISP_DrawNextEntryPreview(void)
{
    for (;;) {
        if (((LADFUNC_PreviewEntry *)LADFUNC_EntryPtrTable[(LONG)(UWORD)LADFUNC_EntryCount])->state == 1) {
            break;
        }

        LADFUNC_EntryCount = (UWORD)MATH_DivS32((LONG)(UWORD)LADFUNC_EntryCount + 1, 46);
    }

    TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview((LONG)(UWORD)LADFUNC_EntryCount);
    LADFUNC_EntryCount = (UWORD)((UWORD)LADFUNC_EntryCount + 1);
}
