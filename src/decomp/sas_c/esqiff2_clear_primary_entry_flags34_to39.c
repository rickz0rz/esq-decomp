typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE *TEXTDISP_PrimaryEntryPtrTable[];

void ESQIFF2_ClearPrimaryEntryFlags34To39(void)
{
    UWORD d7 = 0;

    while (d7 < TEXTDISP_PrimaryGroupEntryCount) {
        UBYTE *entry = TEXTDISP_PrimaryEntryPtrTable[d7];
        UWORD d6 = 0;

        while (d6 < 6) {
            entry[34 + d6] = 0;
            ++d6;
        }

        ++d7;
    }
}
