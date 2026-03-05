typedef unsigned char UBYTE;

extern UBYTE ED_MenuStateId;

void ED1_ClearEscMenuMode(void)
{
    ED_MenuStateId = 0;
}
