typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[27];
    UBYTE flags27;
} NEWGRID_Entry;

extern const char NEWGRID_EntryDetailFmtStr[];

extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern LONG NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1(const void *entry, LONG rowIndex, LONG mode);
extern const char *NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(const void *entry, LONG rowIndex, LONG field);
extern void NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes(char *entry, LONG rowIndex);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource(char *rastPort, const char *fmt, ...);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(char *rastPort, const char *fallbackText);

void NEWGRID_DrawEntryFlagBadge(char *rastPort, char *entry, WORD rowIndex, const char *fallbackText, LONG layoutMode)
{
    const NEWGRID_Entry *entryView;
    const char *animPtr;

    entryView = (const NEWGRID_Entry *)entry;
    NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612, 20, layoutMode);

    if (entryView != 0 && (entryView->flags27 & (1u << 4)) != 0) {
        if (NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1(entry, (LONG)rowIndex, 5) != 0) {
            animPtr = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entry, (LONG)rowIndex, 6);
            if (animPtr != 0) {
                NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes(entry, (LONG)rowIndex);
                NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource(
                    rastPort, NEWGRID_EntryDetailFmtStr, 19, animPtr, 20, fallbackText
                );
                return;
            }
        }
    }

    NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(rastPort, fallbackText);
}
