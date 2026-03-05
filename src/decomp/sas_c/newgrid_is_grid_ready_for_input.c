typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;

LONG NEWGRID_IsGridReadyForInput(LONG gateSelector)
{
    if (gateSelector == 1) {
        if (TEXTDISP_SecondaryGroupPresentFlag != 0) {
            if (TEXTDISP_SecondaryGroupEntryCount > 0) {
                return 0;
            }
        }
    }

    if (TEXTDISP_PrimaryGroupPresentFlag != 0) {
        if (TEXTDISP_PrimaryGroupEntryCount > 0) {
            return 0;
        }
    }

    return 1;
}
