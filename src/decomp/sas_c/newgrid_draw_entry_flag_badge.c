typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[27];
    UBYTE flags27;
} NEWGRID_Entry;

extern char NEWGRID_EntryDetailFmtStr;

extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern LONG NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1(UBYTE *entry, LONG rowIndex, LONG mode);
extern char *NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(UBYTE *entry, LONG rowIndex, LONG field);
extern void NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes(UBYTE *entry, LONG rowIndex);
extern void NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource(
    void *rastPort, const char *fmt, LONG fmtRow, const char *src, LONG srcRow, LONG fallbackText);
extern void NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(void *rastPort, LONG fallbackText);

void NEWGRID_DrawEntryFlagBadge(void *rastPort, UBYTE *entry, WORD rowIndex, LONG fallbackText, LONG layoutMode)
{
    NEWGRID_Entry *entryView;
    char *animPtr;

    entryView = (NEWGRID_Entry *)entry;
    NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612, 20, layoutMode);

    if (entryView != 0 && (entryView->flags27 & (1u << 4)) != 0) {
        if (NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1(entry, (LONG)rowIndex, 5) != 0) {
            animPtr = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entry, (LONG)rowIndex, 6);
            if (animPtr != 0) {
                NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes(entry, (LONG)rowIndex);
                NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource(
                    rastPort, &NEWGRID_EntryDetailFmtStr, 19, animPtr, 20, fallbackText
                );
                return;
            }
        }
    }

    NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(rastPort, fallbackText);
}
