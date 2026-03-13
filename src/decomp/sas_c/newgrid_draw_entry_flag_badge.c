typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[27];
    UBYTE flags27;
} NEWGRID_Entry;

extern const char NEWGRID_EntryDetailFmtStr[];

extern LONG DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern LONG CLEANUP_TestEntryFlagYAndBit1(const void *entry, LONG rowIndex, LONG mode);
extern const char *COI_SelectAnimFieldPointer(const void *entry, LONG rowIndex, LONG field);
extern void CLEANUP_UpdateEntryFlagBytes(char *entry, LONG rowIndex);
extern LONG DISPTEXT_BuildLayoutForSource(char *rastPort, const char *fmt, ...);
extern LONG DISPTEXT_LayoutAndAppendToBuffer(char *rastPort, const char *fallbackText);

void NEWGRID_DrawEntryFlagBadge(char *rastPort, char *entry, WORD rowIndex, const char *fallbackText, LONG layoutMode)
{
    const NEWGRID_Entry *entryView;
    const char *animPtr;

    entryView = (const NEWGRID_Entry *)entry;
    DISPTEXT_SetLayoutParams(612, 20, layoutMode);

    if (entryView != 0 && (entryView->flags27 & (1u << 4)) != 0) {
        if (CLEANUP_TestEntryFlagYAndBit1(entry, (LONG)rowIndex, 5) != 0) {
            animPtr = COI_SelectAnimFieldPointer(entry, (LONG)rowIndex, 6);
            if (animPtr != 0) {
                CLEANUP_UpdateEntryFlagBytes(entry, (LONG)rowIndex);
                DISPTEXT_BuildLayoutForSource(
                    rastPort, NEWGRID_EntryDetailFmtStr, 19, animPtr, 20, fallbackText
                );
                return;
            }
        }
    }

    DISPTEXT_LayoutAndAppendToBuffer(rastPort, fallbackText);
}
