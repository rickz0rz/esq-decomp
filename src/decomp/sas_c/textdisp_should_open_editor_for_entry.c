typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_Entry {
    UBYTE pad0[27];
    UBYTE flags27;
    UBYTE pad1[12];
    UBYTE flags40;
} TEXTDISP_Entry;

extern LONG TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor(const TEXTDISP_Entry *entry);

LONG TEXTDISP_ShouldOpenEditorForEntry(const TEXTDISP_Entry *entry)
{
    LONG result = 0;

    if (entry != (TEXTDISP_Entry *)0) {
        if ((entry->flags40 & 0x01) != 0 &&
            (entry->flags40 & 0x08) != 0 &&
            TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor(entry) == 0 &&
            (entry->flags27 & 0x08) == 0) {
            result = 1;
        }
    }

    return result;
}
