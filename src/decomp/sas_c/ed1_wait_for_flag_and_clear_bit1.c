typedef signed short WORD;
typedef unsigned short UWORD;

extern WORD CTASKS_IffTaskDoneFlag;
extern WORD LADFUNC_EntryCount;
extern UWORD ESQIFF_ExternalAssetFlags;

extern void ESQIFF_ReloadExternalAssetCatalogBuffers(WORD mode);

void ED1_WaitForFlagAndClearBit1(void)
{
    while (CTASKS_IffTaskDoneFlag == 0) {
    }

    LADFUNC_EntryCount = 0x2E;
    ESQIFF_ExternalAssetFlags &= (UWORD)0xFFFD;
    ESQIFF_ReloadExternalAssetCatalogBuffers(0);
}
