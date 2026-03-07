typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE ED_MenuStateId;
extern LONG ED_EditCursorOffset;
extern UBYTE ED_EditBufferLive[];

extern void ED_DrawAdEditingScreen(void);
extern void ED_RedrawAllRows(void);
extern void ED_RedrawCursorChar(void);
extern void ED_DrawCurrentColorIndicator(UBYTE colorValue);

void ED_EnterTextEditMode(void)
{
    ED_MenuStateId = 4;

    ED_DrawAdEditingScreen();
    ED_RedrawAllRows();
    ED_RedrawCursorChar();

    ED_DrawCurrentColorIndicator(ED_EditBufferLive[ED_EditCursorOffset]);
}
